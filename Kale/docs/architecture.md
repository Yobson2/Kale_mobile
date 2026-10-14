# Architecture

How Kalé is put together. For the offline sync engine specifically, see `docs/offline_sync.md`.

## Layers

Each feature in `lib/features/<feature>/` follows Clean Architecture:

| Layer | Contains | Depends on |
|---|---|---|
| `domain/` | Entities, abstract repositories, use cases (`UseCase<T, Params>` from `core/usecase/`) | Nothing framework-specific |
| `data/` | Repository implementations, local (Drift) and remote (Supabase) datasources, Freezed models, Drift tables/DAOs | `domain/`, `core/` |
| `presentation/` | Pages, widgets, Riverpod providers and notifiers, Freezed sealed state | `domain/`, `core/` |

Models convert to entities with `toEntity()`; syncable models also convert to and from Drift rows.

**Notifiers call use cases, never repositories.** Each use case has its own provider in the feature's
`*_providers.dart`. Legacy exceptions to fix when touched: a few direct repository calls in the transactions,
budget, and auth notifiers, and use cases with no caller
(`GetBudgetsUseCase`, `GetCategoryTotalsUseCase`, `GetPeriodSummaryUseCase`). Notifiers emit state with
no user-facing text; pages pick the localized message.

Features with the full three layers: `auth`, `transactions`, `budget`, `savings`, plus `dashboard`, which
aggregates data from the others. The rest (`insights`, `notifications`, `onboarding`, `splash`, `legal`,
`more`, `main`) are presentation-only for now.

## Data flow

```
Page → Notifier → UseCase → Repository ─┬─ LocalDataSource (Drift)   ← all reads, all writes first
                                        ├─ SyncQueue (Drift)         ← every mutation enqueued
                                        └─ RemoteDataSource (Supabase) ← refresh from server
            Either<Failure, T> flows back up; UI also watches Drift streams directly.

SyncEngine (background) ── SyncHandler ── RemoteDataSource (Supabase)
```

- **Writes** save to Drift, enqueue a sync entry, and return immediately, online or offline.
- **Reads** always come from Drift and never pull from the server.
- **Pulls** run only on restore (after sign-in on an empty device, or to finish an interrupted restore) and on
  pull-to-refresh, through `SyncPuller`. Pulled rows are merged without overwriting local changes not yet pushed
  (see `docs/offline_sync.md`).

## Dependency injection

The Riverpod provider graph (with `riverpod_generator`) is the DI container:
env → Supabase client / database / storage → datasources → repositories → use cases → notifiers.

- Core singletons (database, sync engine, router, storage) use `keepAlive: true`.
- `bootstrap.dart` loads `.env`, initializes Supabase, pre-loads SharedPreferences, sets up crash
  reporting, then overrides `envProvider`, `sharedPreferencesProvider`, and `crashReporterProvider`
  in the root `ProviderScope`.
- Each feature's DI wiring lives in its `presentation/providers/*_providers.dart`.

## Backend access

- Supabase is the backend for auth and data. Remote datasources take a `SupabaseClient`, query tables
  directly, scope every query to the current user (`user_id`), and rethrow errors as `ServerException`
  with a status code.
- `core/network/` holds a Dio client with logging, auth (token refresh), and error interceptors. **No feature
  uses it today.** Reach for it only when calling a non-Supabase HTTP API.
- Each remote datasource has a mock twin, selected by a `USE_MOCK_*` env flag (see `docs/development.md`).

## Error handling

Data layer throws exceptions; repositories catch them and return `Left(Failure)`.

| Exception (`core/error/exceptions.dart`) | Failure (`core/error/failures.dart`, sealed) |
|---|---|
| `ServerException` | `ServerFailure` |
| `CacheException` | `CacheFailure` |
| `NetworkException` | `NetworkFailure` |
| `UnauthorizedException` | `UnauthorizedFailure` |
| `SyncException` | `SyncFailure` |
| (input validation) | `ValidationFailure` |

Notifiers turn failures into user-facing error state, so presentation code only sees `Failure`s.

## Auth and session

- `AuthState` is a sealed union: `initial`, `loading`, `authenticated`, `unauthenticated`, `error`.
- Sign-in methods: email/password with OTP verification (signup and password recovery), Google, and Apple.
  Google and Apple use `signInWithIdToken` on Supabase.
- **Anonymous users** replace guest mode. At launch the splash calls `AuthNotifier.restoreSession()`: a cached
  session is kept; with none, the app signs in anonymously (`signInAnonymously`). An anonymous user is
  `authenticated` with `User.isAnonymous == true`: they have a real `user_id`, their data syncs like anyone's, and
  RLS treats them the same. "Try Kalé first" on the login page also starts an anonymous session. If anonymous
  sign-in fails (offline on first launch), the user is `unauthenticated` and lands on login.
- Anonymous users are never offered "Log out" (they could never sign back in): `AccountActionButton` shows
  "Create an account to save your data" instead, and the home shell shows the same invitation as a banner.
- Logout is guarded (Q18). `AuthNotifier.logout()` first backs up through `BackUpPendingChangesUseCase`
  (`SyncEngine.backUpNow`, a manual push). If changes are still pending or stuck (offline, or the server refused
  them), it returns `LogoutOutcome.blocked(unsavedChanges: n)` and changes nothing; `AccountActionButton` then asks
  for an explicit destructive confirmation, and only `discardChangesAndLogout()` goes ahead.
- Logout clears secure storage, the cached user, the user's progress (streak, achievements) **and** the whole Drift
  database including the sync queue (`AppDatabase.clearAllData`, which also re-seeds default categories). It then
  calls `SyncEngine.onLocalDataCleared` so the backup status (counts, last backup time) does not show the previous
  user's state. The server sign-out is best effort: the phone is wiped even if it fails.

## Routing

- GoRouter is provided by `appRouterProvider`. Riverpod auth state is bridged to GoRouter's
  `refreshListenable` through a `ValueNotifier`.
- The redirect logic is **inline in `app_router.dart`**. The splash screen owns initial navigation; after
  that, the redirect sends permanent users away from auth pages (anonymous users may visit them to create an
  account), unauthenticated users to login, and first-launch users to onboarding. The providers in `core/router/guards/` are not wired in.
- `StatefulShellRoute` bottom-nav tabs: **dashboard, transactions, budget, more**. Secondary screens
  (profile, settings, savings, insights, tontine groups, help, rate/share) are nested under `more`.
- Route paths are constants in `RouteNames`. `AnalyticsObserver` logs screen views.

## Core services

`lib/core/services/` defines abstractions with dev implementations:

- `CrashReporter` / `AnalyticsService`: only `Dev*` implementations exist. `sentry_flutter` is a dependency,
  but no Sentry reporter is implemented yet. To add one, override the provider at bootstrap.
- Local notifications, budget alert checks, streaks, achievements, and coach marks are app services consumed
  by features.

## UI foundation

- Design tokens live in `core/theme/`: colors (including finance-specific colors), typography, spacing, radius,
  and shadows, composed in `AppTheme`. Light and dark modes are managed by a theme-mode notifier.
- Reusable components are in `core/widgets/`, grouped by kind (buttons, inputs, feedback, layout,
  data_display, loading, states, animations).
- `flutter_screenutil` scales from a 375×812 design; `ResponsiveBuilder` handles breakpoints.
- Visual language and UX principles: `docs/Kale_design/kal_modern_heritage/DESIGN.md`. Per-screen mockups
  live alongside it in `docs/Kale_design/`.
