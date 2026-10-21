"use client";

import { useEffect, useRef, useState } from "react";
import Image from "next/image";
import { motion, useScroll, useSpring } from "framer-motion";
import { useLocale, useTranslations } from "next-intl";
import { PhoneFrame } from "@/app/components/ui/phone-frame";
import { reveal } from "@/app/lib/animations";
import { SCREEN_HEIGHT, SCREEN_WIDTH, screenSrc, type ScreenName } from "@/app/lib/screens";
import { cn } from "@/app/lib/utils";

const steps: { key: string; screen: ScreenName }[] = [
  { key: "log", screen: "add" },
  { key: "budget", screen: "budget" },
  { key: "save", screen: "savings" },
  { key: "insights", screen: "insights" },
];

export function TourSection() {
  const t = useTranslations("tour");
  const locale = useLocale();
  const [active, setActive] = useState(0);
  const stepsRef = useRef<HTMLOListElement>(null);

  // The step crossing the middle of the viewport drives the pinned phone.
  useEffect(() => {
    const items = stepsRef.current?.querySelectorAll<HTMLElement>("[data-step]");
    if (!items) return;
    const observer = new IntersectionObserver(
      (records) => {
        for (const record of records) {
          if (record.isIntersecting) setActive(Number(record.target.getAttribute("data-step")));
        }
      },
      { rootMargin: "-45% 0px -45% 0px" }
    );
    items.forEach((item) => observer.observe(item));
    return () => observer.disconnect();
  }, []);

  const { scrollYProgress } = useScroll({ target: stepsRef, offset: ["start 55%", "end 55%"] });
  const thread = useSpring(scrollYProgress, { stiffness: 120, damping: 30, mass: 0.4 });

  return (
    <section id="product" aria-labelledby="tour-title" className="py-24 md:py-32">
      <div className="container-page">
        <div className="max-w-2xl">
          <motion.p {...reveal()} className="eyebrow text-emerald-700">
            {t("eyebrow")}
          </motion.p>
          <motion.h2
            id="tour-title"
            {...reveal(0.05)}
            className="mt-4 text-4xl leading-[1.05] font-bold tracking-[-0.035em] md:text-6xl"
          >
            {t("title")}
          </motion.h2>
          <motion.p
            {...reveal(0.1)}
            className="text-ink-soft mt-6 max-w-xl text-lg leading-relaxed"
          >
            {t("intro")}
          </motion.p>
        </div>

        <div className="mt-16 lg:mt-8 lg:grid lg:grid-cols-[1fr_auto] lg:gap-20">
          <div className="relative">
            {/* The thread: a gold line that fills as the story advances. */}
            <div
              className="bg-surface-high absolute top-0 bottom-0 left-[0.6875rem] hidden w-0.5 rounded-full lg:block"
              aria-hidden="true"
            >
              <motion.div
                className="bg-gold-500 h-full w-full origin-top rounded-full"
                style={{ scaleY: thread }}
              />
            </div>

            <ol ref={stepsRef} className="relative space-y-24 lg:space-y-0">
              {steps.map((step, i) => (
                <li
                  key={step.key}
                  data-step={i}
                  className="lg:flex lg:min-h-[78vh] lg:items-center lg:pl-16"
                  aria-current={active === i ? "step" : undefined}
                >
                  <div
                    className={cn(
                      "relative max-w-lg transition-opacity duration-500",
                      active === i ? "lg:opacity-100" : "lg:opacity-35"
                    )}
                  >
                    <span
                      className={cn(
                        "ring-paper absolute top-1 -left-16 hidden size-6 items-center justify-center rounded-full ring-4 transition-colors duration-500 lg:flex",
                        active >= i ? "bg-gold-500" : "bg-surface-high"
                      )}
                      aria-hidden="true"
                    >
                      <span className="bg-paper size-2 rounded-full" />
                    </span>

                    <p className="flex items-center gap-3 text-sm font-semibold">
                      <span className="tabular text-gold-700">0{i + 1}</span>
                      <span className="text-ink-muted">{t(`steps.${step.key}.tag`)}</span>
                      <span className="sr-only">
                        {t("stepLabel", { n: i + 1, total: steps.length })}
                      </span>
                    </p>
                    <h3 className="mt-3 text-3xl leading-tight font-bold tracking-[-0.03em] md:text-4xl">
                      {t(`steps.${step.key}.title`)}
                    </h3>
                    <p className="text-ink-soft mt-4 text-lg leading-relaxed">
                      {t(`steps.${step.key}.body`)}
                    </p>
                    <ul className="mt-6 space-y-2.5">
                      {(["point1", "point2"] as const).map((p) => (
                        <li key={p} className="text-ink flex items-start gap-3 text-[0.9375rem]">
                          <span
                            className="mt-2 size-1.5 shrink-0 rounded-full bg-emerald-700"
                            aria-hidden="true"
                          />
                          {t(`steps.${step.key}.${p}`)}
                        </li>
                      ))}
                    </ul>

                    {/* Mobile and tablet: each step carries its own screen. */}
                    <div className="mt-10 lg:hidden">
                      <PhoneFrame
                        src={screenSrc(locale, step.screen)}
                        alt={t(`steps.${step.key}.alt`)}
                        className="mx-auto w-[min(72vw,19rem)]"
                        sizes="72vw"
                      />
                    </div>
                  </div>
                </li>
              ))}
            </ol>
          </div>

          {/* Desktop: one pinned phone whose screen follows the active step. */}
          <div className="hidden lg:block">
            {/* Sized from the viewport height so the whole screen stays visible on short laptop displays. */}
            <div className="sticky top-24 w-[min(22rem,calc((100svh-9.5rem)*0.45))]">
              <div className="bg-ink shadow-device relative rounded-[2.4rem] p-[0.55rem] ring-1 ring-white/10">
                <div
                  className="bg-paper relative overflow-hidden rounded-[1.9rem]"
                  style={{ aspectRatio: `${SCREEN_WIDTH} / ${SCREEN_HEIGHT}` }}
                >
                  {steps.map((step, i) => (
                    <Image
                      key={step.key}
                      src={screenSrc(locale, step.screen)}
                      alt={active === i ? t(`steps.${step.key}.alt`) : ""}
                      aria-hidden={active !== i}
                      fill
                      sizes="384px"
                      className={cn(
                        "object-cover object-top transition-[opacity,transform] duration-700 ease-out motion-reduce:transition-none",
                        active === i ? "scale-100 opacity-100" : "scale-[1.02] opacity-0"
                      )}
                    />
                  ))}
                </div>
              </div>
              <ol className="mt-4 flex justify-center gap-2" aria-hidden="true">
                {steps.map((step, i) => (
                  <li
                    key={step.key}
                    className={cn(
                      "h-1.5 rounded-full transition-all duration-500",
                      active === i ? "w-8 bg-emerald-700" : "bg-surface-high w-1.5"
                    )}
                  />
                ))}
              </ol>
            </div>
          </div>
        </div>
      </div>
    </section>
  );
}
