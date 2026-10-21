"use client";

import { useRef } from "react";
import { motion, useReducedMotion, useScroll, useTransform } from "framer-motion";
import { useLocale, useTranslations } from "next-intl";
import { LogoMark } from "@/app/components/brand/logo";
import { GetAppCta, StoreButtons } from "@/app/components/ui/get-app-cta";
import { PhoneFrame } from "@/app/components/ui/phone-frame";
import { siteConfig } from "@/app/lib/constants";
import { screenSrc } from "@/app/lib/screens";

const factKeys = ["free", "offline", "languages"] as const;

export function HeroSection() {
  const t = useTranslations("hero");
  const tCta = useTranslations("cta");
  const locale = useLocale();
  const ref = useRef<HTMLElement>(null);
  const reduceMotion = useReducedMotion();

  // The two screens drift apart slightly as the hero scrolls away.
  const { scrollYProgress } = useScroll({ target: ref, offset: ["start start", "end start"] });
  const mainY = useTransform(scrollYProgress, [0, 1], [0, reduceMotion ? 0 : -60]);
  const sideY = useTransform(scrollYProgress, [0, 1], [0, reduceMotion ? 0 : 40]);

  return (
    <section
      ref={ref}
      className="relative -mt-16 overflow-hidden pt-16 md:-mt-18 md:pt-18"
      aria-labelledby="hero-title"
    >
      {/* The K as structure: cropped, oversized, barely there. */}
      <LogoMark
        mono
        className="pointer-events-none absolute -top-24 -right-40 hidden size-[46rem] text-emerald-700/[0.045] lg:block"
      />

      <div className="container-page grid grid-cols-1 items-center gap-12 pt-10 pb-16 md:pt-16 lg:min-h-[calc(100svh-4.5rem)] lg:grid-cols-[1.05fr_1fr] lg:gap-8 lg:pb-24">
        <div className="hero-rise relative z-10 max-w-xl">
          {!(siteConfig.downloads.googlePlay && siteConfig.downloads.appStore) && (
            <p className="bg-gold-100 text-gold-800 inline-flex items-center gap-2 rounded-full py-1.5 pr-3.5 pl-2.5 text-xs font-semibold">
              <span className="bg-gold-500 size-1.5 rounded-full" aria-hidden="true" />
              {tCta("status")}
            </p>
          )}

          <h1
            id="hero-title"
            className="text-ink mt-6 text-[2.75rem] leading-[1.02] font-bold tracking-[-0.04em] sm:text-6xl lg:text-[4.5rem]"
          >
            {t("title")}
          </h1>

          <p className="text-ink-soft mt-6 max-w-lg text-lg leading-relaxed">{t("subtitle")}</p>

          <div className="mt-9 flex flex-col gap-3 sm:flex-row sm:items-center">
            <GetAppCta />
            <a
              href="#product"
              className="inline-flex h-13 items-center justify-center gap-2 rounded-xl px-5 text-base font-semibold text-emerald-800 transition hover:bg-emerald-700/[0.07]"
            >
              {t("secondary")}
              <svg viewBox="0 0 16 16" className="size-4" aria-hidden="true">
                <path
                  d="M8 3v9m-3.5-3.5L8 12l3.5-3.5"
                  fill="none"
                  stroke="currentColor"
                  strokeWidth="1.6"
                  strokeLinecap="round"
                  strokeLinejoin="round"
                />
              </svg>
            </a>
          </div>

          <StoreButtons className="mt-4" />

          <ul className="text-ink-soft mt-10 flex flex-wrap gap-x-6 gap-y-3 text-sm font-medium">
            {factKeys.map((key) => (
              <li key={key} className="flex items-center gap-2">
                <svg viewBox="0 0 16 16" className="size-4 text-emerald-700" aria-hidden="true">
                  <path
                    d="M3.5 8.5l3 3 6-7"
                    fill="none"
                    stroke="currentColor"
                    strokeWidth="1.8"
                    strokeLinecap="round"
                    strokeLinejoin="round"
                  />
                </svg>
                {t(`facts.${key}`)}
              </li>
            ))}
          </ul>
        </div>

        <div className="relative mx-auto flex w-full max-w-[26rem] justify-center sm:max-w-[30rem] lg:max-w-none">
          <motion.div
            style={{ y: sideY }}
            className="absolute top-[14%] left-0 w-[46%] sm:left-[4%] lg:left-[2%] lg:w-[44%]"
          >
            <div className="animate-rise -rotate-4 [animation-delay:200ms]">
              <PhoneFrame
                src={screenSrc(locale, "add")}
                alt={t("screenSide")}
                sizes="(min-width: 1024px) 240px, 40vw"
                priority
                className="opacity-95"
              />
            </div>
          </motion.div>

          <motion.div
            style={{ y: mainY }}
            className="relative ml-[28%] w-[60%] sm:ml-[26%] lg:ml-[30%] lg:w-[56%]"
          >
            <div className="animate-rise [animation-delay:100ms]">
              <PhoneFrame
                src={screenSrc(locale, "home")}
                alt={t("screenMain")}
                priority
                sizes="(min-width: 1024px) 320px, 60vw"
              />
            </div>
          </motion.div>
        </div>
      </div>
    </section>
  );
}
