# Claude Code Prompts Library

A library of self-contained prompts to paste into Claude Code (or Claude.ai's code sessions). Each prompt assumes the existing SwiftUI POC repo at `github.com/malmlaiti1/covered-collection/tree/covered-collection`.

### Prompt 1 — Wire up Supabase as the production backend

> You are working in the Covered Collection SwiftUI iOS 17+ codebase. Replace JSON file persistence with Supabase. Add the `supabase-swift` SPM dependency. Create `Networking/SupabaseClient.swift` exposing a singleton with `auth`, `database`, and `storage`. Migrate `Models/Product.swift`, `Models/Brand.swift`, `Models/SubscriptionPlan.swift` to map onto the schema in development-plan.md §Phase 1. Generate `supabase/migrations/0001_init.sql` using the published schema. Write a one-shot data migration that reads the 24 mock products from JSON and inserts them into Supabase. Add `.env.local` config and an `Environment.swift` enum for Dev/Stage/Prod.

### Prompt 2 — Auth with Sign in with Apple + email

> Implement Apple Sign In and email/password auth using Supabase Auth. Create `Auth/SignInWithAppleCoordinator.swift` conforming to `ASAuthorizationControllerDelegate`. Persist the Apple credential refresh state in Keychain. Wire `AuthViewModel` to gate onboarding so the Modesty DNA quiz runs *after* auth (captures preferences against a real user_id). Add "Continue as Guest" that defers auth until checkout. Required by Apple guideline 4.8 since we offer a third-party login.

### Prompt 3 — Stripe Billing integration

> Add the Stripe iOS SDK and Stripe PaymentSheet. Create a Supabase Edge Function `stripe-create-subscription` (Deno) that takes `{plan, payment_method_id}` and creates a Stripe Customer + Subscription, returning the client_secret. Wire `PlanSelectionView` to call this. On success, write to `subscriptions` table. Add `BillingPortalView.swift` opening a Stripe Customer Portal session for cancel/pause/card-update. Document in the in-app help that "Covered Collection rentals are billed for physical goods, exempt from IAP per App Store Review Guideline 3.1.3(e)."

### Prompt 4 — Cloudflare R2 + Images photo pipeline

> Replace `Imaging/ProceduralImageGenerator.swift` with `Imaging/CloudflareImageURLBuilder.swift`. Configure an R2 bucket `covcol-products` and a Cloudflare Images account. Implement an admin-only Edge Function `upload-product-image` taking a multi-part image, writing to R2 with key `products/{product_id}/{variant_id}/{order}.jpg`, and registering the key in `products.image_keys`. On iOS, the URL builder constructs `https://imagedelivery.net/{account_hash}/{key}/{variant}` with variants `thumb` (200w), `card` (640w), `detail` (1280w), `zoom` (2400w). Use `AsyncImage` with the right variant per screen.

### Prompt 5 — Atomic Build-Your-Box with stock locking

> Implement `Inventory/BoxClaimService.swift` such that adding an item to a box atomically reserves the underlying `physical_items` row. Use a Postgres function `claim_item(p_box_id, p_variant_id)` selecting the first `available` row `FOR UPDATE SKIP LOCKED` and setting `status='reserved'`. On iOS, expose a publisher emitting stock changes via Supabase Realtime. Handle "out of stock between view and claim" with a toast + alternative.

### Prompt 6 — Religious calendar with push

> Build `Calendar/ReligiousCalendarSeeder.swift` loading 2026 and 2027 occasions exactly as documented: Ramadan begins evening of 17 Feb 2026 and concludes 21 Mar 2026; Eid al-Fitr around 19–21 Mar 2026; Eid al-Adha 27–28 May 2026; Rosh Hashanah 11–13 Sep 2026; Yom Kippur 20 Sep 2026; Hanukkah 4–12 Dec 2026; Christmas 25 Dec; LDS General Conference 4–5 Apr 2026 and 3–4 Oct 2026; Easter 5 Apr 2026 (Gregorian). Add `Calendar/PushScheduler.swift` to schedule "Your Ramadan box" at T−30 days, "Build your Eid look" at T−21, "Last call" at T−7. Register APNs in `AppDelegate.swift`. Use UNNotificationServiceExtension for rich content (image + deep link).

### Prompt 7 — App Tracking Transparency

> Add `App/AppTrackingCoordinator.swift` requesting ATT *after* the user completes the first box (consent-rich timing, not at app launch). `Info.plist` rationale: "Covered Collection uses limited tracking to recommend modest pieces from brands you'd love, and to measure which campaigns reach women in your community." Integrate Meta SDK only if ATT granted; otherwise SKAdNetwork conversion values.

### Prompt 8 — Deep linking + Universal Links

> Configure `apple-app-site-association` hosted at https://coveredcollection.com/.well-known/apple-app-site-association covering `/box/*`, `/product/*`, `/calendar/*`, `/invite/*`. Implement `App/DeepLinkHandler.swift` routing to the right screen. Wire the referral mechanic: `/invite/{code}` opens AppStore on first launch, sets the referrer in Keychain, credits both parties on conversion.

### Prompt 9 — Photography ingest CLI

> Build a TypeScript CLI at `tools/photo-ingest/` taking a CSV of `(sku, file_path, variant)` rows, validating each file is ≥2400×3000 px, stripping EXIF, uploading to Cloudflare Images, inserting image IDs into Supabase. Add a Sharp-based check that white balance is close to D65 and warn the photographer if not. Reject any photo without `_styled_on_model` suffix.

### Prompt 10 — App Store submission package

> Generate App Store screenshots in all required sizes (6.7", 6.5", 6.1", 5.5") via Fastlane `snapshot`. Generate a 30-second preview video showing: onboarding → Modesty DNA quiz → calendar view → box build → hijab pairing → "Box shipped" celebration. Draft the App Privacy nutrition label with data types: Name, Email, Phone Number, Physical Address, User Content, Identifiers, Usage Data, Diagnostics — all "Linked to You" and "Not used for Tracking" unless Meta SDK is enabled. Draft App Review notes explaining that physical-goods rental is exempt from IAP per guideline 3.1.3(e) and reference RTR/Nuuly/Stitch Fix as precedent.

### Prompt 11 — Design System v2

> Audit current SwiftUI views for design inconsistency. Create `DesignSystem/` module with: `Colors.swift` (cream `#F8F3EC`, terracotta `#C77450`, deep moss `#3D4E36`, navy `#1F2A44`, neutral text `#2A2724`), `Typography.swift` (Display = Cormorant Garamond, Body = Inter, Arabic = IBM Plex Sans Arabic for RTL), `Spacing.swift` (4/8/12/16/24/32/48 scale), `Components/` (Button, Card, ChipFilter, ModestyAxisSlider). Migrate every existing view to consume the design system. Add `swiftgen` for asset code-gen.

### Prompt 12 — Accessibility audit

> Run an a11y audit on every screen. Required: every interactive element has `accessibilityLabel`; the Modesty DNA slider supports VoiceOver rotor; product images carry meaningful labels ("Long-sleeve maxi dress in moss green, opaque crepe, A-line silhouette"); minimum tap target 44×44pt; contrast ratio ≥4.5:1 for text. Add XCUITest accessibility assertions on the top 8 screens.

### Prompt 13 — Performance audit

> Profile cold launch, hot launch, scroll FPS on an iPhone 12 baseline. Cold launch budget 1.8s; hot launch 0.4s; scroll 58–60fps on the Closet grid. Use `os_signpost` for critical regions. Implement image pre-fetching for the next 12 cards in the closet scroll. Switch to `LazyVGrid` if not already. Audit the Modesty DNA filter query — if Supabase round-trip >200ms, cache the last filter result locally with 5-minute TTL.

### Prompt 14 — Internationalization with Arabic RTL

> Add String catalogs for `en`, `ar`, `ur`. Wire `Locale.LayoutDirection.rightToLeft` overrides on Arabic; verify every view's leading/trailing flips correctly. Add a language picker in Account → Preferences (default to device locale). Hire a professional Arabic translator (not MT); budget $0.18–$0.25/word for ~2,000 strings. Defer Urdu to Phase 4.

### Prompt 15 — Inventory admin dashboard

> Build `apps/admin/` as a Next.js 15 App Router project using the Supabase service-role key (server-only). Screens: Products list w/ filters, Physical Items w/ bin assignment, Box queue (Building / Shipped / In-Cleaning / Available), Subscription health (MRR, churn, top cancel reasons), Brand wholesale ledger. Use shadcn/ui. Gate access via `staff = true` flag in `profiles`.

### Prompt 16 — Returns & cleaning SOP automation

> Implement a Shippo webhook handler at `supabase/functions/shippo-inbound-scan`. When a return is scanned at the carrier facility, transition the associated box's items to `cleaning`. When the warehouse scans them in, transition to `available`. SMS the customer at the inbound-scan moment ("We got your box! Build your next one."). Twilio for SMS; separate from-numbers for English and Arabic content.

### Prompt 17 — Referrals & waitlist

> Implement `Referrals/ReferralCodeService.swift`. Each user gets a 6-char code on signup. Sharing emits a Universal Link `/invite/{code}`. New signup attaches the referrer in onboarding. On first paid invoice, credit both parties one free month (Stripe coupon `referral_credit`). Build a leaderboard view ranking users by `referrals_converted` for the "Founding 50" program.

### Prompt 18 — In-app rating, review, and fit feedback

> Add `Reviews/ReviewSubmissionView.swift` shown 5 days after delivery. Capture: overall rating (1–5), fit (run small/true/run large), modesty match (Modesty DNA delta), would-rent-again. Store in `box_items` JSON column. Feed deltas back into the personalization engine. Display average rating on Product Detail.

### Prompt 19 — AI styling assistant (Phase 4)

> Add a chat surface backed by Anthropic Claude. System prompt grounds the assistant in the user's Modesty DNA, current available inventory (pgvector embedded product summaries), and religious calendar. Must never recommend out-of-stock items; must suggest a hijab pairing if the user wears hijab; must respect prayer-friendly flags. Cache last 5 turns. Token budget: 1,500 in / 800 out per turn.

### Prompt 20 — Analytics events catalog

> Define a strict events taxonomy in `Analytics/Events.swift`: `app_open`, `onboarding_started`, `dna_quiz_started`, `dna_quiz_completed`, `plan_viewed`, `plan_selected`, `checkout_started`, `subscription_started`, `box_built`, `box_shipped`, `box_delivered`, `item_rented`, `item_returned`, `item_rated`, `referral_shared`, `referral_converted`, `subscription_paused`, `subscription_cancelled` with documented properties. Wire each to PostHog. Add a Saturday daily-rollup query posting MRR/churn/NPS to Slack.

### Prompt 21 — Brand wholesale onboarding

> Build a self-serve brand onboarding flow at admin.coveredcollection.com/brand-signup. Capture: brand name, contact, line sheet upload, wholesale rate, payment terms, EIN/W9, ACH details. On approval, generate a brand portal showing units rented and consignment SKU approval.

### Prompt 22 — Subscription pause / cancellation save flow

> Implement a 3-step cancel flow: reason picker (price, fit, frequency, no time, other) → counter-offer (1 month at $59, or pause 30/60/90, or downgrade to Core $89) → final confirmation. Track step conversion. Mirror RTR's pause feature retaining rewards status (per RTR's published policy: "RTR Memberships can be paused or canceled at any time by visiting Manage Plans in Your Membership page").

### Prompt 23 — Modesty DNA v2 with embeddings

> Upgrade DNA from 5 axes to hybrid axes + embeddings. Compute a 512-dim CLIP embedding per product image; store in pgvector. At quiz completion, generate a user embedding from her axis selections + favorited items. Recommendations = cosine similarity within axis-filter constraints. A/B test against pure-axis recommender; target +18% closet-feed CTR.

### Prompt 24 — Photoshoot day-of automation

> Build a tablet-based Photoshoot Coordinator (SwiftUI iPad) the on-set stylist uses: today's shot list, mark each look "in progress" / "needs reshoot" / "approved", attach SKU barcode to photo, push directly to the upload pipeline. Save 4–6 hours per shoot day.

### Prompt 25 — Pre-Ramadan readiness checklist (annually)

> Each year, 60 days before Ramadan, generate a Readiness Report: inventory level vs forecast, photo coverage for Ramadan-curated SKUs, push sequence scheduled, paid-media budget locked, influencer contracts signed, ops capacity (cleaning slots, shipping volume) modeled at 3× normal. Block launch if any axis fails its threshold.
