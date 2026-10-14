# Offline-First Sync

How Kalé keeps working without connectivity, and how to make a new entity syncable.
**Reference implementation: the `transactions` feature.** Copy its structure.

## Principles

| Principle | Meaning |
|---|---|
| **Write-local-first** | Create/update/delete save to Drift (SQLite) immediately and return success |
| **Read-local-always** | The UI reads from Drift, usually via reactive `watch*` streams |
| **Queued sync** | Every mutation adds a row to the sync queue; the `SyncEngine` replays it to Supabase |
| **Client-generated IDs** | Records get a UUID v4 locally; `serverId` is filled after the first successful push |
| **Local changes win until pushed** | A pull never overwrites a row with a change not yet pushed; otherwise the newer `updatedAt` wins |
| **Pull only on restore or request** | Reads never pull. Pulling runs on restore (empty device) and pull-to-refresh |

Auth and preferences are not part of this. They live in secure storage and SharedPreferences.

## Moving parts

| Piece | Location | Role |
|---|---|---|
| `AppDatabase` | `core/database/` | Registers every table and DAO; owns `schemaVersion`, migrations, default-category seeding, and `clearAllData()` (logout) |
| Sync queue table + `SyncQueueDao` | `core/database/` | FIFO queue: `entityType`, `entityId`, `operation` (`create`/`update`; a delete is an `update`), JSON `payload`, `status` (`pending`/`in_progress`/`stuck`), `retryCount`, `lastError` |
| `SyncEngine` + `SyncHandler` | `core/sync/sync_engine.dart` | Engine processes the queue; one handler per entity type does the actual push and pulls pages back (`pullPage`) |
| `SyncPuller` + pull cursors | `core/sync/sync_puller.dart`, `core/sync/pull.dart`, `PullCursorsDao` | Restore and pull-to-refresh: pages each entity type from its saved cursor, merges with `rowsToApply` |
| `SyncConfig` | `core/sync/` | Retries (max 5), exponential backoff (1s doubling, capped at 60s), write debounce (2s) |
| `SyncClock` | `core/sync/` | The engine's only source of time and timers; tests swap in a fake clock |
| `BackupStatus` | `core/sync/` | `pendingCount`, `stuckCount`, `isSyncing`, `isOffline`, `lastBackupAt` (persisted by `LastBackupStore`) |
| Providers | `core/sync/sync_providers.dart` | `syncEngineProvider`, `syncPullerProvider` (keepAlive), `backupStatusProvider`, `pullStatusProvider` |
| App wiring | `core/sync/sync_app_lifecycle.dart` | `SyncAppLifecycle` wraps the app root: starts the engine at launch, calls `onAppResumed()` on resume |
| UI | `core/widgets/feedback/`, `features/more/` | `SyncStatusBanner` (in the home shell; "N changes not backed up · Retry"), `BackupStatusTile` (Settings), `SyncStatusIcon` (per item), `AppRestoreBanner` (in `AppScaffold`, restore progress), `refreshFromBackup` (pull-to-refresh) |

Feature tables and DAOs live in the feature (`features/<f>/data/tables/`, `data/daos/`) but are registered in `AppDatabase`.

## Lifecycle of a write

1. The repository generates a UUID, builds the model with `isSynced: false`, and saves it through the local datasource.
2. The local datasource calls `enqueueSync(entityId, operation, payload: jsonEncode(model.toJson()))`.
3. The repository returns `Right(entity)`. Drift streams update the UI immediately.
4. When the engine runs `processQueue()`, for each pending entry that is not backing off it:
   - looks up the handler by `entityType` and calls `pushCreate` or `pushUpdate`;
   - on success, the handler marks the row synced (and stores `serverId`), and the entry is deleted from the queue;
   - on `NetworkException`, it leaves the entry pending without using a retry;
   - on any other error, it records `lastError` and uses a retry. Below `maxRetries` the entry backs off
     (1s, 2s, 4s…, without blocking the run) and a run is triggered when the backoff expires. At `maxRetries`
     the entry is marked **stuck**: kept, counted in `BackupStatus.stuckCount`, never dropped.
5. When a run ends with nothing pending or stuck, the engine records `lastBackupAt`.

### Triggers

