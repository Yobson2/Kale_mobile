# CLAUDE.md

## What is Kalé

Kalé is an offline-first personal finance mobile app (Flutter, iOS/Android). Users track income
and expenses, budget per category, manage savings goals, and get spending insights, even
without connectivity. Localized in English and French.

**Core capabilities:** transactions · budgets with overspend alerts · savings goals ·
insights/charts · tontine groups · notifications · email/OTP + Google/Apple sign-in · guest mode · onboarding.

## Stack

Flutter · Riverpod (codegen) · GoRouter · Supabase (auth + backend) · Drift/SQLite (local DB +
sync queue) · Freezed/json_serializable · dartz `Either` · flutter_dotenv.

## Architecture

Feature-first Clean Architecture: each feature in `lib/features/` has `domain/ → data/ → presentation/`;
shared infrastructure lives in `lib/core/`.

- **Domain**: entities, repository interfaces, use cases. Pure Dart, free of Flutter, Supabase, and Drift.
- **Data**: repositories return `Either<Failure, T>`; datasource exceptions are caught and mapped to failures here.
- **Presentation**: Riverpod notifiers call use cases (not repositories) and expose Freezed sealed state;
  pages talk to notifiers and providers only and own all user-facing text.
- **Offline-first**: writes go to Drift and are enqueued for sync; the UI reads from the local DB.
  A background sync engine replays the queue to Supabase.
- **DI** is the Riverpod provider graph; environment config is injected at bootstrap.

## Rules

- Agreed product and technical decisions are in `docs/decisions.md`. New work follows them even where the
  current code doesn't yet; flag any conflict instead of copying the old pattern.

- Keep each layer in its lane: business logic lives in use cases, data access in datasources.
- Every syncable entity has a `SyncHandler` **registered** with the sync engine; without one, its
  queued writes silently never reach the server.
- Generated files (`*.g.dart`, `*.freezed.dart`, `lib/l10n/app_localizations*.dart`) are outputs:
  change the source, then run `make gen` (or `make l10n`).
- User-facing text goes through l10n, with every key added to **both** `app_en.arb` and `app_fr.arb`.
- Styling comes from the theme tokens in `lib/core/theme/` and follows the design system.
- Security: secrets stay in the git-ignored `.env`; remote queries are scoped to the current user;
  logout clears the local database.
- Done = `dart format .` clean, `flutter analyze` clean, `flutter test` passing.

## Essential commands

```bash
make gen        # code generation (build_runner)
make analyze    # static analysis
make test       # unit + widget tests
dart format .   # formatting
```

## Where to look

| Need | Read |
|---|---|
| Agreed decisions (target state) and the v1 work plan | `docs/decisions.md` |
| Core modules, DI, backend access, auth/session, routing, error handling | `docs/architecture.md` |
| Setup, env vars & mock flags, commands, codegen, l10n, testing, CI | `docs/development.md` |
| Offline sync, adding a syncable entity | `docs/offline_sync.md` |
| Visual design & UX principles | `docs/Kale_design/kal_modern_heritage/DESIGN.md` |

## Agent skills

### Issue tracker

GitHub Issues on `Yobson2/Kale_mobile`, via the `gh` CLI. See `docs/agents/issue-tracker.md`.

### Triage labels

The five default labels (`needs-triage`, `needs-info`, `ready-for-agent`, `ready-for-human`, `wontfix`). See `docs/agents/triage-labels.md`.

### Domain docs

Single-context: one `CONTEXT.md` + `docs/adr/` at the Flutter project root (`Kale/`). See `docs/agents/domain.md`.
