import type { NavLink } from "@/app/types";

/**
 * ===== SITE CONFIGURATION =====
 * Single source of truth for Kalé's identity on the web.
 * Translatable strings live in /messages/{locale}.json.
 */
export const siteConfig = {
  name: "Kalé",
  // The app's share page links to kale-app.com; override per environment.
  url: process.env.NEXT_PUBLIC_SITE_URL ?? "https://kale-app.com",

  themeColor: "#006c49",

  // Addresses used in the app's own legal text (Kale/lib/l10n/app_en.arb).
  email: "support@kale.app",
  privacyEmail: "privacy@kale.app",

  downloads: {
    /**
     * Direct Android download. GitHub serves the `kale.apk` asset of the newest
     * release at this URL, so publishing a release updates the button. Set
     * NEXT_PUBLIC_APK_URL to host it elsewhere, or to "" to hide the button
     * (the CTA then falls back to a launch-notification email).
     */
    apk:
      process.env.NEXT_PUBLIC_APK_URL ??
      "https://github.com/Yobson2/Kale_mobile/releases/latest/download/kale.apk",
    // Store listings: while null, the store buttons show disabled with "coming soon".
    googlePlay: null as string | null,
    appStore: null as string | null,
  },
} as const;

export const hasApk = Boolean(siteConfig.downloads.apk);

export const navLinks: NavLink[] = [
  { href: "/#product", textKey: "product" },
  { href: "/#offline", textKey: "offline" },
  { href: "/#faq", textKey: "faq" },
];
