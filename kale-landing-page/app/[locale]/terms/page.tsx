import { setRequestLocale, getTranslations } from "next-intl/server";
import { LegalDocument } from "@/app/features/legal/components/legal-document";
import { constructMetadata } from "@/app/lib/metadata";

type Props = {
  params: Promise<{ locale: string }>;
};

export async function generateMetadata({ params }: Props) {
  const { locale } = await params;
  const t = await getTranslations({ locale, namespace: "legal" });

  return constructMetadata({ title: t("terms.title") });
}

export default async function Page({ params }: Props) {
  const { locale } = await params;
  setRequestLocale(locale);

  return <LegalDocument doc="terms" />;
}
