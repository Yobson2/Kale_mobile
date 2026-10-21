import Link from "next/link";
import "./globals.css";

// Fallback for requests that never reach a locale (the proxy normally adds one).
export default function GlobalNotFound() {
  return (
    <html lang="fr">
      <body className="flex min-h-screen items-center justify-center p-6">
        <Link href="/" className="font-semibold text-emerald-700 underline underline-offset-4">
          Kalé
        </Link>
      </body>
    </html>
  );
}
