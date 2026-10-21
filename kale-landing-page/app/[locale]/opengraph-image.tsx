import { ImageResponse } from "next/og";
import { getTranslations } from "next-intl/server";

export const size = { width: 1200, height: 630 };
export const contentType = "image/png";
export const alt = "Kalé";

export default async function OpengraphImage({ params }: { params: Promise<{ locale: string }> }) {
  const { locale } = await params;
  const t = await getTranslations({ locale, namespace: "hero" });
  const tCta = await getTranslations({ locale, namespace: "cta" });

  return new ImageResponse(
    <div
      style={{
        width: "100%",
        height: "100%",
        display: "flex",
        flexDirection: "column",
        justifyContent: "space-between",
        padding: 80,
        background: "#f7f9fb",
        color: "#0f172a",
        position: "relative",
      }}
    >
      <svg
        viewBox="0 0 100 100"
        width="620"
        height="620"
        style={{ position: "absolute", right: -120, top: -40, opacity: 0.08 }}
      >
        <path d="M32 12H46V18.41L32 26.23Z M32 51.43L46 43.61V88H32Z" fill="#006c49" />
        <path
          d="M65.67 12H94.47L26.35 50L28 50.92V66.96L8.59 56.11A7 7 0 0 1 8.59 43.89Z M50 63.21L94.47 88H65.67L50 79.25Z"
          fill="#e29100"
        />
      </svg>
      <div style={{ display: "flex", alignItems: "center", gap: 16 }}>
        <svg viewBox="0 0 100 100" width="72" height="72">
          <path d="M32 12H46V18.41L32 26.23Z M32 51.43L46 43.61V88H32Z" fill="#006c49" />
          <path
            d="M65.67 12H94.47L26.35 50L28 50.92V66.96L8.59 56.11A7 7 0 0 1 8.59 43.89Z M50 63.21L94.47 88H65.67L50 79.25Z"
            fill="#e29100"
          />
        </svg>
        <span style={{ fontSize: 48, fontWeight: 700, letterSpacing: -1.5 }}>Kalé</span>
      </div>
      <div style={{ display: "flex", flexDirection: "column", gap: 24, maxWidth: 900 }}>
        <span style={{ fontSize: 84, fontWeight: 700, letterSpacing: -3, lineHeight: 1.02 }}>
          {t("title")}
        </span>
        <span style={{ fontSize: 30, color: "#006c49", fontWeight: 600 }}>{tCta("status")}</span>
      </div>
    </div>,
    size
  );
}
