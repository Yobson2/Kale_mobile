# Kalé

Personal finance management app built with Flutter. Track expenses and income, create budgets, set savings goals, and gain insights into your spending habits.

## Features

- **Expense & income tracking** — Log transactions in seconds with category tagging
- **Budget management** — Set custom budgets per category with overspend alerts
- **Savings goals** — Create goals, track progress, and watch your money grow
- **Financial insights** — Charts and summaries powered by fl_chart
- **Offline-first** — Works without internet, syncs automatically when back online (Drift/SQLite)
- **Authentication** — Email/password, Google Sign-In, Apple Sign-In with OTP verification
- **Onboarding** — Guided first-launch experience
- **Light & dark mode** — Material 3 theme system
- **Localization** — English and French
- **Secure storage** — Encrypted credentials via FlutterSecureStorage
- **Crash reporting** — Sentry integration

## Tech Stack

| Layer | Technology |
|-------|-----------|
| Framework | Flutter |
| Architecture | Clean Architecture (domain/data/presentation per feature) |
| State management | Riverpod (with code generation) |
| Routing | GoRouter (auth guards, bottom nav shell) |
| Backend | Supabase |
| HTTP client | Dio (auth interceptor, token refresh, error handling) |
| Local database | Drift (SQLite) with sync queue engine |
| Models | Freezed + json_serializable |
| Error handling | `Either<Failure, T>` via dartz |

## Getting Started

```bash
# 1. Clone and enter the project
cd Kale

# 2. Copy environment file
cp .env.example .env

# 3. Install dependencies
make get

# 4. Run code generation
make gen

# 5. Run the app
make run
```

## Project Structure

```
lib/
├── main.dart                    # Entry point
├── app.dart                     # Root MaterialApp.router
├── bootstrap.dart               # Initialization (env, storage, crash reporting)
├── core/
│   ├── config/                  # Environment configuration (Env, AppConfig)
│   ├── error/                   # Exceptions (data) & Failures (domain)
│   ├── extensions/              # String, Context, DateTime, Num, Widget
│   ├── network/                 # Dio client, interceptors, API endpoints
│   ├── providers/               # Core Riverpod providers
│   ├── router/                  # GoRouter config, route names, guards
│   ├── services/                # Crash reporter, analytics (abstract)
│   ├── database/                # Drift (SQLite) database, tables, DAOs
│   ├── sync/                    # Sync engine, status, config, providers
│   ├── storage/                 # LocalStorage, SecureStorage wrappers
│   ├── theme/                   # Colors, typography, spacing, radius, shadows
│   ├── usecase/                 # Base UseCase<T, Params> class
│   ├── utils/                   # Logger, validators, pagination
│   └── widgets/                 # Reusable UI components
│       ├── buttons/             # Primary, Secondary, Ghost, Icon, Loading
│       ├── data_display/        # Avatar, Badge, Card, Chip, ListTile, NetworkImage
│       ├── feedback/            # Dialog, BottomSheet, Snackbar, Toast
│       ├── inputs/              # TextField, Password, OTP, Search, Dropdown, Checkbox
│       ├── layout/              # Scaffold, AppBar, BottomNav, Responsive
│       ├── loading/             # Shimmer, ShimmerList
│       └── states/              # Empty, Error, Offline banner
└── features/
    ├── auth/                    # Authentication (full Clean Architecture)
    │   ├── data/                # DataSources, Models, Repository impl
    │   ├── domain/              # Entities, Repository interface, UseCases
    │   └── presentation/        # Pages, Providers, Widgets
    ├── home/                    # Home shell with bottom navigation
    ├── notes/                   # Notes feature (offline-first sync)
    ├── onboarding/              # First-launch onboarding flow
    └── splash/                  # Splash screen with init checks
```

## Available Commands

```bash
make help          # Show all available commands
make get           # Install dependencies
make gen           # Run code generation (freezed, riverpod, json)
make watch         # Watch mode for code generation
make test          # Run unit and widget tests
make integration   # Run integration tests
make analyze       # Run static analysis
make format        # Format all Dart files
make l10n          # Generate localization files
make clean         # Clean build artifacts and reinstall
make run           # Run app in debug mode
make icons         # Generate app icons
make splash        # Generate native splash screen
```

## Testing

```bash
# Run all tests
make test

# Run a specific test file
flutter test test/features/auth/domain/usecases/login_usecase_test.dart

# Run integration tests
make integration
```

Tests use `mocktail` for mocking. Test helpers and mock providers are in `test/helpers/`.

## Environment Configuration

The app uses `flutter_dotenv` to load environment variables from a `.env` file.

| Variable | Description | Example |
|----------|-------------|---------|
| `ENV_NAME` | Environment name | `development` |
| `BASE_URL` | API base URL | `https://api-dev.example.com/v1` |
| `ENABLE_LOGGING` | Enable HTTP/debug logging | `true` |
| `SHOW_DEBUG_BANNER` | Show Flutter debug banner | `true` |
| `USE_MOCK_AUTH` | Use mock auth datasource | `true` |
| `USE_MOCK_NOTES` | Use mock notes datasource | `true` |

To switch environments:
```bash
cp .env.development .env   # Development
cp .env.staging .env       # Staging
cp .env.production .env    # Production
```

## Architecture

```
Page → Notifier → UseCase → Repository → DataSource (Dio/Supabase/Drift)
                                ↓
                    Either<Failure, T> flows back up
                                ↓
                    Notifier updates state (freezed sealed class)
                                ↓
                    GoRouter redirects based on auth state
```

Each feature follows Clean Architecture with three layers:

- **Domain** — Entities, abstract repository interfaces, use cases. No framework dependencies.
- **Data** — Repository implementations, remote/local datasources, Freezed models with `toEntity()`.
- **Presentation** — Pages, widgets, Riverpod providers/notifiers with sealed state unions.
