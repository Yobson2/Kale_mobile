import type { MetadataRoute } from "next";
import { siteConfig } from "@/app/lib/constants";
import { routing } from "@/app/i18n/routing";

const pages = [
  { path: "", changeFrequency: "monthly", priority: 1 },
  { path: "/privacy", changeFrequency: "yearly", priority: 0.3 },
  { path: "/terms", changeFrequency: "yearly", priority: 0.3 },
] as const;

export default function sitemap(): MetadataRoute.Sitemap {
  return pages.map(({ path, changeFrequency, priority }) => ({
    url: `${siteConfig.url}/${routing.defaultLocale}${path}`,
    lastModified: new Date(),
    changeFrequency,
    priority,
    alternates: {
      languages: Object.fromEntries(
        routing.locales.map((locale) => [locale, `${siteConfig.url}/${locale}${path}`])
      ),
    },
  }));
}
