#!/usr/bin/env bash
# Verifies offline-sync wiring for every syncable entity.
# Run from the Flutter project root: bash .claude/skills/add-syncable-entity/check_sync_wiring.sh
# Exit code 1 if any check fails.

set -u
fail=0
lib=lib/features

ok()  { printf '  ok    %s\n' "$1"; }
bad() { printf '  FAIL  %s\n' "$1"; fail=1; }

# entityType strings enqueued by local datasources.
enqueued=$(grep -rhoE "_entityType = '[a-z_]+'" "$lib" --include='*_local_datasource.dart' | sed -E "s/.*'(.*)'/\1/" | sort -u)
# entityType strings handled by SyncHandlers.
handled=$(grep -rhoE "entityType => '[a-z_]+'" "$lib" --include='*_sync_handler.dart' | sed -E "s/.*'(.*)'/\1/" | sort -u)

echo "1. Every enqueued entityType has a SyncHandler"
for t in $enqueued; do
  if grep -qx "$t" <<<"$handled"; then ok "$t"; else bad "$t is enqueued but no SyncHandler declares it"; fi
done

echo "2. Every SyncHandler is registered with the engine"
# Handlers are registered eagerly: each handler's provider must be listed in
# syncHandlersProvider, which the engine reads at construction.
sync_providers=lib/core/sync/sync_providers.dart
for f in $(grep -rlE "implements SyncHandler" "$lib" --include='*_sync_handler.dart'); do
  cls=$(grep -oE "class [A-Za-z]+ implements SyncHandler" "$f" | awk '{print $2}')
  # FooSyncHandler is constructed in a *_providers.dart as fooSyncHandlerProvider.
  prov="$(tr '[:upper:]' '[:lower:]' <<<"${cls:0:1}")${cls:1}Provider"
  if grep -rqE "$cls\(" "$lib" --include='*_providers.dart' && \
     grep -q "ref.watch($prov)" "$sync_providers"; then
    ok "$cls"
  else
    bad "$cls is not provided as $prov in a *_providers.dart and listed in syncHandlersProvider ($sync_providers)"
  fi
done

echo "3. Every Drift table is registered in AppDatabase and cleared on logout"
db=lib/core/database/app_database.dart
for f in $(find "$lib" -path '*/data/tables/*_table.dart'); do
  for tbl in $(grep -oE "^class [A-Za-z]+ extends Table" "$f" | awk '{print $2}'); do
    getter="$(tr '[:upper:]' '[:lower:]' <<<"${tbl:0:1}")${tbl:1}"
    grep -qE "^\s+$tbl,$" "$db" && reg=1 || reg=0
    grep -qE "delete\($getter\)" "$db" && clr=1 || clr=0
    if [ $reg = 1 ] && [ $clr = 1 ]; then ok "$tbl"
    else
      [ $reg = 0 ] && bad "$tbl missing from @DriftDatabase(tables: ...)"
      [ $clr = 0 ] && bad "$tbl missing from clearAllData()"
    fi
  done
done

echo "4. Reads never pull: no syncable repository uses a remote datasource"
# Pulling happens only through the SyncHandlers (restore and pull-to-refresh,
# see SyncPuller), so a repository has no reason to reach the server.
for f in $(grep -rlE "enqueueSync" "$lib" --include='*_repository_impl.dart'); do
  iface=$(grep -oE "implements [A-Za-z]+Repository" "$f" | awk '{print $2}')
  if grep -qE "_remote_datasource.dart|RemoteDataSource" "$f"; then bad "$iface ($f) depends on a remote datasource"; else ok "$iface"; fi
done

echo
[ $fail = 0 ] && echo "Sync wiring OK" || echo "Sync wiring has failures"
exit $fail
