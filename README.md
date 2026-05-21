# System Control

A smart AC control app built with Flutter — thermostat control, scheduling,
energy monitoring, and settings.

## Features

- **Dashboard** — system overview with energy charts
- **Thermostat** — temperature control with mode and fan speed selection
- **Schedules** — create and manage AC schedules
- **History** — past energy usage and activity
- **Settings** — general, AC, energy, appearance, and language preferences

## Requirements

- Flutter SDK (Dart ^3.11.5)

## Getting started

```sh
flutter pub get
flutter run
```

## Codegen

Run after adding or changing `@freezed`, `@JsonSerializable`, `@TailorMixin`,
or `.arb` files:

```sh
flutter pub get && flutter pub global run intl_utils:generate && dart run build_runner build --delete-conflicting-outputs
```

## Other commands

| Task | Command |
|------|---------|
| Analyze | `flutter analyze` |
| Test | `flutter test` |
| Codegen watch | `flutter pub get && dart run build_runner watch --delete-conflicting-outputs` |
| Clean | `rm -rf pubspec.lock && flutter clean && flutter pub get` |

## Architecture

Feature-first clean architecture with Riverpod 3 and a mandated usecase layer
(`Notifier → UseCase → Repository`):

```
lib/
  app/                 app shell: routes, themes, root widgets
  core/                cross-feature: extensions, network, utils, failures
  features/{name}/     data/ · domain/ · ui/ per feature
  generated/           codegen output — never hand-edit
  l10n/                intl_*.arb localization sources
```

Dependency direction is enforced: `ui → domain ← data`. Entities are plain
classes, models wrap them for JSON, and UI never imports the data layer
directly — always through usecases.

See [AGENTS.md](AGENTS.md) for full conventions.

## Localization

Keys live in `lib/l10n/intl_*.arb`. Use `S.of(context).key` inside widgets,
then regenerate with `flutter pub global run intl_utils:generate`.
