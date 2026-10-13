# Kalé

Personal finance management app built with Flutter. Track expenses and income, create budgets, set savings goals, and gain insights into your spending habits, online or offline.

## Features

- **Expense & income tracking**: log transactions in seconds with category tagging and mobile-money details
- **Budget management**: custom budgets per category with overspend alerts
- **Savings goals**: create goals, add contributions, and track progress
- **Financial insights**: charts and summaries powered by fl_chart
- **Tontine groups**: community savings circles
- **Offline-first**: works without internet and syncs to Supabase when back online (Drift/SQLite)
- **Authentication**: email/password with OTP verification, Google Sign-In, Apple Sign-In, guest mode
- **Onboarding**: guided first-launch experience
- **Light & dark mode**: Material 3 theme with custom design tokens
- **Localization**: English and French
- **Secure storage**: credentials encrypted via FlutterSecureStorage

## Tech Stack

| Layer | Technology |
|-------|-----------|
| Framework | Flutter |
| Architecture | Clean Architecture (domain/data/presentation per feature) |
| State management | Riverpod (with code generation) |
| Routing | GoRouter (auth redirects, bottom nav shell) |
| Backend | Supabase (auth + database) |
| Local database | Drift (SQLite) with a sync queue engine |
| Models | Freezed + json_serializable |
| Error handling | `Either<Failure, T>` via dartz |

## Getting Started

```bash
cp .env.example .env   # fill in your Supabase URL/anon key and Google client IDs
make get               # install dependencies
make gen               # run code generation
make run               # run the app
```

`make help` lists every available command.

## Documentation

| Topic | Doc |
|---|---|
| Architecture: layers, data flow, DI, auth, routing, errors | [docs/architecture.md](docs/architecture.md) |
| Development: environment variables, mock flags, codegen, l10n, testing, CI | [docs/development.md](docs/development.md) |
| Offline-first sync and adding a syncable entity | [docs/offline_sync.md](docs/offline_sync.md) |
| Design system | [docs/Kale_design/kal_modern_heritage/DESIGN.md](docs/Kale_design/kal_modern_heritage/DESIGN.md) |
