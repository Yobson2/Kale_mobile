import { cn } from "@/app/lib/utils";

/** The geometric K ("Le Fil"): an emerald stem crossed by a gold thread. Paths from Kale/assets/images/logo-mark.svg. */
export function LogoMark({ className, mono = false }: { className?: string; mono?: boolean }) {
  return (
    <svg viewBox="0 0 100 100" className={className} aria-hidden="true" focusable="false">
      <path
        d="M32 12H46V18.41L32 26.23Z M32 51.43L46 43.61V88H32Z"
        fill={mono ? "currentColor" : "var(--color-emerald-700)"}
      />
      <path
        d="M65.67 12H94.47L26.35 50L28 50.92V66.96L8.59 56.11A7 7 0 0 1 8.59 43.89Z M50 63.21L94.47 88H65.67L50 79.25Z"
        fill={mono ? "currentColor" : "var(--color-gold-500)"}
      />
    </svg>
  );
}

export function Logo({ className, inverted = false }: { className?: string; inverted?: boolean }) {
  return (
    <span className={cn("inline-flex items-center gap-1.5", className)}>
      <LogoMark className="size-8" />
      <span
        className={cn(
          "font-display text-[1.375rem] leading-none font-bold tracking-[-0.035em]",
          inverted ? "text-white" : "text-ink"
        )}
      >
        Kalé
      </span>
    </span>
  );
}
