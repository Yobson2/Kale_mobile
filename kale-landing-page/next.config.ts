import type { NextConfig } from "next";
import createNextIntlPlugin from "next-intl/plugin";

const nextConfig: NextConfig = {
  async redirects() {
    return [
      // The template's privacy URL; kept so existing links still land.
      { source: "/:locale(fr|en)/legal", destination: "/:locale/privacy", permanent: true },
    ];
  },
};

const withNextIntl = createNextIntlPlugin("./app/i18n/request.ts");

export default withNextIntl(nextConfig);
