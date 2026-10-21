import type { Metadata } from "next";
import { siteConfig } from "./constants";

// Open Graph images come from app/[locale]/opengraph-image.tsx.
export function constructMetadata(overrides?: Partial<Metadata>): Metadata {
  const description =
    typeof overrides?.description === "string" ? overrides.description : undefined;

  return {
    metadataBase: new URL(siteConfig.url),
    openGraph: {
      type: "website",
      siteName: siteConfig.name,
      description,
      ...overrides?.openGraph,
    },
    twitter: {
      card: "summary_large_image",
      description,
      ...overrides?.twitter,
    },
    appleWebApp: {
      title: siteConfig.name,
      capable: true,
      statusBarStyle: "default",
    },
    ...overrides,
  };
}
