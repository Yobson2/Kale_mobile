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
| **Server wins** | On a conflict (HTTP 409), the server version overwrites the local one |

Auth and preferences are not part of this. They live in secure storage and SharedPreferences.

## Moving parts

| Piece | Location | Role |
|---|---|---|
| `AppDatabase` | `core/database/` | Registers every table and DAO; owns `schemaVersion`, migrations, default-category seeding, and `clearAllData()` (logout) |
| Sync queue table + `SyncQueueDao` | `core/database/` | FIFO queue: `entityType`, `entityId`, `operation` (`create`/`update`/`delete`), JSON `payload`, `status`, `retryCount`, `lastError` |
| `SyncEngine` + `SyncHandler` | `core/sync/sync_engine.dart` | Engine processes the queue; one handler per entity type does the actual push |
| `SyncConfig` | `core/sync/` | Retries (max 5) and exponential backoff (1s doubling, capped at 60s) |
| `SyncStatus` | `core/sync/` | Sealed: `idle`, `syncing(total, completed)`, `synced`, `error`, `offline(pendingCount)` |
| Providers | `core/sync/sync_providers.dart` | `syncEngineProvider` (keepAlive), `syncStatusProvider`, `pendingSyncCountProvider` |
| UI | `core/widgets/feedback/` | `SyncStatusBanner` (with retry), `SyncStatusIcon` (per item) |

Feature tables and DAOs live in the feature (`features/<f>/data/tables/`, `data/daos/`) but are registered in `AppDatabase`.

## Lifecycle of a write

1. The repository generates a UUID, builds the model with `isSynced: false`, and saves it through the local datasource.
2. The local datasource calls `enqueueSync(entityId, operation, payload: jsonEncode(model.toJson()))`.
3. The repository returns `Right(entity)`. Drift streams update the UI immediately.
4. When the engine runs `processQueue()`, for each pending entry it:
   - looks up the handler by `entityType` and calls `pushCreate` / `pushUpdate` / `pushDelete`;
   - on success, the handler marks the row synced (and stores `serverId`), and the entry is deleted from the queue;
   - on `ServerException` 409, it calls `fetchRemote` then `applyServerVersion` (server wins), then completes the entry;
   - on `NetworkException`, it marks the entry failed without counting a retry;
   - on any other error, it records `lastError`, increments `retryCount`, and backs off. Entries at `maxRetries` are skipped.

`processQueue()` is triggered when connectivity changes to online and by the banner's retry button.

## Money and the base currency

- Each account has one **base currency**, stored on the profile: the `profiles` Drift table (one row, id `me`) and
  the server's `profiles.base_currency`. The `profile` feature owns it, syncs it as entity type `profile`, and exposes
  it as `baseCurrencyProvider` (XOF until chosen). It is picked at onboarding and changed in settings through
  `ChangeBaseCurrencyUseCase`: free with no transactions, otherwise a relabel only after a confirmed warning.
- Transactions store `amountMinor` (`amount_minor`): an integer count of minor units of the base currency. They carry
  no currency. DAO sums are integers; the UI wraps them in `Money` (`lib/core/money/`) with the base currency to parse
  input and format output. Never sum or store money as `double`.
- Transactions have a nullable `deletedAt`; every DAO read excludes rows where it is set. (Deletes are still hard
  deletes until the tombstone work lands; rows only arrive with `deletedAt` set through a pull.)
- Budgets and savings still hold `double` amounts until their own schema reset. The budgets repository converts
  transaction totals from minor units to major units of the base currency at that boundary.

## Reads and refresh

- Repositories expose `watch*` streams and `get*` queries over Drift.
- When online, `get*` fires a background `refreshFromServer()`. The auth notifier also refreshes all
  syncable features after login.
- Refresh pulls everything for the current user and **replaces** the local table (`replaceAllFromServer`).

## Adding a syncable entity

1. **Table** in `features/<f>/data/tables/`: text UUID `id` primary key, nullable `serverId`, `isSynced`
   (default `false`), `createdAt`/`updatedAt`.
2. **DAO** in `features/<f>/data/daos/` with at least `watchAll`, `upsert`, `deleteById`, `markSynced`, `replaceAll`.
3. **Register** the table and DAO in `AppDatabase`, bump `schemaVersion`, and add an `if (from < N)` step in
   `onUpgrade` that creates the table. Also add it to `clearAllData()`.
4. **Model** (Freezed) with `fromJson`/`toJson`, `fromDrift`, `toDriftCompanion({required bool isSynced})`, `toEntity`.
5. **Local datasource** with save/delete/watch, `enqueueSync` using a unique `entityType` string, `markSynced`,
   and `replaceAllFromServer`.
6. **Remote datasource**: an abstract class, a Supabase implementation scoped by `user_id` that throws
   `ServerException` with a status code, and a mock twin behind a `USE_MOCK_<F>` flag.
7. **`SyncHandler`** whose `entityType` matches the string used in step 5 exactly.
8. **Providers**: a `<f>SyncHandler` provider that calls `ref.watch(syncEngineProvider).registerHandler(handler)`,
   and a repository provider that `ref.watch`es the handler provider first, so that reading the repository
   guarantees registration.
9. **Repository**: write-local-first + enqueue for mutations; local reads; `refreshFromServer`.
10. Add the entity's `refreshFromServer()` to the post-login refresh in the auth notifier.
11. `make gen`, then test the repository and handler.

## Known issues

- **Savings never syncs.** `savings_local_datasource.dart` enqueues `savings_goal` entries, but there is no
  savings `SyncHandler`. The engine logs `No SyncHandler registered for "savings_goal"` and skips them, so
  savings data never reaches Supabase.
- **Refresh drops unsynced local rows.** `replaceAll` in the DAOs deletes the whole table before inserting the
  server copy, including rows with `isSynced = false`. A record created while online disappears locally on the
  next background refresh, and comes back only after its queued push succeeds and a later refresh runs.
- **Writes made while already online wait.** Nothing calls `processQueue()` after `enqueueSync`, so a queued
  write sits until the next connectivity change or a manual retry.
- **Handlers register lazily.** A handler registers only when its repository provider is first read. Queue
  entries for an entity whose feature hasn't been opened this session are skipped.
