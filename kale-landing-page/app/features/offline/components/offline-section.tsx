"use client";

import { motion } from "framer-motion";
import { useTranslations } from "next-intl";
import { LogoMark } from "@/app/components/brand/logo";
import { reveal } from "@/app/lib/animations";
import { SyncDemo } from "./sync-demo";

const pillars = ["phone", "guest", "ads", "local"] as const;

export function OfflineSection() {
  const t = useTranslations("offline");

  return (
    <section
      id="offline"
      aria-labelledby="offline-title"
      className="on-night bg-night relative overflow-hidden py-24 text-white md:py-32"
    >
      <LogoMark
        mono
        className="pointer-events-none absolute -bottom-40 -left-32 size-[36rem] text-white/[0.025]"
      />

      <div className="container-page relative">
        <div className="grid grid-cols-1 items-center gap-14 lg:grid-cols-[1.1fr_1fr] lg:gap-20">
          <div className="max-w-xl">
            <motion.p {...reveal()} className="eyebrow text-emerald-200">
              {t("eyebrow")}
            </motion.p>
            <motion.h2
              id="offline-title"
              {...reveal(0.05)}
              className="mt-4 text-4xl leading-[1.05] font-bold tracking-[-0.035em] md:text-6xl"
            >
              {t("title")}
            </motion.h2>
            <motion.p {...reveal(0.1)} className="mt-6 text-lg leading-relaxed text-white/75">
              {t("body")}
            </motion.p>
          </div>

          <motion.div {...reveal(0.15)}>
            <SyncDemo />
          </motion.div>
        </div>

        <ul className="mt-20 grid grid-cols-1 gap-x-10 gap-y-10 sm:grid-cols-2 lg:grid-cols-4">
          {pillars.map((key, i) => (
            <motion.li
              key={key}
              {...reveal(i * 0.06, 16)}
              className="border-t border-white/15 pt-6"
            >
              <h3 className="font-display text-lg font-semibold tracking-tight">
                {t(`pillars.${key}.title`)}
              </h3>
              <p className="mt-2 text-[0.9375rem] leading-relaxed text-white/65">
                {t(`pillars.${key}.body`)}
              </p>
            </motion.li>
          ))}
        </ul>
      </div>
    </section>
  );
}
