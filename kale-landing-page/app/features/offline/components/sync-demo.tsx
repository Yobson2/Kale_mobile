"use client";

import { useEffect, useRef, useState } from "react";
import { AnimatePresence, motion, useInView } from "framer-motion";
import { useLocale, useTranslations } from "next-intl";
import { formatFcfa } from "@/app/lib/format";
import { cn } from "@/app/lib/utils";

const phases = ["offline", "syncing", "synced"] as const;
const PHASE_MS = 1600;

const entries = [
  { key: "entry1", amount: -4500 },
  { key: "entry2", amount: -500 },
  { key: "entry3", amount: -1000 },
] as const;

/**
 * Illustrates offline-first saving: entries are kept on the phone, then backed
 * up when the network returns. Plays once (under 5s) when scrolled into view.
 */
export function SyncDemo() {
  const t = useTranslations("offline.demo");
  const locale = useLocale();
  const ref = useRef<HTMLDivElement>(null);
  const inView = useInView(ref, { once: true, margin: "0px 0px -25% 0px" });
  const [phase, setPhase] = useState(0);

  useEffect(() => {
    if (!inView) return;
    const timers = [1, 2].map((p) => setTimeout(() => setPhase(p), p * PHASE_MS));
    return () => timers.forEach(clearTimeout);
  }, [inView]);

  const current = phases[phase] ?? "synced";

  return (
    <div ref={ref} role="img" aria-label={t("label")} className="relative mx-auto w-full max-w-sm">
      <div
        className="bg-night-soft rounded-[2rem] p-5 ring-1 ring-white/10 sm:p-6"
        aria-hidden="true"
      >
        <div
          className={cn(
            "flex items-center gap-3 rounded-2xl px-4 py-3 transition-colors duration-500",
            current === "offline" && "bg-white/[0.06]",
            current === "syncing" && "bg-gold-500/15",
            current === "synced" && "bg-emerald-500/15"
          )}
        >
          <StatusIcon phase={current} />
          <div className="min-w-0">
            <AnimatePresence mode="wait" initial={false}>
              <motion.div
                key={current}
                initial={{ opacity: 0, y: 6 }}
                animate={{ opacity: 1, y: 0 }}
                exit={{ opacity: 0, y: -6 }}
                transition={{ duration: 0.25 }}
              >
                <p className="text-sm font-semibold text-white">{t(current)}</p>
                <p className="truncate text-xs text-white/60">{t(`${current}Detail`)}</p>
              </motion.div>
            </AnimatePresence>
          </div>
        </div>

        <ul className="mt-4 space-y-2">
          {entries.map((e, i) => (
            <li
              key={e.key}
              className="flex items-center gap-3 rounded-xl bg-white/[0.04] px-4 py-3"
            >
              <span className="min-w-0 flex-1 truncate text-sm text-white/90">{t(e.key)}</span>
              <span className="tabular text-sm font-medium text-white/80">
                {formatFcfa(e.amount, locale, true)}
              </span>
              <span className="flex size-5 items-center justify-center">
                {current === "synced" ? (
                  <motion.svg
                    viewBox="0 0 16 16"
                    className="size-4 text-emerald-300"
                    initial={{ scale: 0.6, opacity: 0 }}
                    animate={{ scale: 1, opacity: 1 }}
                    transition={{ delay: i * 0.08 }}
                  >
                    <path
                      d="M3.5 8.5l3 3 6-7"
                      fill="none"
                      stroke="currentColor"
                      strokeWidth="2"
                      strokeLinecap="round"
                      strokeLinejoin="round"
                    />
                  </motion.svg>
                ) : (
                  <span
                    className={cn(
                      "size-2 rounded-full",
                      current === "syncing" ? "bg-gold-500 animate-pulse" : "bg-white/30"
                    )}
                  />
                )}
              </span>
            </li>
          ))}
        </ul>
      </div>
    </div>
  );
}

function StatusIcon({ phase }: { phase: (typeof phases)[number] }) {
  const common = "size-5 shrink-0";
  if (phase === "offline") {
    return (
      <svg viewBox="0 0 24 24" className={cn(common, "text-white/70")}>
        <path
          d="M3 3l18 18M8.5 8.6A6 6 0 0 0 6 13.5 4.5 4.5 0 0 0 7 19h10m3.2-2.1A4 4 0 0 0 17 11a6 6 0 0 0-6.3-5.5"
          fill="none"
          stroke="currentColor"
          strokeWidth="1.7"
          strokeLinecap="round"
        />
      </svg>
    );
  }
  if (phase === "syncing") {
    return (
      <svg
        viewBox="0 0 24 24"
        className={cn(common, "text-gold-500 animate-spin motion-reduce:animate-none")}
      >
        <path
          d="M20 12a8 8 0 1 1-2.3-5.7M20 4v4h-4"
          fill="none"
          stroke="currentColor"
          strokeWidth="1.8"
          strokeLinecap="round"
          strokeLinejoin="round"
        />
      </svg>
    );
  }
  return (
    <svg viewBox="0 0 24 24" className={cn(common, "text-emerald-300")}>
      <path
        d="M7 19a4.5 4.5 0 0 1-1-8.9A6 6 0 0 1 17.6 9 4 4 0 0 1 17 19zM9 13.5l2 2 4-4"
        fill="none"
        stroke="currentColor"
        strokeWidth="1.7"
        strokeLinecap="round"
        strokeLinejoin="round"
      />
    </svg>
  );
}
