# AGENTS.md — sys_control

Flutter app using **feature-first clean architecture** with **Riverpod 3** and a
**mandated usecase layer**. Read this before touching `lib/`.

## Commands

| Task | Command |
|------|---------|
| Lint / typecheck | `flutter analyze` |
| Full regen (deps + i10n + codegen) | `flutter pub get && flutter pub global run intl_utils:generate && dart run build_runner build --delete-conflicting-outputs` |
| Codegen only | `dart run build_runner build --delete-conflicting-outputs` |
| Codegen watch | `flutter pub get && dart run build_runner watch --delete-conflicting-outputs` |
| Clean | `rm -rf pubspec.lock && flutter clean && flutter pub get` |
| Tests | `flutter test` |

Always run `flutter analyze` after non-trivial edits. Run codegen when you add
or change `@freezed`, `@JsonSerializable`, `@TailorMixin`, or `.arb` files.

## Code style (enforced by analysis_options.yaml)

- **Package imports only**: `package:sys_control/...` — never `../` or `lib/` relative.
- **Single quotes**, **trailing commas**, `prefer_const_constructors`.
- **Page width: 140**. File names: `snake_case.dart`.
- Lint set: `very_good_analysis` 10.x. Public member docs are off; don't add doc comments unless asked.
- No comments unless explicitly requested, or a `ponytail:` simplification note explaining a deliberate shortcut and its upgrade path.

## Architecture

### Top-level layout

```
lib/
  app/                 app shell: routes, themes, root widgets
  core/                cross-feature: extensions, network, observers, routes, utils, failures
  features/{name}/     one folder per feature (see below)
  generated/           ASSET + l10n codegen — never hand-edit
  l10n/                intl_*.arb source files
  main.dart
```

### Feature layout (mandated)

```
lib/features/{name}/
  data/
    models/        {name}_model.dart + .g.dart   (@JsonSerializable, nullable fields, fromEntity/toEntity)
    sources/local/  {name}_local.dart            + Provider
    sources/remote/ {name}_service.dart          + Provider
    repositories/   {name}_repository_impl.dart  + Provider<{Name}Repository>
    mock/           mock_data.dart               (const JSON strings)
  domain/
    entities/       plain classes, required non-null fields, NEVER @JsonSerializable
    enums/          enhanced enums ok (see domain/enums/mode_enum.dart)
    repositories/   abstract class {Name}Repository
    usecases/       {name}_usecase.dart          ← MANDATED
  ui/
    {name}_page.dart              ConsumerWidget / ConsumerStatefulWidget
    providers/{name}_provider.dart   NotifierProvider.autoDispose<Notifier, State>
    states/{name}_state.dart         @freezed + .initial() factory
    widgets/  painters/
```

### Dependency direction (hard rule)

```
ui  →  domain (usecases, entities, enums)   +  ui → ui
data →  domain (entities, enums, repositories abstract)
```

- `domain` imports **nothing** from `data` or `ui`.
- Entities never import models. Models import entities (for `toEntity`).
- UI never imports `data` — not models, not `sources`, not `*RepositoryImpl`.
- Any arrow the other way is a bug. Fix it, don't paper over it.

### The usecase layer (mandated)

`Notifier → UseCase → Repository`. Notifiers **never** import the data layer or
read a `*RepositoryProvider` directly — they read a `*UseCase` provider.

Each usecase lives in `domain/usecases/{name}_usecase.dart`:

```dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:sys_control/core/failures/failure.dart';
import 'package:sys_control/features/{name}/domain/entities/energy_entity.dart';
import 'package:sys_control/features/{name}/domain/repositories/{name}_repository.dart';
import 'package:sys_control/features/{name}/data/repositories/{name}_repository_impl.dart';

final watchEnergyUseCaseProvider = Provider<WatchEnergyUseCase>((ref) {
  return WatchEnergyUseCase(ref.read({name}RepositoryProvider));
});

class WatchEnergyUseCase {
  WatchEnergyUseCase(this._repository);

  final {Name}Repository _repository;

  Stream<Either<Failure, EnergyEntity>> call() {
    return _repository.watchEnergy().map(Either.right).onError((e, _) => Stream.value(Either.left(UnexpectedFailure(e.toString()))));
  }
}
```

