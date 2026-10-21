import { useTranslations } from "next-intl";
import { Link } from "@/app/i18n/navigation";
import { Logo } from "@/app/components/brand/logo";
import { navLinks, siteConfig } from "@/app/lib/constants";
import { LanguageSwitcher } from "./language-switcher";

export function Footer() {
  const t = useTranslations("footer");
  const tNav = useTranslations("nav");

  const linkClass =
    "inline-flex min-h-9 items-center text-sm text-white/70 transition hover:text-white";

  return (
    <footer className="on-night bg-night text-white">
      <div className="container-page grid grid-cols-1 gap-12 py-16 md:grid-cols-[1.4fr_1fr_1fr_1fr] md:py-20">
        <div className="max-w-xs">
          <Link href="/" aria-label={tNav("home")} className="-ml-1 inline-block rounded-lg p-1">
            <Logo inverted />
          </Link>
          <p className="mt-4 text-sm leading-relaxed text-white/70">{t("tagline")}</p>
        </div>

        <nav aria-label={t("product")}>
          <h2 className="eyebrow font-sans text-white/50">{t("product")}</h2>
          <ul className="mt-4 space-y-1">
            {navLinks.map((link) => (
              <li key={link.href}>
                <Link href={link.href} className={linkClass}>
                  {tNav(link.textKey)}
                </Link>
              </li>
            ))}
          </ul>
        </nav>

        <nav aria-label={t("legal")}>
          <h2 className="eyebrow font-sans text-white/50">{t("legal")}</h2>
          <ul className="mt-4 space-y-1">
            <li>
              <Link href="/privacy" className={linkClass}>
                {t("privacy")}
              </Link>
            </li>
            <li>
              <Link href="/terms" className={linkClass}>
                {t("terms")}
              </Link>
            </li>
          </ul>
        </nav>

        <div>
          <h2 className="eyebrow font-sans text-white/50">{t("contact")}</h2>
          <a href={`mailto:${siteConfig.email}`} className={`${linkClass} mt-4`}>
            {siteConfig.email}
          </a>
        </div>
      </div>

      <div className="container-page flex flex-col-reverse items-start justify-between gap-4 border-t border-white/10 py-6 sm:flex-row sm:items-center">
        <p className="text-xs text-white/50">
          {t("copyright", { year: new Date().getFullYear() })}
        </p>
        <LanguageSwitcher inverted />
      </div>
    </footer>
  );
}
