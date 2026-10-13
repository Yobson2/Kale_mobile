# Development

Setup, configuration, tooling, and testing. Commands are defined in the `Makefile` (`make help` lists them).

## Setup

```bash
cp .env.example .env   # then fill in Supabase + Google values
make get               # flutter pub get
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
