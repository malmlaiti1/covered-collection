# Layla & Co.

A proof-of-concept native iOS app for a modest clothing rental subscription targeting Muslim, Jewish, LDS, Christian, and secular modest-curious customers.

SwiftUI · iOS 17+ · MVVM with `@Observable` · no third-party runtime dependencies.

## Setup

```bash
brew install xcodegen     # if you don't have it
xcodegen generate
open LaylaAndCo.xcodeproj
```

Pick the **LaylaAndCo** scheme and an iPhone 16 (or any iPhone) simulator. Run.

To re-run the build from the command line:

```bash
xcodebuild \
  -project LaylaAndCo.xcodeproj \
  -scheme LaylaAndCo \
  -destination 'platform=iOS Simulator,name=iPhone 16,OS=latest' \
  -configuration Debug build
```

## Project structure

```
LaylaAndCo/
├── App/               LaylaAndCoApp, AppRoot (onboarding gate), MainTabView
├── DesignSystem/      Colors / Typography / Spacing tokens and shared components
├── Models/            Product, ModestyDNA, SubscriptionPlan, UserProfile, MockData
├── Persistence/       PersistenceManager actor, UserProfileStore, ProductRepository
├── Features/
│   ├── Onboarding/    5 Modesty DNA axes → tags → plan → success
│   ├── Closet/        Browse + DNA filter + curated grid
│   ├── ProductDetail/ Hero, DNA match card, size picker, CTAs
│   ├── Plans/         Reusable plan picker (used by onboarding AND Account)
│   ├── MyBox/         Tracker + items + empty states
│   ├── Saved/         Wishlist + empty state
│   ├── Calendar/      Occasion planner
│   └── Account/       Profile + plan management + DEBUG reset
├── Resources/
│   └── Assets.xcassets/
│       └── Colors/    One .colorset per design token
└── Utilities/
```

Each tab owns its own `NavigationStack` with an enum-based router (`ClosetRoute`, `AccountRoute`, etc.) so back-navigation survives tab switching.

## What's mocked

- All data lives in `Models/MockData.swift` — 24 products across 8 brands, 3 subscription plans, 5 calendar events, and one sample user "Amina".
- Persistence writes a single JSON file (`user_profile.json`) into the app's Documents directory.
- Product images are **procedural placeholders** (brand-toned rectangles with serif type) — no remote fetches, no broken `AsyncImage` states. A `#if USE_REMOTE_IMAGES` branch in `ProductImageView` is reserved for the future real backend.
- No network calls, no payment, no auth.

## How to add a new product

1. Open `LaylaAndCo/Models/MockData.swift`.
2. Append a new entry to `static let products: [Product]` using the `p(...)` factory — pass a unique seed string, brand, name, retail/buy prices, category, and any non-default Modesty DNA axes.
3. (Optional) Drop a JPG into `LaylaAndCo/Resources/Assets.xcassets/Products/<name>.imageset/` and pass that image set name as `imageAssetName:` to make the new product use a real photo instead of the procedural placeholder.

## Demo flow

1. **First launch.** Modesty DNA onboarding appears. Step through the 5 axes (defaults make Amina a hijabi who prefers ankle-length, fully-opaque, long-sleeve, relaxed cuts), pick tags, pick a plan ("Signature" is featured), and tap **Build My Closet**.
2. **Closet.** 20 of 24 products show — 4 are intentionally hidden by Amina's default DNA filter (a V-neck midi, an elbow-sleeve sundress, a knee-length sweater dress, and a sheer blouse). Open the sliders icon in the top-right and choose **Loosen sleeve → Elbow OK** to reveal one of them.
3. **Product detail.** Tap any card to see the Modesty DNA match card, size picker, and three CTAs.
4. **My Box.** Without a plan, you see the "Your first box is waiting" empty state with a **View Plans** CTA. With a plan but no shipment yet, you see the "between shipments" state.
5. **Saved.** Heart something in Closet to populate it; otherwise you see the "Nothing saved yet" empty state with a **Browse Closet** CTA that switches tabs.
6. **Calendar.** Five upcoming religious occasions with day countdowns; tap one to plan an outfit.
7. **Account → Developer → Reset Onboarding** (debug builds only) wipes state and re-launches into onboarding.
8. **Persistence.** Force-quit the app and relaunch — onboarding is skipped, Amina's name and DNA filter persist.

## Brand notes

| Token         | Hex      | Use                             |
|---------------|----------|---------------------------------|
| laylaCream    | #FAF7F2  | Primary background              |
| laylaSurface  | #FFFFFF  | Cards                           |
| laylaOlive    | #2D3E2F  | Primary buttons, accents        |
| laylaGold     | #D4A574  | Highlights, "MOST POPULAR"      |
| laylaRose     | #C89B8C  | Secondary accents               |
| laylaInk      | #1A1A1A  | Primary text                    |
| laylaMuted    | #6B6B6B  | Secondary text                  |
| laylaBorder   | #E8E2D7  | Hairlines, card strokes         |
| laylaSuccess  | #5C7F5C  | DNA match checkmarks            |
| laylaTagBg    | #F4EDE0  | Pill/tag backgrounds            |

All tokens are stored as `.colorset` entries under `Assets.xcassets/Colors/` and surfaced through `Color.laylaCream` etc. Adding a dark-mode variant in Phase 2 means dropping a `dark` appearance entry into each color set — no Swift changes.

Typography uses the system serif (`.system(.<style>, design: .serif)`) for headlines and SF Pro for body. No custom font files.

## Phase 2 roadmap

1. Dark mode (add `dark` variants to every `.colorset`).
2. Real backend + payment.
3. Modesty DNA edit screen with live re-filtering.
4. Raise `SWIFT_STRICT_CONCURRENCY` to `complete` and audit Sendable boundaries on `PersistenceManager`.
5. Haptic feedback on all primary buttons.
6. Bundle real product photography (one image set per product in `Assets.xcassets/Products/`).
7. Referral program + App Store screenshot pipeline.
