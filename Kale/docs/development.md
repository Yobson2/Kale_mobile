# Development

Setup, configuration, tooling, and testing. Commands are defined in the `Makefile` (`make help` lists them).

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

`.github/workflows/ci.yml` defines a quality job (format check, analyze, test) followed by a debug APK build of the staging
flavor with `config/mock.json`.

> ⚠️ The git repository root is the parent folder (`Kale_mobile/`), but the workflow sits in `Kale/.github/`.
> GitHub only reads `.github/workflows/` at the repo root, so **this workflow does not run**. Move it to
> `Kale_mobile/.github/workflows/` (its `working-directory: Kale` already assumes that location) to enable it.
