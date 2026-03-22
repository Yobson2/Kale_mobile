You are designing a complete, production-ready mobile application called **Kalé**. Kalé is a personal finance management app built for emerging markets, especially Sub-Saharan Africa. It helps users track income and expenses, manage budgets, set savings goals, and build healthy money habits through gamification. The app supports offline-first usage, guest mode exploration, multi-currency including CFA Franc (XOF/XAF), mobile money payment methods (M-Pesa, Orange Money, MTN MoMo, Wave), and bilingual support (English/French).

**Target Users**: Budget-conscious individuals in Africa and diaspora communities who use mobile money daily, want visibility over their finances, and respond to gamified progress tracking. Age 18-40, mobile-first, may have intermittent connectivity.

**Primary Goals**: Track every transaction effortlessly, stay within budget, grow savings, build consistent financial habits.

---

## Design System

### Brand Identity
- **App Name**: Kalé (with accent)
- **Logo**: A custom geometric "K" compass-coin mark in emerald green (light) / mint green (dark). Clean, modern fintech aesthetic with subtle African cultural warmth. No mascots. Rounded, approachable shapes. Generous white space. Data-forward but not intimidating.

### Color Palette

**Light Theme**
- Primary: #10B981 (Emerald Green)
- Primary Container: #D1FAE5
- Background: #F8FAFC
- Surface: #FFFFFF
- On Primary: #FFFFFF
- On Surface: #1E293B
- Text Primary: #0F172A
- Text Secondary: #64748B
- Text Disabled: #6B7280
- Border: #E2E8F0
- Divider: #F1F5F9
- Error: #EF4444 / Error Container: #FEE2E2
- Warning: #F59E0B
- Info: #3B82F6

**Dark Theme**
- Primary: #34D399 (Mint Green)
- Primary Container: #064E3B
- Background: #0F172A
- Surface: #1E293B
- On Primary: #064E3B
- On Surface: #F1F5F9
- Text Primary: #F8FAFC
- Text Secondary: #94A3B8
- Text Disabled: #475569
- Border: #334155
- Divider: #1E293B
- Error: #F87171 / Error Container: #7F1D1D
- Warning: #FBBF24
- Info: #60A5FA

**Semantic Finance Colors**
- Income: #22C55E (light) / #4ADE80 (dark) — Green
- Expense: #EF4444 (light) / #F87171 (dark) — Red
- Budget: #F59E0B (light) / #FBBF24 (dark) — Amber
- Savings: #3B82F6 (light) / #60A5FA (dark) — Blue

### Typography
- **Font**: Inter (Google Fonts)
- Display: 57/45/36px, weight 400
- Headline: 32/28/24px, weight 600
- Title: 22/16/14px, weight 600
- Body: 16/14/12px, weight 400
- Label: 14/12/11px, weight 500
- Letter spacing follows Material Design 3 spec

### Spacing (4px grid)
xxs: 2, xs: 4, sm: 8, md: 12, lg: 16, lgx: 20, xl: 24, xxl: 32, xxxl: 40, xxxxl: 48, jumbo: 64

### Border Radius
xs: 4, sm: 8, md: 12 (default), lg: 16, xl: 24 (sheets), full: 999 (pills/avatars)

### Shadows
- Light: Multi-layer, 4-8% alpha, 4-32px blur
- Dark: Single-layer, 20-40% alpha, 4-16px blur

### Canvas
375x812px (iPhone X). All screens responsive-ready.

---

## Component Library

### Buttons
1. **Primary**: Full-width, 52px height, emerald fill, white text, 12px radius. Loading state: white spinner replaces text.
2. **Secondary (Outlined)**: 52px height, emerald 1px border, emerald text, transparent fill.
3. **Ghost**: No border/fill, emerald text. For "Forgot Password?", "Skip", links.
4. **Icon Button**: 44x44px touch target.
5. **Quick Action**: 64px column — 48x48 circular icon container (primaryContainer bg, primary icon), 11px label below.
6. **Filled Tonal**: primaryContainer fill, onPrimaryContainer text, 32px height. For inline "Add Money" actions.

