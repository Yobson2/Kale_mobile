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
for f in $(grep -rlE "implements SyncHandler" "$lib" --include='*_sync_handler.dart'); do
  cls=$(grep -oE "class [A-Za-z]+ implements SyncHandler" "$f" | awk '{print $2}')
  if grep -rqE "$cls\(" "$lib" --include='*_providers.dart' && \
     grep -rq "registerHandler" "$(grep -rlE "$cls\(" "$lib" --include='*_providers.dart' | head -1)"; then
    ok "$cls"
  else
    bad "$cls is never constructed + registerHandler'd in a *_providers.dart"
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

echo "4. Every syncable repository is refreshed after login"
notifier=lib/features/auth/presentation/providers/auth_notifier.dart
for f in $(grep -rlE "enqueueSync" "$lib" --include='*_repository_impl.dart'); do
  iface=$(grep -oE "implements [A-Za-z]+Repository" "$f" | awk '{print $2}')
  prov="$(tr '[:upper:]' '[:lower:]' <<<"${iface:0:1}")${iface:1}Provider"
  if grep -q "$prov).refreshFromServer" "$notifier"; then ok "$iface"; else bad "$iface not in _syncFromServer() in auth_notifier.dart"; fi
done

echo
[ $fail = 0 ] && echo "Sync wiring OK" || echo "Sync wiring has failures"
exit $fail
