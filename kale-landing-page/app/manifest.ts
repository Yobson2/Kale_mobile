import type { MetadataRoute } from "next";
import { siteConfig } from "@/app/lib/constants";

export default function manifest(): MetadataRoute.Manifest {
  return {
    name: siteConfig.name,
    short_name: siteConfig.name,
    start_url: "/",
    display: "standalone",
    background_color: "#f7f9fb",
    theme_color: siteConfig.themeColor,
    icons: [
      { src: "/assets/icons/Icon-192.png", sizes: "192x192", type: "image/png" },
      { src: "/assets/icons/Icon-512.png", sizes: "512x512", type: "image/png" },
      {
        src: "/assets/icons/Icon-maskable-192.png",
        sizes: "192x192",
        type: "image/png",
        purpose: "maskable",
      },
      {
        src: "/assets/icons/Icon-maskable-512.png",
        sizes: "512x512",
        type: "image/png",
        purpose: "maskable",
      },
    ],
  };
}
