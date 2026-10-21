# Contributing to Kalé

Thanks for helping out. This guide covers the workflow; the technical details are in
[Kale/docs/development.md](Kale/docs/development.md) and [Kale/docs/architecture.md](Kale/docs/architecture.md).

## Before you start

- Work is tracked in [GitHub Issues](https://github.com/Yobson2/Kale_mobile/issues). Pick an existing issue, or open
  one to discuss a change before writing code.
- Read [Kale/docs/decisions.md](Kale/docs/decisions.md). It is the target state: new work follows it even where the
  current code doesn't yet. If your change conflicts with a decision, say so in the issue rather than copying the
  old pattern.
- Set up the toolchain: FVM with Flutter 3.44.2, then `make get && make gen && make run`
  (see [Getting started](README.md#getting-started)).

## Workflow

1. Branch from an up-to-date `main`. Use one branch per issue, named by type: `feat/…`, `fix/…`, `docs/…`,
   `chore/…`.
2. Keep the change focused on that issue.
3. Write commits in [Conventional Commits](https://www.conventionalcommits.org) style with an optional scope, e.g.
   `feat(budget): custom period start day (#49)` or `fix(l10n): …`.
4. Open a pull request against `main` with `Closes #<issue>` in the description, plus what changed and how you
   tested it. Screenshots help for UI changes.
5. CI must pass. The maintainer reviews and merges.

## Definition of done

Run these from `Kale/`:

```bash
dart format .     # no changes left
make analyze      # no issues
make test         # all green
```

CI also runs `bash .claude/skills/add-syncable-entity/check_sync_wiring.sh`. If you touched `supabase/`, run
`make db-reset && make db-test` locally (needs Docker), because CI doesn't run the SQL tests.

## House rules

- **Layers:** pages talk to notifiers, notifiers call use cases (never repositories), repositories return
  `Either<Failure, T>`. Business logic lives in use cases, data access in datasources.
- **Offline-first:** writes go to Drift and the sync queue. A new syncable entity needs a `SyncHandler` registered in
  `syncHandlersProvider`, or its writes never reach the server (see
  [offline_sync.md](Kale/docs/offline_sync.md)).
- **Money** is an integer amount of minor units (`int amountMinor`, `Money`); never a `double`.
- **Strings** go through l10n: add every key to both `lib/l10n/app_fr.arb` (the template) and `app_en.arb`, with
  real French, then run `make l10n`.
- **Generated files** (`*.g.dart`, `*.freezed.dart`, `app_localizations*.dart`) are outputs: edit the source, then
  run `make gen`. Changing a Drift table also needs a `schemaVersion` bump.
- **Schema changes** are Supabase migrations (`npx supabase migration new <name>`), never dashboard edits. Add or
  update the pgTAP tests in `supabase/tests/database/`.
- **Styling** comes from the theme tokens in `lib/core/theme/` and follows the
  [design system](Kale/docs/Kale_design/kal_modern_heritage/DESIGN.md).
- **Secrets** never go in the repo or in a define file: only client-safe values (project URL, anon key, OAuth client
  IDs) are compiled into the app.
- **Docs move with the code:** if a change alters a pattern described in `Kale/docs/` or a skill in
  `Kale/.claude/skills/`, update it in the same pull request.
