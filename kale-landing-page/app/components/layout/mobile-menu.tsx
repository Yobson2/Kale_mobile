"use client";

import { useEffect, useRef } from "react";
import { AnimatePresence, motion } from "framer-motion";
import { useTranslations } from "next-intl";
import { Link } from "@/app/i18n/navigation";
import { Logo } from "@/app/components/brand/logo";
import { GetAppCta } from "@/app/components/ui/get-app-cta";
import { navLinks } from "@/app/lib/constants";
import { LanguageSwitcher } from "./language-switcher";

interface MobileMenuProps {
  isOpen: boolean;
  onClose: () => void;
}

export function MobileMenu({ isOpen, onClose }: MobileMenuProps) {
  const t = useTranslations("nav");
  const panelRef = useRef<HTMLDivElement>(null);

  // Lock page scroll, close on Escape, keep focus inside, and restore it on close.
  useEffect(() => {
    if (!isOpen) return;
    const previouslyFocused = document.activeElement as HTMLElement | null;
    document.body.style.overflow = "hidden";
    panelRef.current?.querySelector<HTMLElement>("button, a")?.focus();

    const onKeyDown = (e: KeyboardEvent) => {
      if (e.key === "Escape") onClose();
      if (e.key !== "Tab" || !panelRef.current) return;
      const focusable = panelRef.current.querySelectorAll<HTMLElement>("a[href], button");
      const first = focusable[0];
      const last = focusable[focusable.length - 1];
      if (!first || !last) return;
      if (e.shiftKey && document.activeElement === first) {
        e.preventDefault();
        last.focus();
      } else if (!e.shiftKey && document.activeElement === last) {
        e.preventDefault();
        first.focus();
      }
    };
    document.addEventListener("keydown", onKeyDown);
    return () => {
      document.body.style.overflow = "";
      document.removeEventListener("keydown", onKeyDown);
      previouslyFocused?.focus();
    };
  }, [isOpen, onClose]);

  return (
    <AnimatePresence>
      {isOpen && (
        <motion.div
          id="mobile-menu"
          ref={panelRef}
          role="dialog"
          aria-modal="true"
          aria-label={t("primary")}
          className="bg-paper fixed inset-0 z-[100] flex flex-col lg:hidden"
          initial={{ opacity: 0 }}
          animate={{ opacity: 1 }}
          exit={{ opacity: 0 }}
          transition={{ duration: 0.2 }}
        >
          <div className="container-page flex h-16 items-center justify-between">
            <Logo />
            <button
              type="button"
              onClick={onClose}
              className="text-ink hover:bg-ink/5 -mr-2 flex size-11 items-center justify-center rounded-xl transition"
              aria-label={t("closeMenu")}
            >
              <svg viewBox="0 0 24 24" className="size-6" aria-hidden="true">
                <path
                  d="M6 6l12 12M18 6L6 18"
                  stroke="currentColor"
                  strokeWidth="1.8"
                  strokeLinecap="round"
                />
              </svg>
            </button>
          </div>

          <ul className="container-page mt-6 flex flex-col">
            {navLinks.map((link, i) => (
              <motion.li
                key={link.href}
                initial={{ opacity: 0, y: 12 }}
                animate={{ opacity: 1, y: 0 }}
                transition={{ delay: 0.05 + i * 0.05, duration: 0.3 }}
              >
                <Link
                  href={link.href}
                  onNavigate={onClose}
                  className="font-display text-ink flex min-h-14 items-center text-3xl font-semibold tracking-tight"
                >
                  {t(link.textKey)}
                </Link>
              </motion.li>
            ))}
          </ul>

          <div className="container-page mt-auto flex flex-col gap-5 pb-[max(1.5rem,env(safe-area-inset-bottom))]">
            <LanguageSwitcher />
            <GetAppCta className="w-full" />
          </div>
        </motion.div>
      )}
    </AnimatePresence>
  );
}
