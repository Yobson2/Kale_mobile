---
name: add-syncable-entity
description: Make a data type persist offline in Kalé and sync to Supabase, covering the Drift table, DAO, migration, SyncHandler, and registration. Use when asked to add a new entity, table, or model that users create or edit, to make something work offline, or to change the columns of an existing Drift table.
---

# Add a syncable entity

Sync failures are **silent**: a missed wiring step means data never reaches the server, and nothing errors.
So this skill ends with a mechanical check, not just a review.

## 1. Read the playbook

Read `docs/offline_sync.md` in full. Its "Adding a syncable entity" checklist (steps 1–11) is the build order. Use
`lib/features/transactions/` as the reference implementation to copy, file by file.

## 2. Build, following the checklist

These rules go beyond the doc:

- **One `entityType` string**, defined once as `static const _entityType = '<snake_case>'` in the local datasource
  and returned by the `SyncHandler`'s `entityType` getter. Copy it exactly.
- **Migration**: bump `schemaVersion` in `AppDatabase` by exactly one, and add an `if (from < N)` block in `onUpgrade`.
  For a new table use `m.createTable(...)`; for a new column on an existing table use `m.addColumn(table, table.column)`.
  Earlier `if (from < …)` blocks stay untouched, because they still run for users upgrading from old versions.
- **Refresh keeps unsynced rows**: in the DAO's `replaceAll`, delete only rows where `isSynced` is true, then upsert
  the server rows. The existing DAOs wipe the whole table, which is a known bug (see the doc's "Known issues").
  Don't copy that part.
- **Remote datasource** is scoped by `user_id` and comes with a `Mock…RemoteDataSource` twin behind a
  `USE_MOCK_<ENTITY>` flag that defaults to `false`. Document the flag in `docs/development.md`.
- Operations on the new entity (create, update, delete, queries) follow the `add-feature-operation` skill.

Changing columns of an existing entity: do only the migration rule above, update the model's `fromJson`, `fromDrift`,
and `toDriftCompanion`, then run steps 3–4.

## 3. Generate

`make gen`, then `flutter analyze` until clean.

## 4. Verify the wiring

```bash
bash .claude/skills/add-syncable-entity/check_sync_wiring.sh
```

It checks, for every entity: the enqueued `entityType` has a `SyncHandler`; each handler is `registerHandler`ed in a
providers file; each Drift table is in `@DriftDatabase(tables:)` and in `clearAllData()`; and each syncable repository is
refreshed in `_syncFromServer()` in `auth_notifier.dart`.

The script also fails on pre-existing problems (savings has no handler at the time of writing). Only the lines about
**your** entity must be `ok`. Report any other failures to the user rather than fixing them silently.

## 5. Test

- Repository: a create/update/delete writes locally **and** enqueues with the right `entityType`/operation/payload;
  `refreshFromServer` returns `NetworkFailure` when offline.
- SyncHandler: `pushCreate` calls the remote and then `markSynced` with the server ID; `applyServerVersion` saves and marks synced.
- Mocks go in `test/helpers/mock_providers.dart`.

## Done when

- `check_sync_wiring.sh` shows `ok` for every line naming the new entity.
- `schemaVersion` went up by one, with a matching `onUpgrade` block.
- `make gen` has run, `flutter analyze` is clean, and `flutter test` passes, including the step-5 tests.
