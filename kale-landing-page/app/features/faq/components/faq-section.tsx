import { getTranslations } from "next-intl/server";

const faqKeys = [
  "free",
  "offline",
  "account",
  "mobileMoney",
  "currency",
  "export",
  "installApk",
  "availability",
] as const;

export async function FaqSection() {
  const t = await getTranslations("faq");

  const structuredData = {
    "@context": "https://schema.org",
    "@type": "FAQPage",
    mainEntity: faqKeys.map((key) => ({
      "@type": "Question",
      name: t(`items.${key}.question`),
      acceptedAnswer: { "@type": "Answer", text: t(`items.${key}.answer`) },
    })),
  };

  return (
    <section id="faq" aria-labelledby="faq-title" className="py-24 md:py-32">
      <script
        type="application/ld+json"
        dangerouslySetInnerHTML={{
          __html: JSON.stringify(structuredData).replace(/</g, "\\u003c"),
        }}
      />

      <div className="container-page grid grid-cols-1 gap-12 lg:grid-cols-[1fr_1.6fr] lg:gap-20">
        <div>
          <p className="eyebrow text-emerald-700">{t("eyebrow")}</p>
          <h2
            id="faq-title"
            className="mt-4 text-4xl leading-[1.05] font-bold tracking-[-0.035em] md:text-5xl"
          >
            {t("title")}
          </h2>
        </div>

        <div className="space-y-2">
          {faqKeys.map((key) => (
            <details
              key={key}
              className="group bg-surface-low open:bg-surface-lowest open:shadow-ghost rounded-2xl transition-colors"
            >
              <summary className="font-display text-ink flex min-h-16 cursor-pointer list-none items-center justify-between gap-6 rounded-2xl px-5 py-4 text-left text-lg font-semibold tracking-tight md:px-6 [&::-webkit-details-marker]:hidden">
                {t(`items.${key}.question`)}
                <span className="bg-surface-high text-ink flex size-8 shrink-0 items-center justify-center rounded-full transition-transform duration-300 group-open:rotate-45 group-open:bg-emerald-700 group-open:text-white motion-reduce:transition-none">
                  <svg viewBox="0 0 16 16" className="size-3.5" aria-hidden="true">
                    <path
                      d="M8 3v10M3 8h10"
                      stroke="currentColor"
                      strokeWidth="1.8"
                      strokeLinecap="round"
                    />
                  </svg>
                </span>
              </summary>
              <p className="text-ink-soft max-w-2xl px-5 pb-6 text-[0.9375rem] leading-relaxed md:px-6">
                {t(`items.${key}.answer`)}
              </p>
            </details>
          ))}
        </div>
      </div>
    </section>
  );
}
