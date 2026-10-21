import "./globals.css";

// <html> and <body> live in app/[locale]/layout.tsx so the lang attribute comes
// from the route param, which keeps every page statically renderable.
export default function RootLayout({ children }: { children: React.ReactNode }) {
  return children;
}