Rules:

- Concrete class with a `call` method — **no base `UseCase` interface**. One class per file. `ponytail:` add `abstract interface class UseCase<In,Out>` only if ≥3 usecases share param/result shaping.
- Synchronous reads / commands return `Future<Either<Failure, T>>`. Streaming watch-* ops return `Stream<Either<Failure, T>>`.
- The usecase's `Provider` reads the repository provider; the notifier reads the usecase provider. Keep this one hop.
- One usecase per user action / domain operation. Don't bundle unrelated calls into a single "facade" usecase.
- Notifiers fold the `Either`: `loading` state → result → `data`/`error` state. Use `state = state.copyWith(...)`.

### Riverpod conventions

- `Provider` for service / local / repository / usecase (singletons, no state).
- `NotifierProvider.autoDispose<{Notifier}, {State}>` for page state. Drop `autoDispose` only when state must survive navigation.
- `ref.onDispose` cancels every `StreamSubscription` the notifier opens (see `dashboard_provider.dart:21`).
- State classes are `@freezed` `abstract class {Name}State with _${Name}State` with a `factory {Name}State.initial()` (see `dashboard_state.dart`).
- Read providers with `ref.watch` in `build`, `ref.read` in event handlers.

### Data layer

- **Models** (`@JsonSerializable`): nullable fields, `@JsonKey(name: 'snake_case')`, `factory .fromJson(JSON)`, `factory .fromEntity(...)`, `toEntity()`, `JSON toJson()`. Import `core/utils/typedefs.dart` for `JSON`.
- **Repository abstract** in `domain/repositories/` — methods return `Stream`/`Future` of **entities**, never models.
- **Repository impl** in `data/repositories/`: `final class {Name}RepositoryImpl extends {Name}Repository`, takes `service` + `local` via constructor, exposes a `Provider<{Name}Repository>` that wires them. Cache-first streaming pattern: yield local if present, fetch remote, save, yield remote, swallow remote error only if local was non-null (see `dashboard_repository_impl.dart`).
- **Remote source** (`{name}_service.dart`): `@JsonSerializable`-aware, returns models. Provider-wrapped.
- **Local source** (`{name}_local.dart`): persistence stub. Returns models or `null`. Provider-wrapped.
- **Mock** (`mock_data.dart`): `const String` JSON for dev. Remote sources read it until a real API exists.

### Routing (go_router)

1. Add an entry to `app/routes/route_enum.dart` (`name('/snake-case-path')`).
2. Add a `GoRoute` to `app/routes/app_routes.dart` via `buildMaterialPage(key, name, child)`.
3. Navigate with `AppRouter.pushNamed(RouteEnum.{name}.name)`, `AppRouter.pushReplacement`, etc. Never call `go_router` directly from widgets.

### Extensions (tech-debt note)

Import the **singular** forms: `context_extension.dart`, `widget_extension.dart`, `string_extensions.dart`, `color_extension.dart`, `gesture_extension.dart`. The matching `*_extensions.dart` files are stale duplicates — **do not add new content to them or import them**. `base_route.dart` (singular) is the live one; `base_routes.dart` is the duplicate.

### Generated files — never hand-edit

`.g.dart`, `.freezed.dart`, `.tailor.dart`, anything under `lib/generated/` and `lib/l10n/`. Regenerate with the `gen` command. They're excluded from `flutter analyze`.

### Localization

Keys live in `lib/l10n/intl_*.arb`. Regenerate with `flutter pub global run intl_utils:generate` (or the `gen` command). Use `S.of(context).{key}` inside widgets, `S.current.{key}` outside.

### Dependencies

Already available — prefer these over adding new ones: `fpdart` (Either/TaskEither for usecases), `dio`, `go_router`, `freezed` + `json_serializable`, `theme_tailor` + `theme_tailor_annotation` (`@TailorMixin`), `fl_chart`, `flutter_animate`, `lottie`. Don't add a dependency for what a few lines can do.

### UI conventions

