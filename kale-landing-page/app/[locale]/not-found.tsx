"use client";

import { useTranslations } from "next-intl";
import { Link } from "@/app/i18n/navigation";
import { LogoMark } from "@/app/components/brand/logo";
import { buttonClasses } from "@/app/components/ui/button";

export default function NotFound() {
  const t = useTranslations("errors");

  return (
    <main
      id="main"
      className="container-page flex min-h-[70vh] flex-col items-start justify-center py-24"
    >
      <LogoMark className="size-14" />
      <p className="eyebrow mt-8 text-emerald-700">{t("notFoundCode")}</p>
      <h1 className="mt-3 text-4xl font-bold tracking-[-0.035em] md:text-6xl">
        {t("notFoundTitle")}
      </h1>
      <p className="text-ink-soft mt-4 max-w-md text-lg">{t("notFoundDescription")}</p>
      <Link href="/" className={buttonClasses({ size: "lg", className: "mt-10" })}>
        {t("notFoundCta")}
      </Link>
    </main>
  );
}