### Inputs
1. **Text Field**: White surface fill, 12px radius, 1px border (#E2E8F0), 2px emerald on focus. 16px horizontal / 14px vertical padding. Optional prefix icon.
2. **Password Field**: Text field + eye/eye-off visibility toggle.
3. **OTP Field**: 6 individual 48x48px boxes, 8px gap, monospace centered digit, auto-advance focus.
4. **Search Field**: Rounded, search icon prefix, clear button suffix.
5. **Dropdown**: Text field styling + trailing chevron_down.
6. **Checkbox**: Rounded checkbox with rich text label (for Terms links).
7. **Chip**: Pill (999px radius), 1px border. Selected: primary fill + white text. Unselected: surface fill + outline border.

### Data Display
1. **Card**: Surface bg, 0 elevation, 12px radius, 1px border. Border-only design, no Material shadow.
2. **Amount Display**: Headline text, weight 600-800. Income: green + "+" prefix. Expense: red + "-" prefix.
3. **Progress Bar**: 6-8px height, fully rounded, emerald fill on 20% alpha track. Over-budget turns red.
4. **Badge**: Small pill, primaryContainer fill, 12px radius, 11px text.
5. **Avatar**: Circular 48px. First letter fallback. primaryContainer background.
6. **List Tile**: Optional icon leading, title, subtitle, trailing widget, optional divider.
7. **Section Header**: titleMedium weight 600, optional trailing action.

### Feedback
1. **Snack Bar**: 4 variants (success/error/warning/info), icon + message + optional action.
2. **Bottom Sheet**: Top-rounded 16px, drag handle, scrollable.
3. **Dialog**: Title, message, cancel + confirm buttons. Destructive confirms in red.
4. **Guest Banner**: Material banner — cloud_off icon, message, "Sign Up" action.
5. **Toast**: Auto-dismissing, bottom-anchored.

### Loading
1. **Shimmer**: Animated placeholder blocks matching layout.
2. **Shimmer List**: Multiple shimmer rows.
3. **Circular Progress**: Small adaptive spinner.

### Layout
1. **Bottom App Bar + Center FAB**: BottomAppBar with CircularNotchedRectangle. 4 nav items + centered emerald FAB with white "+" icon.
2. **SliverAppBar**: Floating+snap. Two-line greeting (bodyMedium + titleMedium bold name). Trailing notification bell.
3. **Step Indicator**: 4-dot row, active dot: 28x8px pill, inactive: 8x8 circle.

### Animations
1. **Staggered List**: 400ms fade+slide up, 60ms stagger, capped at 8 items.
2. **Page Enter**: Fade + 4% slide up, 600ms easeOut.
3. **Splash Logo**: Pulse scale 1.0 → 1.1 → 0.85 → hold, 1800ms.
4. **Count-up Text**: 800ms easeOutCubic number animation.
5. **FAB**: mediumImpact haptic on tap.

---

## Screens — Design all in both light and dark themes

### 1. Splash
Centered logo (80x80px) with pulse animation. Below (24px gap): small circular progress spinner. Background: scaffoldBackgroundColor. Auto-redirects to onboarding, login, or dashboard.

### 2. Onboarding (4 steps)
- **Top bar**: Logo (32px) left, "Skip" ghost button right.
- **Steps 1-3**: Large illustration area (top 50%), title (headlineSmall, weight 700), description (bodyMedium, textSecondary). Centered.
  - Step 1: "Take Control of Your Money" — show miniature dashboard mockup preview
  - Step 2: "Track Every Franc" — show transaction list preview with category icons
  - Step 3: "Save Smarter" — show savings goal progress ring preview
- **Step 4: Personalization Form** (replaces illustration):
  - Currency dropdown (XOF, XAF, USD, EUR, GBP, NGN)
  - Language toggle: two ChoiceChips — "English" / "Français"
  - Goal picker: "What's your main goal?" — three ChoiceChips: "Track Spending", "Save More", "Manage Budgets"
- **Bottom**: Animated dot indicators (28x8 active pill, 8x8 inactive circles). Full-width button: "Next" (steps 1-3), "Get Started" (step 4).

### 3. Login
- **Header**: "Log In" (headlineSmall, 700) + "Welcome back to Kalé" (bodyMedium, textSecondary).
- **Form**: Email field (email icon prefix), 16px gap, password field with toggle, 8px gap, right-aligned "Forgot Password?" ghost button, 16px gap, "Log In" primary button.
- **Social**: "or" divider, "Continue with Google" + "Continue with Apple" outlined buttons with brand icons.
- **Bottom**: "Don't have an account? Register" link pair.
- **Guest Mode**: Prominent outlined button with explore icon: "Try First — No Account Needed". Caption below: "Explore with local data. Sign up anytime to sync." Add a subtle emerald gradient border and "Data stays on device" lock badge for trust.
- **Animation**: Form fades in + slides up (600ms easeOut).

### 4. Register (2 steps)
- **Step 1**: "Create Account" / "Start your financial journey". Email field. "Continue with Email" primary button. Social buttons. "Already have an account? Log In" link.
- **Step 2**: Back arrow. Read-only email chip (surfaceContainerHighest, email icon + email + "Edit" link). Name field (person icon). Password field. **Password strength indicator**: 4-segment bar (Red=Weak, Orange=Fair, Yellow=Good, Green=Strong) with label. Confirm password field. Terms checkbox with rich text links. "Create Account" button (disabled until terms checked).

### 5. Forgot Password
"Forgot Password" / "Enter your email and we'll send a reset code". Email field. "Send Reset Code" primary button. "Back to Login" ghost button.

### 6. OTP Verification
"Verify Email" / "Enter the 6-digit code sent to {email}". 6-box OTP input (48x48, 12px radius, auto-advance). "Verify" primary button. "Didn't receive code? Resend" with countdown timer.

### 7. Create Password
"Create New Password" / "Choose a strong password". New password + strength indicator. Confirm password. "Set Password" button.

### 8. Dashboard (most complex screen)
- **SliverAppBar** (floating+snap): Left: "Good morning," (bodyMedium) + "{Name}" (titleMedium, 700). Right: notification bell icon.
- **Period Selector**: 4 filter chips — Day / Week / Month / Year. Selected: primary fill + white text.
- **Cash Flow Summary Card**: Gradient (primaryContainer → surface). "Cash Flow" label. Net amount (headlineMedium, 800, green if positive / red if negative, count-up animation). Bottom row split by vertical divider: Income (green, down-arrow) | Expenses (red, up-arrow).
- **Streak Card**: Surface card. Fire emoji + "{X}-day streak!" (titleSmall, 700) + orange pill badge with number. Or sleep emoji + "Log a transaction to start" when 0.
- **Quick Actions**: 3 QuickAction buttons in a row — "Add" (add icon), "Budget" (pie_chart icon), "Savings" (savings icon).
- **Charts Carousel**: PageView with dot indicators:
  - Income vs Expense bar chart (green/red side-by-side bars, rounded tops)
  - Category breakdown donut chart with color-coded legend
- **Health Cards Row**: Two cards side by side:
  - Budget Health: icon, "Budget", % used, progress bar, "View" link
  - Savings Overview: icon, "Savings", total saved, progress bar
- **Financial Health Score Card**: Full-width. Numerical score or letter grade, circular gauge, 2-3 insight bullets.
- **Recent Transactions**: "Recent Transactions" header + "See All" link. Last 5 transactions: 44x44 category icon container (12% category color, 12px radius), category name, description/time, right-aligned colored amount.
- **Guest conversion prompt** (guest users only): Below streak card — "Your data is stored locally. Sign up to sync across devices." + "Sign Up" filled button.

### 9. Transactions List
- **App Bar**: "Transactions" title, "+" action.
- **Search**: Rounded input, search icon, "Search transactions..." hint, clear button.
- **Filter Chips**: "All" / "Income" / "Expense" pills.
- **Grouped List** with sticky date headers (titleSmall, 600):
  - Groups: "Today", "Yesterday", "This Week", "Earlier"
  - Each tile: 44x44 category icon container, category name (bodyLarge), description (bodySmall), trailing: colored amount (bodyLarge, 600) + "time ago" (labelSmall)
  - Swipe left to delete (red bg, white delete icon, confirmation dialog)
  - Staggered fade+slide animation
- **Empty State**: category icon (80px), "No transactions yet", "Start tracking by adding your first transaction", "Add Transaction" button.
- **Coach mark** (first visit): "Swipe left to delete" tooltip pointing to first item.

### 10. Transaction Detail
- **App Bar**: "Transaction Detail", edit + delete action icons.
- **Amount Hero**: Full-width container, semantic color 8% alpha bg. Centered: 56x56 category icon, amount (headlineMedium, bold, semantic color), type badge pill.
- **Details Card**: Rows of icon + label + value separated by dividers. Rows: Category, Date, Payment Method, Provider (if mobile money), Reference, Description, Created, Sync status.

### 11. Add/Edit Transaction (slide-up modal)
- **App Bar**: "Add Transaction" / "Edit Transaction" + back arrow.
- **Type Toggle**: Two equal chips — Expense (red when selected, arrow_downward) / Income (green when selected, arrow_upward).
- **Amount Input**: "Amount" label, borderless displaySmall bold centered input, currency prefix.
- **Recent Categories**: Row of recent/frequent category chips as quick shortcuts above the full grid.
- **Category Grid**: 4 columns, 0.85 ratio, 8px gap. Each cell: AnimatedContainer, 12px radius. Selected: 15% category color fill + 2px border + colored icon/label. Unselected: surfaceContainerHighest.
  - Expense categories: Food & Groceries, Transport, Airtime & Data, Rent, Utilities, Mobile Money Fees, Business, Education, Health, Clothing, Entertainment, Family Support, Religious Giving, Savings, Debt, Personal Care, Household, Insurance, Other
  - Income categories: Salary, Business Income, Freelance, Side Hustle, Mobile Money Received, Family Received, Rental Income, Investment Returns, Government Aid, Other
- **Date Picker**: calendar_today icon, "EEEE, MMM d, yyyy" format.
- **Payment Method Chips**: Cash (money), Mobile Money (phone_android), Bank (account_balance), Card (credit_card).
- **Mobile Money Provider** (conditional): Dropdown — M-Pesa, Orange Money, MTN MoMo, Airtel Money, Wave, Moov Money, Other.
- **Description**: 2-line optional field.
- **Recurring Toggle**: Switch + frequency picker (Daily/Weekly/Monthly) when enabled.
- **Save Button**: "Save Transaction" / "Update Transaction" with loading state.

### 12. Budget Overview
- **With Active Budget**:
  - Budget header card: 44x44 wallet icon, budget name (titleSmall, 700), period pill (calendar + "Monthly"), strategy pill (auto_awesome + "50/30/20").
  - **Budget gauge**: Large circular speedometer at top — green zone (0-70%), yellow (70-90%), red (90%+). Gives instant emotional read on financial health.
  - Total progress card: gradient bg, "Total Spent" label, percentage, spent amount (headlineMedium, 800), "of {total} budget", 8px progress bar.
  - Category groups (Needs/Wants/Savings): group icon + name header, spent/allocated text, per-category 6px progress bars.
  - "New Budget" outlined + "Edit Budget" filled tonal buttons.
- **Empty State**: wallet icon (80px), "No Active Budget", "Create a budget to control spending", "We recommend 50/30/20 for beginners" (primary text), "Start with 50/30/20" filled button + "Custom Budget" outlined button, "Pro tip: Start with a template" caption.

### 13. Budget Setup (4-step wizard)
- **App Bar**: "Create Budget", "Step X of 4" subtitle. Step indicator dots.
- **Step 1 — Strategy**: 4 selectable cards:
  - 50/30/20 Rule (pie_chart): "50% Needs — 30% Wants — 20% Savings"
  - 80/20 Entrepreneur (business_center): "80% Essentials — 20% Savings"
  - Envelope System (mail): "Fixed amounts per category"
  - Custom (tune): "You decide the split"
- **Step 2 — Period & Income**: 3 period rows (Weekly/Bi-weekly/Monthly) + optional income field.
- **Step 3 — Allocations**: Grouped by budget group. Category name + percentage label + amount field per row.
- **Step 4 — Review**: Summary card (strategy, period, income, total), category breakdown.
- **Bottom bar**: "Back" outlined + "Continue"/"Create Budget" filled. Loading on creation.

### 14. Savings Goals List
- **App Bar**: "Savings Goals", "+" action.
- **Total summary bar**: "Total Saved: XOF 125,000 across 3 goals" + mini combined progress bar.
- **Goal Cards**: 16px radius. Row: 64px progress ring with %, goal name (titleMedium, 600), saved/target (bodySmall), deadline chip (schedule + "Xd left" or warning + "Xd overdue" in red), "Add Money" tonal button. Trailing chevron.
- **Empty State**: savings icon (80px), "No Savings Goals", "Start building your future", quick-start chips: "Emergency Fund" (shield), "Vacation" (flight), "New Phone" (phone), "or create your own", "Create Goal" button.

### 15. Add Savings Goal
Goal name field, target amount (currency-prefixed), deadline date picker, currency dropdown, notes field. "Create Goal" button.

### 16. Savings Goal Detail
- 160px progress ring (12px stroke). Center: percentage (headlineMedium, 700) + "saved". Green when fully funded, primary otherwise.
- **Milestone markers**: Small dots on ring at 25/50/75 positions.
- Amount row: Saved (green) | Remaining (gray) | Target (primary) — three columns.
- Deadline card + description card (if set).
- Contribution history list: 40x40 green arrow container, "+amount" green, note/date, time ago.
- Extended FAB: "Add Money" → bottom sheet with amount field + note + "Add Contribution" button.
- **Celebration animations**: Confetti particles at 100%, trophy banner "Goal Completed!", subtle pulse at 25/50/75% milestones.

### 17. More Menu
- **3 sections**: Account (Profile, Settings), Features (Savings Goals, Tontine Groups [Coming Soon badge], Insights [Coming Soon badge]), Support (Help, Rate App, Share App).
- Coming Soon taps → bottom sheet: construction icon (64px), feature name, "Coming soon. Stay tuned!" text.

### 18. Profile
- Hero: Avatar (48px radius), name (headlineSmall), email (bodyMedium, textSecondary).
- Theme toggle tile with switch.
- "Edit Profile" + "Change Password" tiles.
- **Achievements**: "Achievements" header + level badge pill (Beginner/Explorer/Pro/Master). "{X} of 7 badges unlocked" subtitle. Wrap of 7 badges (72px columns):
  - First Transaction (receipt, blue), 7-Day Streak (fire, orange), 30-Day Streak (whatshot, deep orange), First Budget (pie_chart, teal), Under Budget (savings, green), First Goal (flag, amber), 100 Transactions (format_list_numbered, purple)
  - Unlocked: 15% color fill, solid border, colored icon. Locked: gray fill, outline border, gray icon.
  - **Tappable badges**: Tap shows tooltip/sheet with name, description, unlock criteria. Locked badges show progress: "4 more transactions to unlock!"
- Logout button at bottom.

### 19. Settings
- **Currency**: Tile → DraggableScrollableSheet (60% initial, 90% max), 36 currencies with flag + code + name, checkmark for selected.
- **Appearance**: Theme (System/Light/Dark dialog), Language (English/Français dialog).
- **Notifications**: Push toggle, daily reminder toggle ("Reminds you at 8 PM"), budget alert slider (50-100%, shows threshold text).
- **Data**: "Clear Local Data" with red icon + confirmation dialog.
- **About**: Version, Terms link, Privacy link.

### 20. Terms of Service
Scrollable legal page with section headings and body text.

### 21. Privacy Policy
Scrollable legal page with section headings and body text.

### 22. Financial Insights (new screen)
- **App Bar**: "Insights".
- **Period selector**: Week / Month / Quarter / Year chips.
- **Spending Trends Card**: Line chart of spending over time + trend summary ("You spent 12% less than last month").
- **Top Categories Card**: Horizontal bar chart, top 5 expense categories, color-coded, with amount + percentage of total.
- **Income vs Expense Trend**: Overlaid area chart (green income fill, red expense fill) over the selected period.
- **Money Habits Card**: 3 insight pills — "Average daily spend: XOF 5,000", "Most expensive day: Saturday", "Biggest category: Food (32%)".
- **Recommendations**: Actionable tips with action links, e.g., "You could save XOF 15,000/month by reducing Entertainment to your budget limit" + "Set Budget" link.

---

## Navigation Architecture
- Bottom nav: 4 tabs + center FAB
  - Tab 0: Dashboard (dashboard icon)
  - Tab 1: Transactions (receipt_long icon)
  - [Center FAB: Add Transaction — emerald circle, white "+"]
  - Tab 2: Budget (pie_chart icon)
  - Tab 3: More (more_horiz icon)
- Active: primary color. Inactive: textSecondary.
- CircularNotchedRectangle notch for FAB.
- Tab state preserved across navigation.

## Guest Mode Conversion Strategy
- **Persistent banner**: cloud_off icon + "Your data is stored locally only" + "Sign Up" action button.
- **Contextual nudges** (dismissible, each shown only once):
  - After 5th transaction: "You're on a roll! Sign up to keep your data safe."
  - After first savings goal completed: Celebration screen + "Create an account to track your progress forever."
  - After 7-day streak: "Impressive streak! Don't lose it — sign up to sync."

## Dark Theme
Every screen in both light and dark. In dark: background #0F172A, surface #1E293B, primary #34D399, borders #334155, single-layer higher-alpha shadows, brightened semantic colors (#4ADE80 income, #F87171 expense). All text maintains WCAG AA contrast.

## Global UX Rules
1. Every empty state: icon (80px) + headline + body + CTA button. Never leave a blank screen.
2. All amounts: locale-aware formatting with proper currency symbols.
3. Loading: shimmer placeholders matching expected layout shape, never blank spinners alone.
4. Errors: friendly icon + message + "Retry" button.
5. List animations: staggered fade+slide (400ms, 60ms stagger).
6. Auth animations: fade+slide entrance (600ms easeOut).
7. FAB: haptic feedback on press.
8. Pull-to-refresh on dashboard and all list pages.
9. Real-time search filtering on transactions.
10. Inline validation on all forms with error messages.

Design all screens at 375x812px. Provide light and dark variants for every screen. Pixel-perfect adherence to tokens. Every interactive element needs active, disabled, and loading states.
