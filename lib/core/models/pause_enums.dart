/// Domain enums for the Pause ritual. The UI never names the specific habit —
/// these describe the feeling underneath and the outcome of a run.

enum Feeling { bored, stressed, tired, lonely, autopilot, somethingElse }

extension FeelingLabel on Feeling {
  String get label => switch (this) {
    Feeling.bored => 'Bored',
    Feeling.stressed => 'Stressed',
    Feeling.tired => 'Tired',
    Feeling.lonely => 'Lonely',
    Feeling.autopilot => 'Autopilot',
    Feeling.somethingElse => 'Something else',
  };
}

enum UrgeOutcome { passed, notYet }

extension UrgeOutcomeValue on UrgeOutcome {
  /// Stable string persisted to the database.
  String get value => this == UrgeOutcome.passed ? 'passed' : 'not_yet';
}
