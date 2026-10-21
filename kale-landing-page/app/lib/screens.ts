import type { Locale } from "@/app/i18n/routing";

/**
 * Real screens captured from the Kalé app (Pixel 6a, guest account, data entered
 * by hand in mock mode), exported as 720px WebP. Re-capture them when the app UI changes.
 */
export const screenNames = ["home", "add", "budget", "savings", "insights"] as const;
export type ScreenName = (typeof screenNames)[number];

export const SCREEN_WIDTH = 1080;
export const SCREEN_HEIGHT = 2400;

export function screenSrc(locale: string, name: ScreenName) {
  const l: Locale = locale === "en" ? "en" : "fr";
  return `/assets/screens/${l}/${name}.webp`;
}
