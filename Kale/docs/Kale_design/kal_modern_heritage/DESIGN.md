# Design System Document

## 1. Overview & Creative North Star: "The Digital Loom"
This design system moves beyond the cold, sterile nature of traditional fintech. Our Creative North Star is **"The Digital Loom."** Just as traditional African textiles are woven with precision and intent, this system weaves high-end editorial clarity with a "cultural warmth" that feels human and grounded.

We reject the "generic SaaS" look. We break the template by utilizing **intentional asymmetry**—offsetting headings and using generous, luxury-grade white space. We avoid the "boxed-in" feel of standard grids by treating the UI as a series of layered, organic surfaces that breathe, rather than a collection of rigid containers.

---

## 2. Colors & Surface Philosophy
The palette is anchored in a sophisticated Emerald, but its power lies in the transitions between states.

### Palette Strategy
- **Primary (#006c49 / #10b981):** Represents growth and vitality. Used sparingly for high-impact actions.
- **Surface Tiers:** We use the `surface-container` scale (`lowest` to `highest`) to build depth. 
- **The "No-Line" Rule:** 1px solid borders are strictly prohibited for sectioning. Separation must be achieved through background color shifts. For example, a `surface-container-low` card sits on a `background` floor. No strokes, no clutter.
- **The "Glass & Gradient" Rule:** To provide "soul," primary buttons and hero cards should utilize a subtle linear gradient (Primary to Primary-Container). Use Glassmorphism (Backdrop Blur: 12px-20px) for floating navigation bars or modal overlays to allow the underlying "warmth" of the content to bleed through.

---

## 3. Typography: Editorial Authority
We use **Inter** not as a system font, but as a structural element. By leaning into extreme scale contrasts, we create an editorial rhythm.

| Token | Size | Weight | Intent |
| :--- | :--- | :--- | :--- |
| **display-lg** | 3.5rem | 700 | Large balance displays; high-impact "hero" moments. |
| **headline-md** | 1.75rem | 600 | Section entries; creates a rhythmic "stop" for the eye. |
| **title-sm** | 1rem | 500 | Card titles and primary navigation labels. |
| **body-md** | 0.875rem | 400 | Transaction details and general descriptions. |
| **label-sm** | 0.6875rem | 600 (Caps) | Micro-data; currency codes; "Overdue" status. |

**Styling Note:** Always use `-1%` to `-2%` letter spacing on Display and Headline tokens to achieve a "premium print" density.

---

## 4. Elevation & Depth: Tonal Layering
We do not use elevation to "lift" objects; we use it to "layer" stories.

- **The Layering Principle:** Depth is achieved by stacking. Place a `surface-container-lowest` card on a `surface-container-low` section. This creates a soft, natural lift that mimics fine paper.
- **Ambient Shadows:** When a float is required (e.g., a bottom sheet), use a "Ghost Shadow": `0px 20px 40px rgba(15, 23, 42, 0.06)`. The shadow must feel like a soft glow of light, never a dark smudge.
- **The "Ghost Border" Fallback:** If accessibility requires a container boundary, use the `outline-variant` token at **15% opacity**. It should be felt, not seen.
- **Glassmorphism:** Use `surface-variant` at 60% opacity with a `blur(16px)` for top navigation bars. This maintains the "cultural warmth" by keeping the background colors visible as the user scrolls.

---

## 5. Components
Each component must feel "custom-built," avoiding the heavy, rounded-corner look of common UI kits.

### Buttons (The "Action Bar")
- **Primary:** Full-width (52px height). Use the 12px `DEFAULT` radius. Background: Gradient from `primary` to `primary-container`. Text: `on-primary` (Bold).
- **Secondary:** Surface-only. Background: `surface-container-high`. No border.
- **Interaction:** On press, scale the button to `0.98` to provide tactile feedback.

### Input Fields
- **Style:** Outlined, but using the "Ghost Border" rule (low opacity). 
- **Focus State:** Transition the border to `primary` (100% opacity) and add a subtle `primary-fixed` outer glow.
- **Labels:** Floating labels using `label-md` to maintain vertical compactness.

### Rich Cards & Lists
- **The Divider Rule:** Forbid the use of horizontal divider lines. Separate list items using `spacing-4` (1rem) of vertical white space or by alternating between `surface` and `surface-container-low`.
- **Finance Cards:** Use `tertiary-container` for Budget and `error-container` for Expenses. These should be large, spanning the full width, with the geometric "K" logo watermark at 5% opacity in the corner to reinforce branding.

### The Geometric 'K' Logo
- The logo is a brand anchor. It should be used as a structural element—partially cropped in header backgrounds or used as a pattern fill in empty states.

---

## 6. Do’s and Don’ts

### Do
- **Do** use asymmetric layouts. Align your headline to the left but your "View All" link to the far right, separated by raw whitespace.
- **Do** use the `4px` grid religiously for padding. If an element feels "off," it’s likely because it isn't on a factor of 4.
- **Do** leverage "Semantic Finance" colors for text. An expense amount should be `error`, but the label "Expense" should be `on-surface-variant`.

### Don’t
- **Don’t** use 100% black (#000000). Always use `on-surface` (#0F172A) to maintain the "ink on paper" warmth.
- **Don’t** use standard shadows. If you can clearly see where the shadow ends, it is too heavy.
- **Don’t** use "Card-in-Card" layouts with borders. Use shifts in tonal values (`surface-container` tiers) to signify nested hierarchy.