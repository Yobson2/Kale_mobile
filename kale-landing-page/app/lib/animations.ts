import type { Transition } from "framer-motion";

export const easeOutSoft = [0.22, 1, 0.36, 1] as const;

export const revealTransition: Transition = { duration: 0.7, ease: easeOutSoft };

/**
 * Fade and rise once when scrolled into view. With reduced motion,
 * MotionProvider drops the transform and keeps only the fade.
 */
export function reveal(delay = 0, y = 24) {
  return {
    initial: { opacity: 0, y },
    whileInView: { opacity: 1, y: 0 },
    viewport: { once: true, margin: "0px 0px -10% 0px" } as const,
    transition: { ...revealTransition, delay },
  };
}
