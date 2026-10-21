"use client";

import { useCallback, useEffect, useState } from "react";
import { useTranslations } from "next-intl";
import { Link } from "@/app/i18n/navigation";
import { Logo } from "@/app/components/brand/logo";
import { GetAppCta } from "@/app/components/ui/get-app-cta";
import { navLinks } from "@/app/lib/constants";
import { cn } from "@/app/lib/utils";
import { LanguageSwitcher } from "./language-switcher";
import { MobileMenu } from "./mobile-menu";

export function Navbar() {
  const t = useTranslations("nav");
  const [isMenuOpen, setIsMenuOpen] = useState(false);
  const [isScrolled, setIsScrolled] = useState(false);
  // Stable, so the menu's Escape/focus effect doesn't re-run on every scroll render.
  const closeMenu = useCallback(() => setIsMenuOpen(false), []);

  useEffect(() => {
    const onScroll = () => setIsScrolled(window.scrollY > 8);
    onScroll();
    window.addEventListener("scroll", onScroll, { passive: true });
    return () => window.removeEventListener("scroll", onScroll);
  }, []);

  return (
    <>
      <header
        className={cn(
          "sticky top-0 z-50 transition-[background-color,box-shadow,backdrop-filter] duration-300",
          isScrolled
            ? "bg-paper/80 shadow-[0_1px_0_rgba(15,23,42,0.06)] backdrop-blur-lg"
            : "bg-transparent"
        )}
      >
        <nav
          aria-label={t("primary")}
          className="container-page flex h-16 items-center justify-between gap-6 md:h-18"
        >
          <Link href="/" aria-label={t("home")} className="-ml-1 rounded-lg p-1">
            <Logo />
          </Link>

          <ul className="hidden items-center gap-1 lg:flex">
            {navLinks.map((link) => (
              <li key={link.href}>
                <Link
                  href={link.href}
                  className="text-ink-soft hover:bg-ink/5 hover:text-ink rounded-lg px-3 py-2 text-sm font-medium transition"
                >
                  {t(link.textKey)}
                </Link>
              </li>
            ))}
          </ul>

          <div className="hidden items-center gap-3 lg:flex">
            <LanguageSwitcher />
            <GetAppCta size="md" short />
          </div>

          <button
            type="button"
            onClick={() => setIsMenuOpen(true)}
            className="text-ink hover:bg-ink/5 -mr-2 flex size-11 items-center justify-center rounded-xl transition lg:hidden"
            aria-label={t("openMenu")}
            aria-expanded={isMenuOpen}
            aria-controls="mobile-menu"
          >
            <svg viewBox="0 0 24 24" className="size-6" aria-hidden="true">
              <path
                d="M4 8h16M4 16h10"
                stroke="currentColor"
                strokeWidth="1.8"
                strokeLinecap="round"
              />
            </svg>
          </button>
        </nav>
      </header>

      {/* Outside the header: its backdrop-filter would otherwise trap this fixed overlay inside it. */}
      <MobileMenu isOpen={isMenuOpen} onClose={closeMenu} />
    </>
  );
}
