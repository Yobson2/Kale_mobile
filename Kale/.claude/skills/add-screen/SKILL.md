---
name: add-screen
description: Add a new screen to Kalé, covering the page, GoRouter route, entry point, and EN/FR strings. Use when asked to add or create a page, screen, or view, or to link a new destination from a menu, tab, or button.
---

# Add a screen

A screen touches five places that must stay in step: page, route constant, route registration, entry point, and both ARB files.
Reference: the `notifications` screen (commit `647756f`) is the smallest complete example.

## 1. Place it

Decide the **navigation home** before writing code:

| The screen is… | Register it… | Navigate with |
|---|---|---|
| A secondary destination reached from More (settings-like, info, tools) | Nested `GoRoute` under the `more` route in the **More branch** | `context.goNamed(...)` |
| A drill-down inside a tab (detail, setup) | Nested `GoRoute` under that tab's route | `context.pushNamed(...)` |
| Full-screen, covers the bottom nav (modal flow, add form, notifications) | Top-level `GoRoute` with `parentNavigatorKey: _rootNavigatorKey` | `context.pushNamed(...)` |
| Reachable before login (auth, legal) | Top-level, **and** add its path to `_publicPaths` | `context.go(...)` |

Owning feature: put the page in the feature it belongs to (`lib/features/<feature>/presentation/pages/`). A presentation-only
feature folder is fine for screens with no data.

## 2. Route

- In `lib/core/router/route_names.dart`, add a path constant and a `…Name` constant under the right section comment.
  The path of a nested route is its full path (`/more/<segment>`); the `GoRoute` itself declares only the segment.
- In `lib/core/router/app_router.dart`, import the page and register the `GoRoute` (`path`, `name`, `builder`).
  Pass arguments through `state.extra`, typed at the builder (`state.extra as Budget?`).
  Use `pageBuilder` + `AppPageTransitions` only for a non-default transition.

## 3. Page

- Compose from `lib/core/widgets/` first: `AppScaffold` (includes the offline banner) or `Scaffold`, plus `AppAppBar`,
  `AppEmptyState`, `AppErrorState`, `AsyncValueWidget`, `AppCard`, `AppListTile`, and the buttons.
  Create a new widget only when no core widget fits.
- Style through tokens: `AppSpacing`, `AppRadius`, `context.colorScheme`, `context.textTheme`, and the finance colors
  `context.colorScheme.income` / `.expense` / `.budget` / `.savings` (they adapt to light and dark mode).
- Keep the page a **thin composition**: once a section grows past ~80 lines, extract it into
  `presentation/widgets/` in the same feature.
- Data: `ref.watch` providers for reads; for mutations, `ref.listen` the notifier state and show
  `showAppSnackBar` on success or error (see `add_transaction_page.dart`).
- For a screen with a design, follow `docs/Kale_design/<screen>/` (`screen.png` + `code.html`) and `DESIGN.md`.

## 4. Strings

- Every visible string is an ARB key read through `context.l10n.<key>`. Prefix keys with the screen or feature
  (`notificationsTitle`, `moreTontineGroups`).
- Add each key to **`lib/l10n/app_en.arb` and `lib/l10n/app_fr.arb` in the same edit**, with the French translated.
  Placeholders need an `@key` block in `app_en.arb`.
- Run `make l10n`.

## 5. Entry point

Wire the way in: a `_MenuItem` in `more_page.dart`, a button, a dashboard card, or a notification tap.

## Done when

- `make gen` has run if `app_router.dart` changed, and `flutter analyze` is clean.
- EN/FR parity holds: both commands print the same number.
  ```bash
  grep -c '^  "[a-zA-Z]' lib/l10n/app_en.arb; grep -c '^  "[a-zA-Z]' lib/l10n/app_fr.arb
  ```
- The new page has no string literals inside `Text(`, `label:`, `title:`, or `hintText:`.
- The route is reachable from its entry point, and the back button returns to where the user came from.
