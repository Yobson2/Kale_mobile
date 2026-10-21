"use client";

import { motion } from "framer-motion";
import { useLocale, useTranslations } from "next-intl";
import { LogoMark } from "@/app/components/brand/logo";
import { easeOutSoft, reveal } from "@/app/lib/animations";
import { formatFcfa } from "@/app/lib/format";
import { cn } from "@/app/lib/utils";

const sources = [
  { key: "cash", thread: "var(--color-emerald-700)", x: 50 },
  { key: "mobileMoney", thread: "var(--color-gold-500)", x: 200 },
  { key: "bank", thread: "var(--color-emerald-500)", x: 350 },
] as const;

// Illustrative entries, using the app's own category names.
const entries = [
  { key: "food", source: "cash", amount: -3500 },
  { key: "airtime", source: "mobileMoney", amount: -1000 },
  { key: "salary", source: "bank", amount: 250000 },
] as const;

function SourceIcon({ name }: { name: (typeof sources)[number]["key"] }) {
  const paths = {
    cash: "M3 7h18v10H3zM12 12m-2.5 0a2.5 2.5 0 1 0 5 0a2.5 2.5 0 1 0 -5 0M6 10v4M18 10v4",
    mobileMoney: "M8 3h8a1 1 0 0 1 1 1v16a1 1 0 0 1-1 1H8a1 1 0 0 1-1-1V4a1 1 0 0 1 1-1zM11 18h2",
    bank: "M4 10l8-5 8 5M5 10v8M9.5 10v8M14.5 10v8M19 10v8M3 20h18",
  };
  return (
    <svg viewBox="0 0 24 24" className="size-5" aria-hidden="true">
      <path
        d={paths[name]}
        fill="none"
        stroke="currentColor"
        strokeWidth="1.6"
        strokeLinecap="round"
        strokeLinejoin="round"
      />
    </svg>
  );
}

export function ProblemSection() {
  const t = useTranslations("problem");
  const locale = useLocale();

  return (
    <section id="why" aria-labelledby="problem-title" className="bg-surface-low py-24 md:py-32">
      <div className="container-page grid grid-cols-1 items-center gap-14 lg:grid-cols-2 lg:gap-20">
        <div className="max-w-lg">
          <motion.p {...reveal()} className="eyebrow text-emerald-700">
            {t("eyebrow")}
          </motion.p>
          <motion.h2
            id="problem-title"
            {...reveal(0.05)}
            className="mt-4 text-4xl leading-[1.05] font-bold tracking-[-0.035em] md:text-5xl"
          >
            {t("title")}
          </motion.h2>
          <motion.p {...reveal(0.1)} className="text-ink-soft mt-6 text-lg leading-relaxed">
            {t("body")}
          </motion.p>
          <motion.p
            {...reveal(0.15)}
            className="font-display mt-6 text-xl font-semibold tracking-tight text-emerald-800"
          >
            {t("answer")}
          </motion.p>
        </div>

        <figure role="img" aria-label={t("diagramLabel")} className="mx-auto w-full max-w-md">
          <ul className="grid grid-cols-3 gap-3" aria-hidden="true">
            {sources.map((s, i) => (
              <motion.li
                key={s.key}
                {...reveal(i * 0.08, 12)}
                className="bg-surface-lowest shadow-ghost flex flex-col items-center gap-2 rounded-2xl px-2 py-4 text-center"
              >
                <span className="bg-surface-low text-ink flex size-10 items-center justify-center rounded-xl">
                  <SourceIcon name={s.key} />
                </span>
                <span className="text-ink text-xs font-semibold sm:text-sm">
                  {t(`sources.${s.key}`)}
                </span>
              </motion.li>
            ))}
          </ul>

          {/* Three threads converge into one ledger. */}
          <svg
            viewBox="0 0 400 120"
            className="-my-px block h-24 w-full sm:h-28"
            preserveAspectRatio="none"
            aria-hidden="true"
          >
            {sources.map((s, i) => (
              <motion.path
                key={s.key}
                d={`M${s.x} 0 C ${s.x} 60, 200 50, 200 120`}
                fill="none"
                stroke={s.thread}
                strokeWidth="3"
                strokeLinecap="round"
                vectorEffect="non-scaling-stroke"
                initial={{ pathLength: 0 }}
                whileInView={{ pathLength: 1 }}
                viewport={{ once: true, margin: "0px 0px -15% 0px" }}
                transition={{ duration: 1.1, ease: easeOutSoft, delay: 0.25 + i * 0.12 }}
              />
            ))}
          </svg>

          <motion.div
            {...reveal(0.5, 16)}
            className="bg-surface-lowest shadow-ghost relative overflow-hidden rounded-3xl p-5 sm:p-6"
            aria-hidden="true"
          >
            <LogoMark
              mono
              className="absolute -right-6 -bottom-8 size-32 text-emerald-700/[0.05]"
            />
            <div className="flex items-center justify-between">
              <span className="eyebrow text-ink-muted">{t("ledger")}</span>
              <LogoMark className="size-5" />
            </div>
            <ul className="mt-4 space-y-2">
              {entries.map((e) => {
                const source = sources.find((s) => s.key === e.source)!;
                return (
                  <li
                    key={e.key}
                    className="bg-surface-low flex items-center gap-3 rounded-xl px-3 py-3"
                  >
                    <span
                      className="h-8 w-1 shrink-0 rounded-full"
                      style={{ background: source.thread }}
                    />
                    <span className="min-w-0 flex-1">
                      <span className="text-ink block truncate text-sm font-semibold">
                        {t(`entries.${e.key}`)}
                      </span>
                      <span className="text-ink-muted block text-xs">
                        {t(`sources.${e.source}`)}
                      </span>
                    </span>
                    <span
                      className={cn(
                        "tabular text-sm font-semibold whitespace-nowrap",
                        e.amount < 0 ? "text-expense" : "text-emerald-700"
                      )}
                    >
                      {formatFcfa(e.amount, locale, true)}
                    </span>
                  </li>
                );
              })}
            </ul>
          </motion.div>
        </figure>
      </div>
    </section>
  );
}
