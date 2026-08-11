import 'package:mobile/core/models/pause_enums.dart';

/// In-memory state for the current run, carried across the five steps.
/// Reset at the start of each run; consumed when the event is written.
class RitualSessionService {
  Feeling? feeling;
  String? substitute;

  void startNewRun() {
    feeling = null;
    substitute = null;
  }
}
