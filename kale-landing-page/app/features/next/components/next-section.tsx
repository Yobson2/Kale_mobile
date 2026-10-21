"use client";

import { motion } from "framer-motion";
import { useTranslations } from "next-intl";
import { reveal } from "@/app/lib/animations";

/** The one roadmap item the app already announces (tontine is flagged "coming soon" in v1). */
export function NextSection() {
  const t = useTranslations("next");

  return (
    <section aria-labelledby="next-title" className="pt-24 md:pt-32">
      <div className="container-page">
        <motion.div
          {...reveal()}
          className="bg-gold-100 relative grid grid-cols-1 gap-8 overflow-hidden rounded-[2rem] p-8 md:grid-cols-[1fr_auto] md:items-end md:p-12"
        >
          {/* Four contributions passing around one circle. */}
          <svg
            viewBox="0 0 120 120"
            className="text-gold-500/30 pointer-events-none absolute -top-10 -right-10 size-56 md:size-72"
            aria-hidden="true"
          >
            <circle
              cx="60"
              cy="60"
              r="40"
              fill="none"
              stroke="currentColor"
              strokeWidth="1.5"
              strokeDasharray="4 6"
            />
            {[0, 90, 180, 270].map((deg) => (
              <circle
                key={deg}
                cx={60 + 40 * Math.cos((deg * Math.PI) / 180)}
                cy={60 + 40 * Math.sin((deg * Math.PI) / 180)}
                r="7"
                fill="currentColor"
              />
            ))}
          </svg>

          <div className="relative max-w-xl">
            <p className="eyebrow text-gold-800">{t("eyebrow")}</p>
            <h2
              id="next-title"
              className="text-ink mt-3 text-3xl font-bold tracking-[-0.03em] md:text-4xl"
            >
              {t("title")}
            </h2>
            <p className="text-ink-soft mt-4 text-lg leading-relaxed">{t("body")}</p>
          </div>
          <p className="bg-surface-lowest/70 text-gold-800 relative w-fit rounded-full px-3.5 py-1.5 text-xs font-semibold">
            {t("badge")}
          </p>
        </motion.div>
      </div>
    </section>
  );
}
