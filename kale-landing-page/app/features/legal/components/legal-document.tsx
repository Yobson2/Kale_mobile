import { getTranslations } from "next-intl/server";
import { Link } from "@/app/i18n/navigation";

type DocumentKey = "privacy" | "terms";

/** Renders one of the app's legal documents (text ported from Kale/lib/l10n) as a readable page. */
export async function LegalDocument({ doc }: { doc: DocumentKey }) {
  const t = await getTranslations("legal");
  const tFooter = await getTranslations("footer");
  const sections = Object.keys(t.raw(`${doc}.sections`) as Record<string, unknown>);
  const other: DocumentKey = doc === "privacy" ? "terms" : "privacy";

  return (
    <main id="main" className="pt-10 pb-24 md:pt-16 md:pb-32">
      <div className="container-page">
        <Link
          href="/"
          className="text-ink-muted hover:text-ink inline-flex min-h-11 items-center gap-2 rounded-lg text-sm font-medium transition"
        >
          <svg viewBox="0 0 16 16" className="size-4" aria-hidden="true">
            <path
              d="M13 8H4m3.5-3.5L4 8l3.5 3.5"
              fill="none"
              stroke="currentColor"
              strokeWidth="1.6"
              strokeLinecap="round"
              strokeLinejoin="round"
            />
          </svg>
          {t("back")}
        </Link>

        <header className="mt-8 max-w-3xl">
          <h1 className="text-4xl leading-[1.05] font-bold tracking-[-0.035em] md:text-6xl">
            {t(`${doc}.title`)}
          </h1>
          <p className="text-ink-muted mt-5 text-sm">{t("lastUpdated")}</p>
        </header>

        <div className="mt-14 grid grid-cols-1 gap-12 lg:grid-cols-[14rem_minmax(0,42rem)] lg:gap-20">
          <nav aria-label={t("contents")} className="lg:sticky lg:top-28 lg:self-start">
            <p className="eyebrow text-ink-muted">{t("contents")}</p>
            <ol className="border-surface-high mt-4 space-y-1 border-l-2">
              {sections.map((id) => (
                <li key={id}>
                  <a
                    href={`#${id}`}
                    className="text-ink-soft hover:text-ink -ml-0.5 block border-l-2 border-transparent py-1.5 pl-4 text-sm transition hover:border-emerald-700"
                  >
                    {t(`${doc}.sections.${id}.heading`)}
                  </a>
                </li>
              ))}
            </ol>
          </nav>

          <article className="space-y-12">
            {sections.map((id) => (
              <section key={id} id={id} aria-labelledby={`${id}-title`}>
                <h2 id={`${id}-title`} className="text-2xl font-semibold tracking-tight">
                  {t(`${doc}.sections.${id}.heading`)}
                </h2>
                <p className="text-ink-soft mt-4 text-base leading-[1.75] whitespace-pre-line">
                  {t(`${doc}.sections.${id}.body`)}
                </p>
              </section>
            ))}

            <div className="bg-surface-low rounded-2xl p-6">
              <p className="text-ink-soft text-sm">{t("contactFooter")}</p>
              <p className="mt-4 text-sm">
                <span className="text-ink-muted">{t("otherDocument")} </span>
                <Link
                  href={`/${other}`}
                  className="font-semibold text-emerald-700 underline-offset-4 hover:underline"
                >
                  {tFooter(other)}
                </Link>
              </p>
            </div>
          </article>
        </div>
      </div>
    </main>
  );
}
