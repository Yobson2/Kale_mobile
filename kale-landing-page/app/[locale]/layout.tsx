import type { Viewport } from "next";
import { Inter, Space_Grotesk } from "next/font/google";
import { NextIntlClientProvider, hasLocale } from "next-intl";
import { setRequestLocale, getTranslations } from "next-intl/server";
import { notFound } from "next/navigation";
import { routing } from "@/app/i18n/routing";
import { Navbar } from "@/app/components/layout/navbar";
import { Footer } from "@/app/components/layout/footer";
import { MotionProvider } from "@/app/components/motion/motion-provider";
import { JsonLd } from "@/app/components/seo/json-ld";
import { constructMetadata } from "@/app/lib/metadata";
import { siteConfig } from "@/app/lib/constants";

// Inter is the app's UI face; Space Grotesk is the wordmark's face in the Kalé logo.
const inter = Inter({
  subsets: ["latin"],
  variable: "--font-inter",
  display: "swap",
});

const spaceGrotesk = Space_Grotesk({
  subsets: ["latin"],
  variable: "--font-space-grotesk",
  weight: ["500", "600", "700"],
  display: "swap",
});

export const viewport: Viewport = {
  themeColor: siteConfig.themeColor,
  width: "device-width",
  initialScale: 1,
};

type Props = {
  children: React.ReactNode;
  params: Promise<{ locale: string }>;
};

export function generateStaticParams() {
  return routing.locales.map((locale) => ({ locale }));
}

export async function generateMetadata({ params }: { params: Promise<{ locale: string }> }) {
  const { locale } = await params;
  const t = await getTranslations({ locale, namespace: "metadata" });

  return constructMetadata({
    title: { default: t("title"), template: `%s · ${t("shortTitle")}` },
    description: t("description"),
    openGraph: {
      locale: t("ogLocale"),
    },
    alternates: {
      canonical: `${siteConfig.url}/${locale}`,
      languages: Object.fromEntries(routing.locales.map((l) => [l, `${siteConfig.url}/${l}`])),
    },
  });
}

export default async function LocaleLayout({ children, params }: Props) {
  const { locale } = await params;

  if (!hasLocale(routing.locales, locale)) {
    notFound();
  }

  setRequestLocale(locale);

  const t = await getTranslations({ locale, namespace: "nav" });

  return (
    <html lang={locale} className={`${inter.variable} ${spaceGrotesk.variable}`}>
      {/* Browser extensions add attributes to <body> before hydration. */}
      <body suppressHydrationWarning>
        <NextIntlClientProvider>
          <MotionProvider>
            <JsonLd locale={locale} />
            <a
              href="#main"
              className="sr-only focus:not-sr-only focus:fixed focus:top-4 focus:left-4 focus:z-[200] focus:rounded-lg focus:bg-emerald-700 focus:px-4 focus:py-2 focus:text-white"
            >
              {t("skipToContent")}
            </a>
            <Navbar />
            {children}
            <Footer />
          </MotionProvider>
        </NextIntlClientProvider>
      </body>
    </html>
  );
}
