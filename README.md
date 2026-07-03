# Pause

An Android-first, fully offline Flutter app that helps you sit with a
compulsive urge instead of acting on it. When the pull comes, you open Pause
and move through a short, deliberately un-rushed ritual that adds a moment of
honest friction and points you toward a better next action.

Pause is meant to feel like a refuge, not a blocker. It is an ally, never a
warden.

## How it works

A single run walks through five steps, then persists one event on the device:

1. **Home** — one calm entry point.
2. **Name the feeling** — one tap on what's underneath the urge.
3. **Breath ritual** — box breathing (4-7-8), un-skippable, the centre of the
   experience.
4. **Off-ramp** — pick a substitute action to reach for instead.
5. **Resolution** — "Did the urge pass?", answered without judgment either way.

A **Progress** view reads the local history back to you — how often you've
shown up, the feeling underneath, when it tends to hit — and a first-run
**Setup** lets you choose your substitute actions.

## Product principles

These are hard constraints, not preferences:

- **Fully offline.** No network, no accounts, no analytics, no cloud. All data
  stays on the device. The app is triggered manually — it never blocks or
  overlays anything.
- **No shame.** A run where the urge did not pass is warm and encouraging. A
  broken streak is shown with resilience, never as punishment.
- **The urge stays unnamed.** The UI never names a specific habit — always
  "the urge".
- **No alarm language.** No red, no locks, no "blocked" framing in the flow.
- **The breath step is un-skippable** until it completes.

## Tech stack

- **Flutter** (pinned to 3.44.1 in CI), **Dart** SDK `>=3.0.3 <4.0.0`
- **Stacked** MVVM with **get_it** service location
- **Drift** (SQLite) for on-device event persistence
- **shared_preferences** for small settings (substitutes, first-run flag)
- Feature-first project layout

## Getting started

Prerequisites: the Flutter SDK (3.44.1 recommended) and an Android device or
emulator. Verify your setup with `flutter doctor`.

```bash
git clone git@github.com:rup1n13-san/Pause.git
cd Pause
flutter pub get
dart run build_runner build   # generates Stacked + Drift code
flutter run
```

The repository root is the Flutter project; run all commands from there.

## Development

```bash
flutter analyze                # static analysis (the per-change quality gate)
flutter test                   # run the full test suite
flutter test test/path_test.dart   # run a single test file
dart run build_runner build    # re-run codegen after changing routes,
                               # services, or the Drift schema
```

Stacked scaffolding keeps routing and DI in sync:

```bash
stacked create view <name>     # view + viewmodel + test
stacked create service <name>  # service, registered in the locator
```

`lib/app/app.dart` holds the `@StackedApp` annotation — the single source for
routes and dependencies. Generated files (`app.router.dart`, `app.locator.dart`,
and the Drift `*.g.dart`) are not edited by hand.

## Project structure

```
lib/
  app/            Stacked app wiring (routes, locator) and generated output
  core/
    data/         Drift database and generated code
    models/       domain enums and derived read-models (e.g. progress insights)
    services/     database, settings, and ritual-session services
    theme/        design tokens, text styles, and the app theme
    widgets/      shared UI (tap surfaces, text links)
  features/       one folder per screen: view + viewmodel (+ widgets)
test/             mirrors lib/ — model, viewmodel, and data-layer tests
```

## Contributing

- Branch off `dev` (the integration branch); `main` is production. Name
  branches `type/scope/short-desc`, one per feature.
- Commit as `type(scope): subject` in the imperative, lowercase, under about
  60 characters. Allowed types: `feat`, `fix`, `refactor`, `chore`, `ui`/`ux`,
  `style`, `docs`. Keep any body to a few bullets covering what and why.
- Run `flutter analyze` and `flutter test` before opening a pull request.
- Match the existing patterns rather than introducing new ones — Stacked MVVM,
  feature-first folders, and the shared theme tokens.
- The design export under `Pause_ Urge-interrupt app-handoff/` is the visual
  source of truth. Where it is silent (motion, timing, haptics), the product
  principles above govern.

Continuous integration builds the APK and app bundle and distributes a test
build on pull requests into `dev` and on merges to `dev`.

## Privacy

Everything Pause records lives only on the device it runs on. There is no
server, no account, and nothing to sign in to.

## License

No license has been declared for this project yet.
