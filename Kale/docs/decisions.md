# Decisions

Product and technical decisions agreed on 2026-10-13, after a design review of the v1 codebase.
**This file is the target. Where the code disagrees, the code is behind:** new work follows these decisions, and
other docs (`architecture.md`, `offline_sync.md`) describe the current implementation until each phase updates them.

## Decision record

### Product

| # | Topic | Decision |
|---|---|---|
| Q1 | Market | French-speaking West Africa first. FR is the primary language; XOF and mobile money are central. |
| Q5 | v1 scope | Transactions, budgets with alerts, savings goals, insights, auth. Tontine shows "coming soon" (feature flag). Gamification ships only if finished; for v1 it is flagged off (owner's decision on #52), not deleted. |
| Q13 | Mobile money | Manual entry with a provider picker in v1. Android "share SMS to Kalé" parsing is the first post-launch feature. `READ_SMS` is never requested. |
| Q16 | Business model | Free v1. Never ads. Paywall-ready flags for advanced features (PDF statements, insights exports). |
| Q20 | Export | Free basic CSV export of transactions in v1 (share sheet). |
| Q21 | Budgets | One-off periods with a "Renew for next period" prompt when they end, plus a custom period start day (e.g. the 25th). Periods are stored as dates, not timestamps. Recurring templates with carry-over come later. |
| Q22 | Notifications | Local notifications only. Budget alerts at fixed 80% and 100% thresholds, at most once per threshold per budget period (tracked locally). Opt-in daily reminder, savings milestones. No FCM in v1. |
| Q24 | Tontine | Out of v1; gets its own design session. v1 keeps `user_id` ownership and RLS clean, so group membership tables can be added later. |

### Data and sync

| # | Topic | Decision |
|---|---|---|
| Q2 | Source of truth | The phone is authoritative; the server is backup and restore. One active device is the expected case. |
| Q3 | Guest mode | Anonymous Supabase auth. Guests always have a `user_id` and sync like everyone else; signing up links an identity to the anonymous user. |
| Q4 | Money | One base currency per account, chosen at onboarding. Amounts are stored as **integer minor units**. No per-entry currency, no conversion. |
| Q8 | Pulling | Pull only on restore (login on an empty DB, reinstall) and manual pull-to-refresh. Merge by `updatedAt`; a server row never overwrites a local row with `isSynced = false`. No refresh on reads, no whole-table replace. |
| Q9 | Pushing | Push after every write (debounced ~2s), on app resume, on connectivity regained, and on manual retry. Entries that exhaust retries are marked stuck and shown persistently ("N changes not backed up · Retry"). Retry counts reset on each app start. Nothing is dropped silently. |
| Q10 | Identity already exists | When linking fails because the identity belongs to an existing account, ask the user, defaulting to adding the guest data to that account (re-queue local rows under the new `user_id`). Anonymous accounts inactive for 90 days are deleted server-side. Anonymous sign-ups are rate-limited or protected by CAPTCHA. |
| Q11 | Migration | **Assumes no external users exist.** Reset both schemas: Drift restarts at `schemaVersion 1`, and the server schema is recreated from repo migrations. If real users exist, this becomes real two-sided migrations instead. |
| Q12 | Changing currency | The base currency is freely changeable while the account has no transactions; afterwards it is a relabel (no conversion) with an explicit warning. Decimal places are stored per currency (XOF 0; EUR, GHS, NGN 2) and drive input and formatting. |
| Q17 | Deletes | Soft delete everywhere: a `deleted_at` column on device and server; a delete is synced as an update; pulls apply tombstones; the server purges them after 30 days. |
| Q18 | Logout | Logout first tries to push pending changes. If some remain, it is blocked with an explicit destructive option ("N changes will be lost"). Anonymous users see "Create an account to save your data" instead of "Log out". |
| Q23 | Scale | Target: 10,000 transactions per user stays smooth on a 2 GB-RAM Android phone. Drift indexes on `(date)` and `(category_id, date)`; server index on `(user_id, updated_at)`. Paginated transaction list; restore paginated by `updated_at` with progress. An APK-size budget is enforced. |

### Platform, security, release

| # | Topic | Decision |
|---|---|---|
| Q6 | Backend | Supabase migrations live in the repo (`supabase/`) as the source of truth, with RLS tests. Server triggers never compute values the client also writes (the savings `current_amount` trigger is dropped). |
| Q14 | Localization | `app_fr.arb` is the template ARB. Formatting follows the device locale with `fr` as fallback (`10 000 FCFA`, `13 oct. 2026`). All strings get a native-speaker review before beta. |
| Q15 | Environments | Separate staging and prod Supabase projects, selected by build flavors with `--dart-define-from-file`. No bundled `.env`; only client-safe values reach the binary. |
| Q19 | Account deletion | A Supabase Edge Function (service role) deletes the auth user and all their data, anonymous users included. Immediate, requires re-authentication, then wipes local data. The privacy policy states backup retention. |
| Q7 | Release bar (before any public beta) | Account deletion; release builds fail without a release keystore; CI runs; Sentry is wired; the sync paths are tested; legal text matches actual behavior. |

## Work plan (dependency order)

**Phase 0: Foundations.** Everything else depends on these. **Done in code** (#2, #5, #6, #7; spec #1); the steps
that need the Supabase dashboard are listed under item 2.
1. ✅ Restore `supabase/` from git (the parent of commit `0d589e2`) and diff it against the live project. (Q6)
   *Done (#21). Still to do by hand: the written diff against the live project (`make db-diff-live`, needs the
   database password).*
2. ✅ Staging and prod projects, build flavors, `--dart-define-from-file`; remove the bundled `.env` and `FCM_SERVER_KEY`. (Q15, Q22)
   *Done in code (#21). Still to do by hand: create the two projects, fill `config/staging.json` and
   `config/production.json`, `npx supabase db push` to each, and add the iOS schemes in Xcode.*
3. ✅ Schema reset on device and server: minor units, base currency, currencies table with decimals (Q4, Q12);
   `deleted_at` (Q17); date-based budget periods with a start day (Q21); indexes (Q23); drop the savings trigger (Q6);
   RLS supporting anonymous users and future groups (Q3, Q24). *Done (#25, #27, #32, #33, #38, #40).*

**Phase 1: Sync correctness**
4. ✅ Anonymous auth: linking, the "identity already exists" prompt, 90-day cleanup, rate limits. (Q3, Q10)
   *Done (#25, #42, #43). Linking needs "Manual linking" enabled and a change-email template with `{{ .Token }}` on
   each project.*
5. ✅ Sync engine: four push triggers, stuck-entry UI, retry reset (Q9); merge-on-pull replacing `replaceAll` and the
   background refresh (Q8); tombstones (Q17); paginated restore (Q23); remove the dead HTTP-409 conflict path.
   *Done (#26, #39, #41, #42).*
6. ✅ Savings: a separate `savings_contribution` entity type, with sync handlers for goals and contributions.
   *Done (#32).*
7. ✅ Logout guard. (Q18) *Done (#30).*

**Phase 2: v1 product**
8. Base-currency onboarding, currency-change rules, currency-aware formatting. (Q12, Q14)
9. FR as the template ARB, restore accents, native-speaker review. (Q14)
10. Budget renew prompt and custom start day; alerts at most once per threshold per period. (Q21, Q22)
11. CSV export, tontine "coming soon" flag, gamification keep-or-cut, paywall flags. (Q5, Q16, Q20)
12. Paginated transaction list. (Q23)

**Phase 3: Release bar** (Q7, Q19)
13. Account-deletion Edge Function with re-authentication.
14. Release builds fail without a keystore; ~~move CI to the repository root~~ (done early, #15); Sentry; tests on the sync paths; legal text
    review (backups, anonymous data, deletion); APK-size budget.

Each phase updates `docs/architecture.md`, `docs/offline_sync.md`, and the affected `.claude/skills/` in the same
change, so docs and skills never teach a pattern these decisions replaced.
