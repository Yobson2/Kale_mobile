# Kalé — landing page

The marketing site for [Kalé](../Kale), the offline-first budgeting app. French first (`/fr`), English at `/en`.

Built with Next.js 16 (App Router), React 19, TypeScript, Tailwind CSS 4, next-intl and Framer Motion.

## Pages

| Route | Content |
| --- | --- |
| `/[locale]` | Hero → why Kalé → product tour → offline & privacy → coming later → FAQ → final CTA |
| `/[locale]/privacy`, `/[locale]/terms` | The app's legal text, ported from `Kale/lib/l10n/app_*.arb` |
| `/[locale]/legal` | Permanent redirect to `/privacy` (old URL) |

## Where things live

```
app/
├── [locale]/          # Pages, layout (<html>, fonts), OG image, 404
├── components/        # Brand (logo), layout (navbar, footer), ui (buttons, phone frame, CTA)
├── features/          # One folder per page section (hero, problem, tour, offline, next, faq, final-cta, legal)
├── lib/
│   ├── constants.ts   # siteConfig: URL, contact emails, store links
│   └── screens.ts     # Real app screenshots used on the page
messages/{fr,en}.json  # All copy
public/assets/screens/ # App screenshots (720px WebP), one folder per locale
```

## Before launch

- **APK**: the download button points to `https://github.com/Yobson2/Kale_mobile/releases/latest/download/kale.apk`,
  so publish a GitHub release with a signed release APK attached under the exact name `kale.apk`
  (until then the link returns 404). Override with `NEXT_PUBLIC_APK_URL`; set it to an empty string to hide the
  button (the CTA then becomes a "notify me" email).
- **Store links**: set `siteConfig.downloads.googlePlay` / `appStore` in `app/lib/constants.ts`. While a link is
  `null`, its button shows disabled with "coming soon".
- **Site URL**: set `NEXT_PUBLIC_SITE_URL` (defaults to `https://kale-app.com`).
- **Screenshots**: re-capture `public/assets/screens/{fr,en}/*.webp` from the app (Pixel 6a, 1080×2400, mock mode,
  guest account) whenever the app UI changes, keeping the same file names.
- **Legal text**: it mirrors the app's ARB files; update both together.

## Scripts

| Command | Description |
| --- | --- |
| `npm run dev` | Dev server (Turbopack) |
| `npm run build` | Production build |
| `npm run start` | Serve the production build |
| `npm run lint` | ESLint |
| `npm run typecheck` | TypeScript |
| `npm run format` | Prettier |
