# Development

Setup, configuration, tooling, and testing. Commands are defined in the `Makefile` (`make help` lists them).

## Flutter version (FVM)

The project is pinned to **Flutter 3.44.2** (Dart 3.12) with [FVM](https://fvm.app). The version lives in
`Kale/.fvmrc`. The locked code generators (analyzer 7.x, riverpod_generator 2.x) can't parse newer Dart syntax,
so on Flutter 3.47+ `build_runner` hangs with `Missing implementation of visitDotShorthandPropertyAccess`.

```bash
dart pub global activate fvm   # once per machine (or: choco install fvm / brew install fvm)
fvm install                    # in Kale/: installs the version from .fvmrc
fvm flutter --version          # should print Flutter 3.44.2
```

- Run Flutter and Dart through FVM: `fvm flutter …`, `fvm dart …`. The `make` targets already do this. To use
  another SDK, pass it explicitly: `make test FLUTTER=flutter DART=dart`.
- `pub get` on another Flutter version fails with
  `Because kale requires SDK version >=3.6.1 <3.13.0, version solving failed.` Pub ignores the upper bound of
  the `flutter:` constraint, so the pin is enforced through the Dart `sdk:` upper bound in `pubspec.yaml`.
- `dart pub global activate` installs `fvm` into the pub cache `bin` folder (on Windows
  `%LOCALAPPDATA%\Pub\Cache\bin`). Add it to your `PATH`, or call `fvm` by its full path.
- **Windows:** FVM links the SDK into `Kale/.fvm/` (git-ignored) with a symlink, and Flutter needs symlinks for
  plugins, so enable **Developer Mode** (`start ms-settings:developers`). Without it, `fvm use` fails to create
  the link and `pub get` warns "Building with plugins requires symlink support". `fvm flutter` / `fvm dart`
  still resolve the SDK from the FVM cache, so codegen, analyze and tests work, but building or running the app
  on a device needs Developer Mode.
- IDEs: point the Flutter SDK path at `Kale/.fvm/flutter_sdk` (VS Code: `"dart.flutterSdkPath"`), or at the
  cached SDK under `~/fvm/versions/3.44.2`.
- Lifting the pin means upgrading the generators first (Riverpod 3 and so on); see #23. Change `.fvmrc`, the `environment:` bounds in `pubspec.yaml` and `flutter-version` in the CI
  workflow together.

## Setup

```bash
fvm install            # see "Flutter version (FVM)" above
cp .env.example .env   # then fill in Supabase + Google values
make get               # fvm flutter pub get
make gen               # code generation
make run
```

There is a single `.env` (git-ignored). `.env.example` is the template. There are no per-environment
`.env.development` / `.env.staging` / `.env.production` files in the repo, although `.gitignore` reserves
those names.

## Environment variables

Read through `AppConfig` (`core/config/`), except the mock flags, which providers read from `dotenv` directly.

| Variable | Purpose |
|---|---|
| `ENV_NAME` | `development` / `staging` / `production` |
| `BASE_URL` | Supabase project URL |
| `SUPABASE_ANON_KEY` | Supabase anon (public) key |
| `ENABLE_LOGGING` | Logs and Dio logging interceptor |
| `SHOW_DEBUG_BANNER` | Flutter debug banner |
| `GOOGLE_WEB_CLIENT_ID`, `GOOGLE_ANDROID_CLIENT_ID`, `GOOGLE_IOS_CLIENT_ID` | Google Sign-In (the web client ID is the one Supabase uses) |
| `SENTRY_DSN` | Reserved; no Sentry reporter is implemented yet |
| `FCM_SERVER_KEY` | Reserved |

> **`.env` is bundled as a Flutter asset**, so every value in it ships inside the app binary. Put only
> client-safe values there (the Supabase anon key is fine). Server secrets such as a service-role key or FCM
> server key belong on the backend.

### Mock datasources

Each remote datasource has an in-memory mock, toggled per feature:

| Flag | Default when unset |
|---|---|
| `USE_MOCK_AUTH` | `false` (but `.env.example` sets it to `true`) |
| `USE_MOCK_TRANSACTIONS` | `false` |
| `USE_MOCK_BUDGETS` | `false` |
| `USE_MOCK_SAVINGS` | **`true`**: savings stays mocked unless you explicitly set it to `false` |

## Code generation

`build_runner` generates code for Freezed, json_serializable, Riverpod (`@riverpod`), and Drift
(`@DriftDatabase`, `@DriftAccessor`). Generated `*.g.dart` / `*.freezed.dart` files are committed and
excluded from analysis.

```bash
make gen     # one-off build (--delete-conflicting-outputs)
make watch   # rebuild on save
```

Changing a Drift table also needs a `schemaVersion` bump and a migration step (see `docs/offline_sync.md`).

## Localization

- ARB sources are in `lib/l10n/` (`app_en.arb` is the template, `app_fr.arb` the French copy). `make l10n`
  regenerates `AppLocalizations`.
- Add every new key to both files. Access strings through the `context.l10n` extension.

## Lint and format

- `very_good_analysis` + `custom_lint` + `riverpod_lint`. Rule overrides live in `analysis_options.yaml`.
- `make analyze`, `dart format .`

## Testing

- `make test` runs unit and widget tests. Run a single file with `flutter test path/to/file_test.dart`.
- Use `mocktail`. Shared mocks and helpers are in `test/helpers/` (`mock_providers.dart`, `test_helpers.dart`).
- Mirror the `lib/` path under `test/`. Cover use cases, repository implementations (map each exception to the
  right `Failure`), and notifiers (state transitions).
- Integration tests (`make integration`, needs a device or emulator) live in `integration_test/` and use the
  **robot pattern** (`integration_test/robots/`). The current auth flow test is a placeholder.
- Current coverage is **auth only**. Transactions, budget, savings, dashboard, and the sync engine have no tests.

## Assets

- App icons: `make icons` (config in `flutter_launcher_icons.yaml`)
- Native splash: `make splash` (config in `flutter_native_splash.yaml`)
- Store listing copy: `store_listings/`

## CI

`.github/workflows/ci.yml` defines a quality job (format check, analyze, test) followed by a debug APK build.

> ⚠️ The git repository root is the parent folder (`Kale_mobile/`), but the workflow sits in `Kale/.github/`.
> GitHub only reads `.github/workflows/` at the repo root, so **this workflow does not run**. Move it to
> `Kale_mobile/.github/workflows/` (its `working-directory: Kale` already assumes that location) to enable it.
