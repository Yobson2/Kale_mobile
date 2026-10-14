# French review checklist

Before any public beta, a native French speaker from the target market (French-speaking West Africa) reviews every
string in `lib/l10n/app_fr.arb` (decision Q14). The accents were restored mechanically in #48. This review is about
whether the French sounds right to a user, not only whether it is spelled correctly.

## How to review

Read `app_fr.arb` top to bottom, or use the app with the phone in French. For each string, check:

- **Spelling and accents:** é, è, ê, à, ç, ô, î, ù, and capital accents (É, À).
- **Typography:** a no-break space before `:`, `?`, `!` and `%` (`Total : 10 000 FCFA`, `80 %`), and French quotes
  (« … ») where quotes appear.
- **Tone:** consistent use of *vous*, short and friendly, no literal translations from English
  (e.g. "Budgétez Plus Malin" in title case reads like English).
- **Vocabulary for the market:** words people actually use for money in Senegal, Côte d'Ivoire, Mali, etc.
  (e.g. "Mobile Money", "tontine", "cotisation", "crédit" for airtime); FCFA amounts without decimals.
- **Gender and agreement:** past participles (`épargné`, `dépensé`) and plurals in `{count, plural, …}` messages.
- **Legal text** (`legalTos*`, `legalPrivacy*`): also reviewed against what the app does (backups, anonymous data,
  deletion), which is a separate release-bar item.

## Recording changes

Edit `app_fr.arb` directly, run `make l10n`, and open one PR per review pass. If an English string is wrong too, fix
`app_en.arb` in the same PR. Note the reviewer and date at the bottom of this file.

## Reviews

| Date | Reviewer | Scope |
|---|---|---|
| — | — | Pending: required before beta |
