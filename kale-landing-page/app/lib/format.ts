// A non-breaking space keeps the amount and "FCFA" on one line.
const NBSP = String.fromCharCode(0xa0);

/** Formats a whole-franc XOF amount the way the app does: "3 500 FCFA" in French, "FCFA 3,500" in English. */
export function formatFcfa(amount: number, locale: string, signed = false) {
  const sign = signed ? (amount < 0 ? "−" : "+") : "";
  const digits = new Intl.NumberFormat(locale === "fr" ? "fr-FR" : "en-US").format(
    Math.abs(amount)
  );
  return locale === "fr" ? `${sign}${digits}${NBSP}FCFA` : `${sign}FCFA${NBSP}${digits}`;
}