A run starts on: a local write (any insert into the queue, debounced 2s), app launch and resume
(`SyncAppLifecycle`), connectivity coming back, manual retry (`SyncEngine.retry()`, from the banner or
Settings), and an expired backoff. A trigger that arrives during a run schedules one follow-up run, so
overlapping triggers coalesce. Manual retry also gives stuck entries a fresh set of retries; each app start
resets every retry count.

Test these through `SyncHarness` (`test/helpers/`): its fake clock fires debounce and backoff timers only on
`elapse()`, and it exposes `resumeApp()`, `retry()`, `restartApp()`, `syncRuns` and `backupStatus`.

## Money and the base currency

- Each account has one **base currency**, stored on the profile: the `profiles` Drift table (one row, id `me`) and
  the server's `profiles.base_currency`. The `profile` feature owns it, syncs it as entity type `profile`, and exposes
  it as `baseCurrencyProvider` (XOF until chosen). It is picked at onboarding and changed in settings through
  `ChangeBaseCurrencyUseCase`: free with no transactions, otherwise a relabel only after a confirmed warning.
- Transactions store `amountMinor` (`amount_minor`): an integer count of minor units of the base currency. They carry
  no currency. DAO sums are integers; the UI wraps them in `Money` (`lib/core/money/`) with the base currency to parse
  input and format output. Never sum or store money as `double`.
