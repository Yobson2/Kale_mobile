# Deployment

How to ship each part of Kalé: the backend, the mobile app and the landing page. Environments and define files are
described in `docs/development.md` § Environments; this page assumes `config/staging.json` and
`config/production.json` are filled in.

Order for a release: **backend first** (migrations reach staging, then production), then the app builds that rely on
them.

## 1. Backend (Supabase)

The schema, RLS policies and `pg_cron` jobs live in `supabase/migrations/` and are the only way the schema changes.
Never edit a remote schema from the dashboard or paste migrations into the SQL editor (`db push` would then try to
apply them again).

```bash
make db-reset && make db-test                     # replay every migration locally and run the pgTAP tests (Docker)

npx supabase link --project-ref <staging-ref>     # asks for the database password
npx supabase db push                              # applies pending migrations to staging
# check the staging app, then:
npx supabase link --project-ref <production-ref>
npx supabase db push
```

`make db-diff-live` writes the difference between the linked project and the migrations to
`supabase/live_drift.sql` (empty means no drift).

### Project settings that migrations don't cover

Set these by hand on **each** project (staging and production), in the Supabase dashboard:

| Setting | Where | Why |
|---|---|---|
| Allow anonymous sign-ins, plus a rate limit per IP | Authentication → Sign In / Providers, Authentication → Rate Limits | Every fresh install signs in anonymously (`supabase/README.md` § Anonymous users) |
| Manual linking | Authentication settings | Lets an anonymous user link email, Google or Apple (decisions, Phase 1 item 4) |
| Email templates with `{{ .Token }}` | Authentication → Email Templates | The app verifies by code, not by link; the local versions are in `supabase/templates/` |
| Google and Apple providers | Authentication → Sign In / Providers | Use the **web** Google client ID; Google and Apple use `signInWithIdToken` |

## 2. Android

### Signing

Release builds are signed with the upload key described in `android/key.properties`:

```bash
cd android
keytool -genkey -v -keystore upload-keystore.jks -keyalg RSA -keysize 2048 -validity 10000 -alias upload
cp key.properties.example key.properties   # fill in passwords, alias and storeFile
```

Never commit `key.properties` or the `.jks` file. **If `key.properties` is missing, `android/app/build.gradle`
silently falls back to the debug key**, so check that it exists before building anything you will distribute.

### Builds

| Command | Output | Use |
|---|---|---|
| `make build-staging` | `build/app/outputs/flutter-apk/app-staging-release.apk` | Testers; installs as `com.kale.app.staging` ("Kalé Staging"), next to the production app |
| `make build-prod` | `build/app/outputs/bundle/productionRelease/app-production-release.aab` | Google Play upload (`com.kale.app`) |

R8 shrinking is enabled for release builds. `bootstrap` refuses to start if the define file doesn't match the flavor
(`lib/core/config/env_validation.dart`), so a staging build can't reach the production project.

### Direct APK download

The landing page's download button points to
`https://github.com/Yobson2/Kale_mobile/releases/latest/download/kale.apk`. To make it work, publish a GitHub release
with a signed production APK attached as exactly `kale.apk`:

```bash
fvm flutter build apk --flavor production --dart-define-from-file=config/production.json
# attach build/app/outputs/flutter-apk/app-production-release.apk to the release, renamed kale.apk
```

## 3. iOS

There are no Xcode schemes or flavors yet, so build without `--flavor`. The define file alone picks the backend,
and both environments share the bundle ID `com.kale.app`:

```bash
fvm flutter build ipa --dart-define-from-file=config/production.json
```

Upload the resulting archive with Xcode or Transporter. Adding proper `staging` and `production` schemes is described
in `docs/development.md` § Flavors.

## 4. Store listings

The Play Store and App Store copy (French and English) lives in `store_listings/`. App icons and the splash screen
are regenerated with `make icons` and `make splash`.

## 5. Landing page

The marketing site is a separate Next.js 16 project (`kale-landing-page`), deployed on Vercel at
https://kale-landing-page.vercel.app.

```bash
cd kale-landing-page
npm ci && npm run build      # check the build locally
vercel deploy --prod         # production deploy (the folder is already linked to the Vercel project)
```

Optional environment variables on Vercel: `NEXT_PUBLIC_SITE_URL` (the canonical URL; defaults to
`https://kale-app.com`) and `NEXT_PUBLIC_APK_URL` (overrides the APK link above; an empty string hides the button).

## Release checklist

The bar before any public beta is decision Q7 in `docs/decisions.md`. Still open at the time of writing: account
deletion (Edge Function), Sentry, failing release builds that have no keystore, legal text review and an APK-size
budget.
