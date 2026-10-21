"use client";

import { motion } from "framer-motion";
import { useLocale, useTranslations } from "next-intl";
import { LogoMark } from "@/app/components/brand/logo";
import { GetAppCta, StoreButtons } from "@/app/components/ui/get-app-cta";
import { PhoneFrame } from "@/app/components/ui/phone-frame";
import { reveal } from "@/app/lib/animations";
import { siteConfig } from "@/app/lib/constants";
import { screenSrc } from "@/app/lib/screens";

export function FinalCtaSection() {
  const t = useTranslations("final");
  const tHero = useTranslations("hero");
  const locale = useLocale();

  return (
    <section aria-labelledby="final-title" className="pb-24 md:pb-32">
      <div className="container-page">
        <motion.div
          {...reveal()}
          className="on-night relative grid grid-cols-1 overflow-hidden rounded-[2rem] bg-linear-to-br from-emerald-800 to-emerald-950 text-white lg:grid-cols-[1.2fr_1fr]"
        >
          <LogoMark
            mono
            className="pointer-events-none absolute -top-16 -left-20 size-80 text-white/[0.05]"
          />

          <div className="relative p-8 sm:p-12 lg:p-16">
            <h2
              id="final-title"
              className="max-w-lg text-4xl leading-[1.05] font-bold tracking-[-0.035em] md:text-5xl"
            >
              {t("title")}
            </h2>
            <p className="mt-5 max-w-md text-lg leading-relaxed text-white/75">{t("body")}</p>
            <GetAppCta variant="light" className="mt-9" />
            <StoreButtons inverted className="mt-4" />
            <p className="mt-6 text-sm text-white/65">
              {t("questions")}{" "}
              <a
                href={`mailto:${siteConfig.email}`}
                className="font-medium text-white underline decoration-white/30 underline-offset-4 hover:decoration-white"
              >
                {siteConfig.email}
              </a>
            </p>
          </div>

          {/* A real screen rising out of the card's bottom edge. */}
          <div className="relative hidden h-full min-h-80 lg:block" aria-hidden="true">
            <div className="absolute top-14 left-1/2 w-64 -translate-x-1/2">
              <PhoneFrame src={screenSrc(locale, "home")} alt={tHero("screenMain")} sizes="256px" />
            </div>
          </div>
        </motion.div>
      </div>
    </section>
  );
}
