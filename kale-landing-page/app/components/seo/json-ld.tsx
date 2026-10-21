import { getTranslations } from "next-intl/server";
import { siteConfig } from "@/app/lib/constants";

interface JsonLdProps {
  locale: string;
}

export async function JsonLd({ locale }: JsonLdProps) {
  const t = await getTranslations({ locale, namespace: "metadata" });

  const structuredData = [
    {
      "@context": "https://schema.org",
      "@type": "MobileApplication",
      name: siteConfig.name,
      url: `${siteConfig.url}/${locale}`,
      description: t("description"),
      applicationCategory: "FinanceApplication",
      operatingSystem: "Android, iOS",
      inLanguage: ["fr", "en"],
      offers: { "@type": "Offer", price: "0", priceCurrency: "XOF" },
      ...(siteConfig.downloads.apk ? { downloadUrl: siteConfig.downloads.apk } : {}),
    },
    {
      "@context": "https://schema.org",
      "@type": "WebSite",
      url: siteConfig.url,
      name: siteConfig.name,
      description: t("description"),
      inLanguage: locale,
    },
  ];

  return (
    <script
      type="application/ld+json"
      dangerouslySetInnerHTML={{ __html: JSON.stringify(structuredData).replace(/</g, "\\u003c") }}
    />
  );
}
