import 'package:mobile/core/data/database/app_database.dart';

/// One feeling's bar in the "feeling underneath" breakdown.
class FeelingBar {
  const FeelingBar({
    required this.name,
    required this.fraction,
    required this.isTop,
  });

  final String name;
  final double fraction; // 0..1, relative to the most-frequent feeling
  final bool isTop;
}

/// Read-only analytics derived from the local event history. Pure and
/// deterministic (inject [now] in tests) — the Progress view and the Home
/// banner both render straight from this, so nothing here touches Drift or
/// the clock except through the injected reference.
class ProgressInsights {
  const ProgressInsights({
    required this.total,
    required this.hasInsights,
    required this.topFeeling,
    required this.feelingBars,
    required this.peakLine,
    required this.peakWord,
    required this.peakHour,
    required this.hourDensity,
    required this.dayCells,
    required this.weekCount,
    required this.homeBanner,
  });

  /// Below this many events the charts would be noise, so the UI shows a warm
  /// "not enough yet" state instead of fabricating a pattern from thin data.
  static const insightThreshold = 3;

  /// The five feelings that get charted. "Something else" is counted in the
  /// total but never shown as a bar — matching the design.
  static const _feelingOrder = [
    'Bored',
    'Stressed',
    'Tired',
    'Lonely',
    'Autopilot',
  ];

  final int total;
  final bool hasInsights;
  final String topFeeling;
  final List<FeelingBar> feelingBars;
  final String peakLine;
  final String peakWord;
  final int peakHour;
  final List<double> hourDensity; // 24 values, each 0..1
  final List<bool> dayCells; // 14 days, oldest first
  final int weekCount;
  final String homeBanner;

  factory ProgressInsights.fromEvents(
    List<UrgeEvent> events, {
    List<UsageBucket> usageBuckets = const [],
    DateTime? now,
  }) {
    final reference = now ?? DateTime.now();
    final today = DateTime(reference.year, reference.month, reference.day);
    int daysAgo(DateTime t) =>
        today.difference(DateTime(t.year, t.month, t.day)).inDays;

    final total = events.length;

    // Feeling counts (only the five charted feelings).
    final fCount = {for (final f in _feelingOrder) f: 0};
    for (final e in events) {
      if (fCount.containsKey(e.feeling)) {
        fCount[e.feeling] = fCount[e.feeling]! + 1;
      }
    }
    final fMax = [1, ...fCount.values].reduce((a, b) => a > b ? a : b);
    var topFeeling = _feelingOrder.first;
    var topN = -1;
    for (final f in _feelingOrder) {
      if (fCount[f]! > topN) {
        topN = fCount[f]!;
        topFeeling = f;
      }
    }
    final feelingBars = _feelingOrder
        .map(
          (name) => FeelingBar(
            name: name,
            fraction: fCount[name]! / fMax,
            isTop: name == topFeeling,
          ),
        )
        .toList();

    // Time-of-day buckets → the "when it tends to hit" line.
    const buckets = ['morning', 'afternoon', 'evening', 'late'];
    final bCount = {for (final b in buckets) b: 0};
    for (final e in events) {
      final b = _bucket(e.createdAt.hour);
      bCount[b] = bCount[b]! + 1;
    }
    var peakB = buckets.first;
    var peakN = -1;
    for (final b in buckets) {
      if (bCount[b]! > peakN) {
        peakN = bCount[b]!;
        peakB = b;
      }
    }
    final peak = _peakMap[peakB]!;

    // 24-hour density, normalised to the busiest hour.
    final hCount = List.filled(24, 0);
    for (final e in events) {
      hCount[e.createdAt.hour % 24]++;
    }
    final hMax = [1, ...hCount].reduce((a, b) => a > b ? a : b);
    final hourDensity = hCount.map((c) => c / hMax).toList();

    // Usage density calculation (from buckets)
    final usageScreenMins = List.filled(24, 0);
    for (final b in usageBuckets) {
      usageScreenMins[b.hour] += b.screenMinutes;
    }
    final usageMax = [1, ...usageScreenMins].reduce((a, b) => a > b ? a : b);
    final usageDensity = usageScreenMins.map((m) => m / usageMax).toList();

    // Prediction v2 risk score
    var peakHour = 0;
    var maxRisk = -1.0;
    for (var i = 0; i < 24; i++) {
      final lateWindowWeight = (i >= 22 || i < 5) ? 0.5 : 0.0;
      final risk = hourDensity[i] + (usageDensity[i] * lateWindowWeight);
      if (risk > maxRisk) {
        maxRisk = risk;
        peakHour = i;
      }
    }

    // Last 14 days, oldest first.
    final dayCells = List.generate(
      14,
      (i) => events.any((e) => daysAgo(e.createdAt) == 13 - i),
    );

    final weekCount = events.where((e) => daysAgo(e.createdAt) <= 6).length;

    return ProgressInsights(
      total: total,
      hasInsights: total >= insightThreshold,
      topFeeling: topFeeling,
      feelingBars: feelingBars,
      peakLine: peak.line,
      peakWord: peak.word,
      peakHour: peakHour,
      hourDensity: hourDensity,
      dayCells: dayCells,
      weekCount: weekCount,
      homeBanner: 'noticed $weekCount× this week · ${peak.word}',
    );
  }

  static String _bucket(int h) {
    if (h >= 5 && h < 12) return 'morning';
    if (h >= 12 && h < 17) return 'afternoon';
    if (h >= 17 && h < 22) return 'evening';
    return 'late';
  }

  static const _peakMap = <String, ({String line, String word})>{
    'morning': (
      line: 'Usually in the morning — early in the day.',
      word: 'most often in the morning',
    ),
    'afternoon': (
      line: 'Usually in the afternoon.',
      word: 'most often midday',
    ),
    'evening': (
      line: 'Usually in the evening, as the day winds down.',
      word: 'most often in the evening',
    ),
    'late': (
      line: 'Usually late at night — most often after 10pm.',
      word: 'most often after 10pm',
    ),
  };
}
