import { setRequestLocale } from "next-intl/server";
import { HeroSection } from "@/app/features/hero/components/hero-section";
import { ProblemSection } from "@/app/features/problem/components/problem-section";
import { TourSection } from "@/app/features/tour/components/tour-section";
import { OfflineSection } from "@/app/features/offline/components/offline-section";
import { NextSection } from "@/app/features/next/components/next-section";
import { FaqSection } from "@/app/features/faq/components/faq-section";
import { FinalCtaSection } from "@/app/features/final-cta/components/final-cta-section";

type Props = {
  params: Promise<{ locale: string }>;
};

// What is it → why it matters → how it works → why trust it → what's next → questions → act.
export default async function HomePage({ params }: Props) {
  const { locale } = await params;
  setRequestLocale(locale);

  return (
    <main id="main">
      <HeroSection />
      <ProblemSection />
      <TourSection />
      <OfflineSection />
      <NextSection />
      <FaqSection />
      <FinalCtaSection />
    </main>
  );
}
