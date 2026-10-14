---
name: add-syncable-entity
description: Make a data type persist offline in Kalé and sync to Supabase, covering the Drift table, DAO, migration, SyncHandler, and registration. Use when asked to add a new entity, table, or model that users create or edit, to make something work offline, or to change the columns of an existing Drift table.
---

# Add a syncable entity

Sync failures are **silent**: a missed wiring step means data never reaches the server, and nothing errors.
So this skill ends with a mechanical check, not just a review.

## 1. Read the playbook

Read `docs/offline_sync.md` in full. Its "Adding a syncable entity" checklist is the build order. Use
`lib/features/transactions/` as the reference implementation to copy, file by file.

## 2. Build, following the checklist

These rules go beyond the doc:

- **One `entityType` string**, defined once as `static const _entityType = '<snake_case>'` in the local datasource
  and returned by the `SyncHandler`'s `entityType` getter. Copy it exactly.
- **Required columns**: text UUID `id`, `isSynced`, `createdAt`/`updatedAt` (written by the device: the pull merge
  compares it), and a nullable `deletedAt`. Every DAO read excludes rows where `deletedAt` is set.
- **Money is integer minor units**: an `int …Minor` field, `IntColumn` in Drift, `BIGINT` on the server, no currency
  per row (the account has one base currency). Never `double`, `num` or `RealColumn` for money:
  `test/core/money/no_float_money_test.dart` fails if you do.
- **Deletes are soft**: the DAO's `markDeleted` sets `deletedAt` and `updatedAt` and marks the row unsynced; the
  repository queues an `update` carrying `deleted_at`. There is no hard delete, no `pushDelete`, and no delete on
  the remote datasource. Deleting a parent soft-deletes its children.
- **Pulls merge, never replace**: the DAO gets `statesByIds` and `upsertAll`, the local datasource
  `mergeFromServer` filtered by `rowsToApply`, and the handler `pullPage` built on the remote's `fetchPage`
  (`pullPageQuery` + `toRemotePage`). Repositories never call the remote datasource and never pull on reads.
- **Server table**: a migration with `server_updated_at` and its `stamp_server_updated_at` trigger (copy
  `20261015000100_pull_cursor.sql`), `deleted_at`, RLS scoped to the owner (children through their parent), and the
  table added to `purge_tombstones()` (`20261015000200_maintenance_jobs.sql`). Write a pgTAP test next to the others.
- **Moving to another account**: add the table to `AppDatabase.rekeyForAnotherAccount()` and implement
  `requeueAllAsCreates` (local datasource `enqueueAllAsCreates`).
- **Registration is eager**: list the handler's provider in `syncHandlersProvider`
  (`lib/core/sync/sync_providers.dart`), parents before children: that list is also the pull order.
- **Migration**: bump `schemaVersion` in `AppDatabase` by one. Until the first public release any bump drops and
  recreates every table (decision Q11), so don't write per-version `onUpgrade` steps.
- **Remote datasource** is scoped by `user_id` and comes with a `Mock…RemoteDataSource` twin behind a
  `USE_MOCK_<ENTITY>` define that defaults to `false`: a getter on `Env`, its `bool.fromEnvironment` in `AppConfig`,
  and a key in every `config/*.json`. Document it in `docs/development.md`.
- Operations on the new entity (create, update, delete, queries) follow the `add-feature-operation` skill.

Changing columns of an existing entity: bump `schemaVersion`, update the model's `fromJson`, `fromDrift` and
`toDriftCompanion`, write the server migration, then run steps 3–4.

## 3. Generate

`make gen`, then `flutter analyze` until clean.

## 4. Verify the wiring

```bash
bash .claude/skills/add-syncable-entity/check_sync_wiring.sh
```

It checks, for every entity: (1) the enqueued `entityType` has a `SyncHandler`; (2) each handler is provided in a
`*_providers.dart` and listed in `syncHandlersProvider`, so it is registered eagerly; (3) each Drift table is in
`@DriftDatabase(tables:)` and in `clearAllData()`; (4) no syncable repository uses a remote datasource (reads
never pull). CI runs it on every pull request, and `test/core/sync/sync_wiring_test.dart` runs the same checks in
`flutter test`.

Every line must be `ok`: the script has no known failures. If a line about another entity fails, report it to the
user rather than fixing it silently.

One local datasource enqueues exactly one entity type. If a feature syncs two kinds of rows (savings goals and their
contributions), give each its own local datasource, remote datasource and `SyncHandler`, so a handler never receives
the other type's payload.

## 5. Test

Use `SyncHarness` (`test/helpers/sync_harness.dart`) and add a fake table to `FakeServer`
(`test/helpers/fake_remote.dart`), copying `FakeTransactionsRemote`. Cover, as harness tests:

- create, edit and delete reach the fake server (the delete as an `update` with `deleted_at`);
- a pull keeps an unsynced local edit, and a newer server version replaces a synced row;
- a restore on an empty device brings the rows back;
- parent before child, if the entity has one.

Run the SQL test with `make db-reset && make db-test` (see `docs/development.md` for the local stack).

## Done when

- `check_sync_wiring.sh` shows `ok` for every line naming the new entity.
- `schemaVersion` went up by one; the server migration and its pgTAP test pass locally.
- `make gen` has run, `flutter analyze` is clean, and `flutter test` passes, including the step-5 tests.
