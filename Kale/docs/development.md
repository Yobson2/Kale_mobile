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
make get               # flutter pub get
make gen               # code generation
make run               # every datasource mocked, no backend needed
```

To talk to a real backend, create the define file for that environment first (next section).

## Environments

There are three backends and two build flavors:

| Environment | Backend | Flavor | Define file | Run with |
|---|---|---|---|---|
| Mock | none (in-memory datasources) | `staging` | `config/mock.json` (tracked) | `make run` |
| Local | Supabase CLI stack in Docker | `staging` | `config/local.json` | `make run-local` |
| Staging | Supabase staging project | `staging` | `config/staging.json` | `make run-staging` |
| Production | Supabase production project | `production` | `config/production.json` | `make run-prod` |

Each `make` target is shorthand for `flutter run --flavor <flavor> --dart-define-from-file=config/<file>.json`.
Release builds: `make build-staging` (APK) and `make build-prod` (app bundle).

### Flavors

- **Android** (`android/app/build.gradle`, dimension `environment`):
  - `staging` installs as `com.kale.app.staging`, labelled "Kalé Staging" (`android/app/src/staging/res`), so it
    sits next to the production app on the same phone.
  - `production` installs as `com.kale.app`.
  - With flavors defined, a plain `flutter run` no longer works on Android: always pass `--flavor`.
- **iOS**: no schemes yet. Run without `--flavor`
  (`flutter run --dart-define-from-file=config/staging.json`); the define file alone selects the backend, and
  both builds share the bundle ID `com.kale.app`. To add flavors, in Xcode: duplicate the `Debug`, `Release` and
  `Profile` build configurations as `Debug-staging`/`Release-staging`/`Profile-staging` and
  `Debug-production`/`Release-production`/`Profile-production`; create shared schemes named `staging` and
  `production` that use them; set `PRODUCT_BUNDLE_IDENTIFIER` to `com.kale.app.staging` for the staging
  configurations; and add the matching `ios/Flutter/*.xcconfig` includes for the Pods.

At startup, `bootstrap` checks the define file against the flavor (`lib/core/config/env_validation.dart`):
the `production` flavor only runs with `ENV_NAME=production`, `ENV_NAME=production` only runs on the `production`
flavor, and `BASE_URL` and `SUPABASE_ANON_KEY` must be set. A mismatch throws before Supabase is initialized,
so a staging build can never reach the production project by accident.

### Define files

Values are compiled in with `--dart-define-from-file` and read through `AppConfig` (`core/config/`) via
`String.fromEnvironment` / `bool.fromEnvironment`. Nothing is loaded from an asset at runtime.

```bash
cp config/staging.example.json config/staging.json         # then fill in the staging project's values
cp config/production.example.json config/production.json   # same for production
cp config/local.example.json config/local.json             # anon key from `npx supabase status`
```

`config/*.json` is git-ignored except the `*.example.json` templates and `mock.json`. Get the real values from
the Supabase dashboard (Project Settings → API) and Google Cloud Console (Credentials).

| Key | Purpose |
|---|---|
| `ENV_NAME` | `development` / `staging` / `production` |
| `BASE_URL` | Supabase project URL |
| `SUPABASE_ANON_KEY` | Supabase anon (public) key |
| `ENABLE_LOGGING` | Logs and Dio logging interceptor |
| `SHOW_DEBUG_BANNER` | Flutter debug banner |
| `GOOGLE_WEB_CLIENT_ID`, `GOOGLE_ANDROID_CLIENT_ID`, `GOOGLE_IOS_CLIENT_ID` | Google Sign-In (the web client ID is the one Supabase uses). The staging package name `com.kale.app.staging` needs its own Android OAuth client. |
| `SENTRY_DSN` | Reserved; no Sentry reporter is implemented yet |
| `USE_MOCK_*` | Mock datasources (below) |

> ⚠️ **Every define is compiled into the app binary** and can be extracted from it. Only client-safe values
> belong in a define file: the project URL, the anon key (protected by RLS), OAuth client IDs, the Sentry DSN.
> Never put a service-role key, database password, or push server key there. The app has no FCM server key
> (there is no server push in v1).

### Mock datasources

Each remote datasource has an in-memory mock, toggled per feature by a define. Every flag defaults to `false`,
so a define file that omits them always talks to Supabase.

| Flag | Default when unset |
|---|---|
| `USE_MOCK_AUTH` | `false` |
| `USE_MOCK_TRANSACTIONS` | `false` |
| `USE_MOCK_BUDGETS` | `false` |
| `USE_MOCK_SAVINGS` | `false` |

Providers read the flags from `envProvider` (`env.useMockAuth`, …), so tests can override them. A new flag is a
getter on `Env`, its `bool.fromEnvironment` in `AppConfig`, and a key in every `config/*.json` file.

## Backend (Supabase)

The schema, RLS policies, functions and triggers live in `supabase/migrations/` as Supabase CLI migrations; they
are the single source of truth. Never change a remote project's schema from the dashboard: write a migration.
See `supabase/README.md` for the schema and the record of drift against the live project.

The CLI runs through `npx supabase` (no install needed). The local stack needs Docker Desktop running.

```bash
make db-start      # start the local stack; prints the API URL and anon key
make db-reset      # drop the local database and replay every migration
npx supabase migration new <name>   # add a migration, then make db-reset to test it
```

Deploying migrations (staging first, always):

```bash
npx supabase link --project-ref <staging-ref>     # asks for the database password
npx supabase db push                              # applies pending migrations
npx supabase link --project-ref <production-ref>
npx supabase db push
```

`make db-diff-live` writes the difference between the linked project and the migrations to
`supabase/live_drift.sql` (empty means no drift).

**Windows:** Hyper-V can reserve the port range 54317–54416, which holds every default port of the local stack
(`netsh interface ipv4 show excludedportrange protocol=tcp` shows it). The first `make db-start` may bind them, but a
restart or `make db-reset` then fails with "ports are not available". Either free the range (as admin:
`net stop winnat` then `net start winnat`), or temporarily change every `543xx` port in `supabase/config.toml` to
`553xx` and start with `npx supabase start -x logflare,vector,imgproxy,edge-runtime`; do not commit that change.

Server SQL tests (pgTAP) live in `supabase/tests/database/`: `make db-reset` then `make db-test`.

## Code generation

`build_runner` generates code for Freezed, json_serializable, Riverpod (`@riverpod`), and Drift
(`@DriftDatabase`, `@DriftAccessor`). Generated `*.g.dart` / `*.freezed.dart` files are committed and
excluded from analysis.

```bash
make gen     # one-off build (--delete-conflicting-outputs)
make watch   # rebuild on save
```

Changing a Drift table also needs a `schemaVersion` bump. Until the first public release, any bump drops and
recreates every local table (`AppDatabase.migration`, decision Q11), so there are no per-version `onUpgrade` steps; a
signed-in device then restores its data from the server.

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
- **Sync and data paths** are tested through `SyncHarness` (`test/helpers/sync_harness.dart`): the real provider graph,
  an in-memory Drift database, a `FakeServer` (one fake table per synced entity, RLS-like ownership, server stamps for
  paging) and a fake clock. Prefer it over mocks for anything that writes, syncs, pulls or signs in.
- Server SQL tests (pgTAP: RLS, triggers, jobs) live in `supabase/tests/`; run them with `make db-test` against the
  local stack (see "Backend (Supabase)").
- Integration tests (`make integration`, needs a device or emulator) live in `integration_test/` and use the
  **robot pattern** (`integration_test/robots/`). The current auth flow test is a placeholder.
- `test/core/money/no_float_money_test.dart` fails if a money field is declared as a float, and
  `test/core/sync/sync_wiring_test.dart` runs the sync-wiring checks (below) inside `flutter test`.

## Assets

- App icons: `make icons` (config in `flutter_launcher_icons.yaml`)
- Native splash: `make splash` (config in `flutter_native_splash.yaml`)
- Store listing copy: `store_listings/`

## CI

`.github/workflows/ci.yml` at the repository root (`Kale_mobile/`) runs on every pull request and push to `main`,
with `working-directory: Kale`:

1. **Quality**: `dart format --set-exit-if-changed .`, `flutter analyze`, the sync-wiring check
   (`.claude/skills/add-syncable-entity/check_sync_wiring.sh`), and `flutter test`.
2. **Build**: a debug staging APK with `config/mock.json`.

The wiring check fails the build if an enqueued entity type has no `SyncHandler`, a handler is not registered
eagerly in `syncHandlersProvider`, a Drift table is not registered or not cleared on logout, or a syncable repository
reaches the server directly. The SQL tests need Docker and are not run in CI; run `make db-test` before opening a
PR that touches `supabase/`.
