"use client";

import { useEffect } from "react";
import { useTranslations } from "next-intl";
import { buttonClasses } from "@/app/components/ui/button";

interface ErrorPageProps {
  error: Error & { digest?: string };
  reset: () => void;
}

export default function ErrorPage({ error, reset }: ErrorPageProps) {
  const t = useTranslations("errors");

  useEffect(() => {
    console.error("Application error:", error);
  }, [error]);

  return (
    <main
      id="main"
      className="container-page flex min-h-[70vh] flex-col items-start justify-center py-24"
    >
      <h1 className="text-4xl font-bold tracking-[-0.035em] md:text-5xl">{t("genericTitle")}</h1>
      <p className="text-ink-soft mt-4 max-w-md text-lg">{t("genericDescription")}</p>
      <button
        type="button"
        onClick={reset}
        className={buttonClasses({ size: "lg", className: "mt-10" })}
      >
        {t("genericCta")}
      </button>
    </main>
  );
}