- **TextStyle access**: Always `context.customTheme.{token}.copyWith(...)`. Never raw `Theme.of(context).textTheme`. The 4 tokens: `blackTextStyle`, `grayTextStyle`, `lightGrayTextStyle`, `whiteTextStyle`. Extract `.color` from tokens for non-text widgets (icons, borders, decorations). Colors live in `app/themes/colors.dart` as `const` values.
- **Card decoration**: `Container` + `context.theme.cardColor` + `BorderRadius.circular(12–15)` + `context.cardShadow` (from `context_extension.dart`). See `settings_page.dart` `_CategoryTile` for the pattern.
- **ListTile**: Global `listTileTheme` in light/dark themes handles base styling. Use `SettingsListTile` for settings sub-pages. For one-off tiles, private `_CategoryTile` in the same file is fine.
- **Responsive scaling**: `LayoutBuilder` + `scale = constraints.maxWidth / designWidth`. Multiply spacing/sizes by `scale`. Design widths: 360 (thermostat), 540 (dashboard right column).
- **Spacing**: Use `Column(spacing: N)` / `Row(spacing: N)` over manual `SizedBox` between children. Common values: 4, 6, 8, 10, 12, 15, 16, 20, 24. Use `const SizedBox.shrink()` for empty/null returns.
- **Widget extraction**: Private `_` classes for tightly-coupled sub-widgets in the same file. Public reusable widgets in `widgets/` subdirectory. `_build*` methods for large pages.
- **AppBar**: Transparent bg, no elevation, `AppRouter.pop` on back.
- **Dialogs**: `AlertDialog` with `context.theme.cardColor` bg, `BorderRadius.circular(14)`.
- **Widget helpers**: `widget.onTap(context: context, onTap: ...)`, `widget.applySafeArea()`, `widget.toCenter()`, `widget.withTooltip(...)` from `widget_extension.dart`.

## Inter-project contract with scheduler (Qt)

`engine/` holds vendored Flutter embedder archives (`flutter_engine.dll` /
`libflutter_engine.so` + `flutter_embedder.h`) for embedding into a native
host — committed to git, not used by the standard `flutter run`.

This app and the Qt app at `D:\TechNova\scheduler` are separate processes
coupled **only** through one shared SQLite DB. Changing any of the following
unilaterally breaks the sibling app — coordinate schema/behavior changes in
both repos in the same change set. Mirrored rules live in `scheduler/AGENTS.md`.

1. **DB path resolution** (`core/database/db_path_resolver.dart` mirrors Qt's
   `DbPathResolver`): `<config>/LG/deluxe.json` key `db_path` (Windows:
   `%LOCALAPPDATA%\LG\`) → else `LG/deluxe.db`; legacy `sys_control.sqlite` is
   migrated. Both apps must resolve identically.
2. **journal_mode = DELETE, busy_timeout = 3000** (`app_database.dart`). Never
   switch to WAL — it causes SQLITE_BUSY contention between the two processes.
3. **Adoption-safe migrations**: drift migrations create only *missing* tables
   so Qt-created schemas are adopted, never recreated. The `schedules` table
   uses Qt's camelCase schema — Qt is the source of truth; column changes must
   land in both `app_database.dart` and the Qt side.
4. **`device_state` table** (unitId PK: `IDU-1`/`ODU-1`; unitType, temperature,
   humidity, targetTemp, mode, fanSpeed, isOn, updatedAt): shared middleware —
   this app's sensor sim writes it, Qt's DashboardBackend reads/writes back.
   Keep the camelCase column names.
5. **External-change detection** (`external_db_change_detector.dart` mirrors
   Qt's `DatabaseManager::enableExternalChangeDetection`): poll
   `PRAGMA data_version` every 2s + watch db dir mtime (300ms debounce),
   invalidate drift streams on external commits. Qt expects ~2s propagation —
   don't lengthen the interval. Whole-file DB replacement re-creates the DB
   provider; that's the fallback path, not the normal one.

## Working rules

- **Read before write.** Trace the full flow a change touches (every file, every caller) before editing. The shortest diff in the wrong place is a second bug.
- **Bug fix = root cause.** Grepp every caller of the function you touch; guard once in the shared function, not in each caller.
- **No unrequested abstractions.** No interface with one implementation, no factory for one product, no config for a value that never changes. Deletion over addition.
- **Generated code is off-limits** for hand edits; change the source and regen.
- **Never commit** unless explicitly asked.
