"use client";

import { useLocale, useTranslations } from "next-intl";
import { usePathname, useRouter } from "@/app/i18n/navigation";
import { routing, type Locale } from "@/app/i18n/routing";
import { cn } from "@/app/lib/utils";

const localeLabels: Record<Locale, { short: string; name: string }> = {
  fr: { short: "FR", name: "Français" },
  en: { short: "EN", name: "English" },
};

export function LanguageSwitcher({ inverted = false }: { inverted?: boolean }) {
  const locale = useLocale() as Locale;
  const pathname = usePathname();
  const router = useRouter();
  const t = useTranslations("nav");

  return (
    <div
      role="group"
      aria-label={t("language")}
      className={cn(
        "inline-flex w-fit rounded-xl p-1",
        inverted ? "bg-white/10" : "bg-surface-low"
      )}
    >
      {routing.locales.map((l) => {
        const isActive = l === locale;
        return (
          <button
            key={l}
            type="button"
            lang={l}
            onClick={() => router.replace(pathname, { locale: l })}
            aria-pressed={isActive}
            aria-label={localeLabels[l].name}
            className={cn(
              "min-h-9 min-w-11 rounded-lg px-2.5 text-xs font-semibold tracking-wide transition",
              isActive
                ? inverted
                  ? "text-ink bg-white"
                  : "bg-surface-lowest text-ink shadow-ghost"
                : inverted
                  ? "text-white/70 hover:text-white"
                  : "text-ink-muted hover:text-ink"
            )}
          >
            {localeLabels[l].short}
          </button>
        );
      })}
    </div>
  );
}
