import { useTranslations } from "next-intl";
import { ButtonLink } from "@/app/components/ui/button";
import { hasApk, siteConfig } from "@/app/lib/constants";
import { cn } from "@/app/lib/utils";

interface GetAppCtaProps {
  size?: "md" | "lg";
  variant?: "primary" | "light";
  short?: boolean;
  className?: string;
}

function ArrowDownIcon() {
  return (
    <svg viewBox="0 0 16 16" className="size-4" aria-hidden="true">
      <path
        d="M8 2.5v9m-3.5-3.5L8 11.5 11.5 8M3 13.5h10"
        fill="none"
        stroke="currentColor"
        strokeWidth="1.6"
        strokeLinecap="round"
        strokeLinejoin="round"
      />
    </svg>
  );
}

/**
 * The page's main action: the Android APK download. Without an APK URL it
 * falls back to a pre-filled "notify me" email.
 */
export function GetAppCta({
  size = "lg",
  variant = "primary",
  short = false,
  className,
}: GetAppCtaProps) {
  const t = useTranslations("cta");

  if (hasApk) {
    const label = short ? t("apkShort") : t("apk");
    return (
      <ButtonLink
        href={siteConfig.downloads.apk}
        size={size}
        variant={variant}
        className={className}
        aria-label={`${label} (${t("apkFile")})`}
      >
        <ArrowDownIcon />
        {label}
      </ButtonLink>
    );
  }

  const href = `mailto:${siteConfig.email}?subject=${encodeURIComponent(t("notifySubject"))}&body=${encodeURIComponent(t("notifyBody"))}`;
  const label = short ? t("notifyShort") : t("notify");

  return (
    <ButtonLink
      href={href}
      size={size}
      variant={variant}
      className={className}
      aria-label={`${label} (${t("opensEmail")})`}
    >
      {label}
    </ButtonLink>
  );
}

type Store = "googlePlay" | "appStore";

function StoreIcon({ store }: { store: Store }) {
  // Generic glyphs (a play triangle, a phone), not the stores' trademarked logos.
  return store === "googlePlay" ? (
    <svg viewBox="0 0 24 24" className="size-5" aria-hidden="true">
      <path
        d="M6 4.5v15l13-7.5z"
        fill="none"
        stroke="currentColor"
        strokeWidth="1.7"
        strokeLinejoin="round"
      />
    </svg>
  ) : (
    <svg viewBox="0 0 24 24" className="size-5" aria-hidden="true">
      <rect
        x="7"
        y="3"
        width="10"
        height="18"
        rx="2.5"
        fill="none"
        stroke="currentColor"
        strokeWidth="1.7"
      />
      <path d="M11 17.5h2" stroke="currentColor" strokeWidth="1.7" strokeLinecap="round" />
    </svg>
  );
}

/**
 * Google Play and App Store buttons. A store without a link renders as a
 * disabled, non-focusable badge marked "coming soon".
 */
export function StoreButtons({
  inverted = false,
  className,
}: {
  inverted?: boolean;
  className?: string;
}) {
  const t = useTranslations("cta");
  const stores: Store[] = ["googlePlay", "appStore"];

  return (
    <ul className={cn("flex flex-wrap gap-3", className)}>
      {stores.map((store) => {
        const url = siteConfig.downloads[store];
        const content = (
          <>
            <StoreIcon store={store} />
            <span className="flex flex-col items-start leading-tight">
              <span className="text-[0.6875rem] font-medium opacity-75">
                {url ? t(`${store}Prefix`) : t("comingSoonShort")}
              </span>
              <span className="text-sm font-semibold">{t(`${store}Name`)}</span>
            </span>
          </>
        );
        const base = "inline-flex h-12 min-w-40 items-center gap-3 rounded-xl px-4";

        return (
          <li key={store}>
            {url ? (
              <a
                href={url}
                className={cn(
                  base,
                  "transition active:scale-[0.98]",
                  inverted
                    ? "text-ink bg-white hover:bg-white/90"
                    : "bg-ink hover:bg-ink/90 text-white"
                )}
              >
                {content}
              </a>
            ) : (
              <span
                title={t("storeUnavailable")}
                className={cn(
                  base,
                  "cursor-not-allowed select-none",
                  inverted ? "bg-white/[0.08] text-white/60" : "bg-surface-high text-ink-muted"
                )}
              >
                {content}
                <span className="sr-only">{t("storeUnavailable")}</span>
              </span>
            )}
          </li>
        );
      })}
    </ul>
  );
}