- Transactions have a nullable `deletedAt`; every DAO read excludes rows where it is set (see [Deletes](#deletes)).
- Budgets store `totalIncomeMinor` and their allocations `allocatedMinor` (`total_income_minor`, `allocated_minor`),
  integer minor units of the base currency like transactions. Spent and remaining amounts are integer sums of
  transaction minor units. Both tables have a nullable `deletedAt` that every DAO read excludes.
- A budget period is two calendar dates, `startDate` and `endDate`, both included (`CalendarDate` in
  `lib/core/date/`). Drift stores them as `YYYY-MM-DD` text, the server as `DATE`, so a time-zone or clock change
  can't shift the days a budget covers. A budget's spending is every transaction from the first instant of
  `startDate` to the last second of `endDate`, in the device's current time zone. The period is computed in the
  domain by `BudgetPeriodRange.containing(day, period:, startDay:)` from the stored `periodStartDay`
  (`period_start_day`, default 1: calendar months, weeks starting Monday).
- Savings goals (`targetAmountMinor`, `currentAmountMinor`) and contributions (`amountMinor`) are minor units too,
  with `deletedAt`, and no currency.

## Savings: two entity types, one derived amount

- Goals sync as `savings_goal` and contributions as `savings_contribution`, each with its own local datasource,
  remote datasource and `SyncHandler` (`SavingsGoalsSyncHandler`, `SavingsContributionsSyncHandler`).
- A goal's `currentAmountMinor` is **derived on the device**: after each contribution, the repository recomputes it
  as the sum of the goal's contributions, marks an active goal `completed` once it reaches its target, and queues a
  goal `update`. The server has no trigger on the savings tables, so the amount is never counted twice.
- Queue order matters: the goal's `create` is queued before its contributions (the server's foreign key needs the
  goal first). `getPending` keeps insertion order for entries queued within the same second.
- Contributions have no `user_id`: on the server they are owned through their goal (RLS checks the goal's owner).
- Goals are pulled before contributions.

## Budgets: two entity types

- Budgets sync as `budget` and their category allocations as `budget_category`, each with its own local datasource,
  remote datasource and `SyncHandler` (`BudgetsSyncHandler`, `BudgetCategoriesSyncHandler`). Allocations share the
  `USE_MOCK_BUDGETS` flag.
- A budget's `create`/`update` is queued before its allocations. Saving a budget queues each allocation as a `create`
  (new) or an `update` (existing, or dropped and soft-deleted). The setup screen sends allocations without ids, so the
  repository reuses the id of the existing allocation for the same category; an edit updates rows in place.
- Allocations have no `user_id` (the server table is `budget_category_allocations`, owned through its budget).
  Deleting a budget soft-deletes its allocations too (see [Deletes](#deletes)).
- Budgets are pulled before their allocations.

## Deletes

- Every delete is a **soft delete** (decision Q17): the DAO's `markDeleted` sets `deletedAt` and `updatedAt` and
  marks the row unsynced, and the repository queues an `update` whose payload carries `deleted_at`. Nothing is
  hard-deleted on the device or the server; `SyncHandler` has no `pushDelete` and remote datasources no delete.
- Every DAO read excludes rows with `deletedAt` set, so a deleted entry leaves every list, total, chart and budget
  computation at once.
- Deleting a parent soft-deletes its children and queues them too: a savings goal its contributions, a budget its
  allocations. Each local datasource soft-deletes its own entity type only; the repository queues both.
- Creating then deleting before a sync pushes the `create`, then the `update`: the server ends up with a tombstone,
  never an orphan. (Purging old tombstones on the server is #14.)

## Pulling: restore and pull-to-refresh

- **Reads never pull.** Repositories expose `watch*` streams and `get*` queries over Drift only; they have no
  remote datasource (`check_sync_wiring.sh` check 4).
- **When:** `SyncPuller.restoreIfNeeded()` runs after sign-in and at launch for a signed-in user. It restores only
  when the device holds none of the user's data and nothing was ever pulled, or when an earlier restore did not
  finish. `SyncPuller.pull()` is pull-to-refresh, wired on the dashboard, transactions, budget and savings screens
  through `refreshFromBackup`.
- **Paging:** every synced server table has `server_updated_at`, stamped by a trigger on each write (migration
  `20261015000100_pull_cursor.sql`); the client never writes it. Each entity type is pulled in pages of 500
  keyset-ordered on `(server_updated_at, id)` from its cursor in the `pull_cursors` Drift table, saved after every
  page: an interrupted restore resumes where it stopped. Handlers are pulled in `syncHandlersProvider` order,
  parents first. The single-row profile has no cursor and is fetched whole.
- **Merge** (`rowsToApply`, decision Q8): a pulled row is skipped if the local row is unsynced or still has a queue
  entry; otherwise the newer `updatedAt` wins, tombstones included. A tombstone for a row the device never had is
  skipped. `updatedAt` stays client-owned: it orders edits, `server_updated_at` only orders pages.
- **Progress:** `PullStatus` (`pullStatusProvider`) drives `AppRestoreBanner`: "Restoring your data… N items".

## Adding a syncable entity

1. **Table** in `features/<f>/data/tables/`: text UUID `id` primary key, nullable `serverId`, `isSynced`
   (default `false`), `createdAt`/`updatedAt`.
2. **DAO** in `features/<f>/data/daos/` with at least `watchAll`, `upsert`, `markDeleted`, `markSynced`, `statesByIds` and
   `upsertAll`, a nullable `deletedAt` column, and every read excluding rows where it is set.
3. **Register** the table and DAO in `AppDatabase`, bump `schemaVersion`, and add an `if (from < N)` step in
   `onUpgrade` that creates the table. Also add it to `clearAllData()`.
4. **Model** (Freezed) with `fromJson`/`toJson`, `fromDrift`, `toDriftCompanion({required bool isSynced})`, `toEntity`.
5. **Local datasource** with save, soft delete (returning the deleted row, to queue) and watch, `enqueueSync`
   using a unique `entityType` string, `markSynced`, and `mergeFromServer` (filtered by `rowsToApply`). One local
   datasource per entity type (see savings). The model implements `PulledRow`.
6. **Remote datasource**: an abstract class with create, update and `fetchPage` (built with `pullPageQuery` and
   `toRemotePage`), a Supabase implementation scoped by `user_id` that throws `ServerException` with a status code,
   and a mock twin behind a `USE_MOCK_<F>` flag. The server table needs `server_updated_at` and its stamp trigger.
7. **`SyncHandler`** whose `entityType` matches the string used in step 5 exactly, with `pullPage` fetching a page
   and merging it.
8. **Providers**: a `<f>SyncHandler` provider (`keepAlive`), listed in `syncHandlersProvider`
   (`core/sync/sync_providers.dart`) so the engine and the puller register it; its position is its pull order.
9. **Repository**: write-local-first + enqueue for mutations; local reads only, no remote datasource.
10. `make gen`, then test the repository and handler.

## Known issues

- **Clock skew between devices.** The merge compares client-written `updatedAt` (last writer wins, decision Q8):
  an edit made on a device whose clock is behind loses against an older edit from a device whose clock is ahead.
  Paging is not affected: it uses the server-stamped `server_updated_at`.
