import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/core/data/database/app_database.dart';
import 'package:mobile/core/models/progress_insights.dart';

UrgeEvent _event({
  required DateTime at,
  String feeling = 'Bored',
  String outcome = 'passed',
}) =>
    UrgeEvent(
      id: 0,
      createdAt: at,
      feeling: feeling,
      substitute: null,
      outcome: outcome,
    );

void main() {
  final now = DateTime(2026, 7, 3, 20); // an evening

  group('ProgressInsights', () {
    test('below the threshold hides insights but still counts', () {
      final insights = ProgressInsights.fromEvents([
        _event(at: now),
        _event(at: now),
      ], now: now);
      expect(insights.total, 2);
      expect(insights.hasInsights, isFalse);
    });

    test('reaching the threshold surfaces insights', () {
      final events = List.generate(3, (_) => _event(at: now));
      expect(ProgressInsights.fromEvents(events, now: now).hasInsights, isTrue);
    });

    test('top feeling is the most frequent charted feeling', () {
      final insights = ProgressInsights.fromEvents([
        _event(at: now, feeling: 'Stressed'),
        _event(at: now, feeling: 'Stressed'),
        _event(at: now, feeling: 'Bored'),
      ], now: now);
      expect(insights.topFeeling, 'Stressed');
      final top = insights.feelingBars.firstWhere((b) => b.name == 'Stressed');
      expect(top.isTop, isTrue);
      expect(top.fraction, 1.0);
    });

    test('"Something else" counts toward the total but is never charted', () {
      final insights = ProgressInsights.fromEvents([
        _event(at: now, feeling: 'Something else'),
        _event(at: now, feeling: 'Something else'),
        _event(at: now, feeling: 'Bored'),
      ], now: now);
      expect(insights.total, 3);
      expect(
        insights.feelingBars.map((b) => b.name),
        isNot(contains('Something else')),
      );
      expect(insights.topFeeling, 'Bored');
    });

    test('the peak bucket drives the line and banner word', () {
      final events = List.generate(
        3,
        (_) => _event(at: DateTime(2026, 7, 3, 19)), // 17..22 → evening
      );
      final insights = ProgressInsights.fromEvents(events, now: now);
      expect(insights.peakWord, 'most often in the evening');
      expect(insights.peakLine, contains('evening'));
    });

    test('prediction v2 argmax weights late-night usage heavier', () {
      final events = [
        _event(at: DateTime(2026, 7, 3, 10)),
        _event(at: DateTime(2026, 7, 3, 10)),
        _event(at: DateTime(2026, 7, 3, 23)),
        _event(at: DateTime(2026, 7, 3, 23)),
      ];

      final buckets = [
        const UsageBucket(
            day: 20260703, hour: 23, screenMinutes: 50, unlocks: 10),
      ];

      final insights =
          ProgressInsights.fromEvents(events, usageBuckets: buckets, now: now);

      // Without usage, 10 AM would win (earlier in the loop).
      // With usage, 11 PM gets late-night risk multiplier, so 11 PM wins.
      expect(insights.peakHour, 23);
    });

    test('week count and banner reflect only the last seven days', () {
      final insights = ProgressInsights.fromEvents([
        _event(at: now), // today
        _event(at: now.subtract(const Duration(days: 3))), // within week
        _event(at: now.subtract(const Duration(days: 10))), // outside week
      ], now: now);
      expect(insights.weekCount, 2);
      expect(insights.homeBanner, startsWith('noticed 2× this week'));
    });

    test('14-day cells mark days with events, oldest first', () {
      final insights = ProgressInsights.fromEvents([
        _event(at: now), // 0 days ago → last cell
        _event(at: now.subtract(const Duration(days: 13))), // → first cell
      ], now: now);
      expect(insights.dayCells.length, 14);
      expect(insights.dayCells.first, isTrue);
      expect(insights.dayCells.last, isTrue);
      expect(insights.dayCells[5], isFalse);
    });
  });
}
