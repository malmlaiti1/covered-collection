# Covered Collection — Development Plan

## Sequencing principle

**"Cash before code, customers before features."** Phase 1 prioritizes the *minimum* technical surface that lets you bill real money for real garments shipped to real Dearborn customers. Phases 2–5 add features only where data shows churn or CAC is being throttled by the absence of that feature.

## Tech stack decisions (with reasoning)

| Layer | Recommendation | Rejected alternatives | Why |
|---|---|---|---|
| **Backend** | **Supabase** (Postgres 15, Row-Level Security, Auth, Storage, Edge Functions in Deno) | Firebase (NoSQL hurts inventory queries; lock-in); custom Node + RDS (too much DevOps for a solo founder); Convex (vendor risk) | Postgres is the right data model for inventory/lifecycle (boxes, items, returns); RLS lets you ship a secure mobile-direct backend without a separate API tier; Supabase Auth handles Sign in with Apple natively (required for App Store guideline 4.8); open-source escape hatch. |
| **Payments** | **Stripe Billing + Stripe Customer Portal** | Braintree, Adyen, Recurly | Stripe explicitly supports clothing-rental subscriptions. Per Chargeback Stop's analysis of Stripe's posture, subscription billing only becomes high-risk if disputes exceed 0.65%–0.75%. Mitigation: clear billing descriptors, pre-charge email reminders, easy cancellation. **You do not need a high-risk processor on day one.** RTR, Nuuly, Stitch Fix, and Pickle all bill via standard Stripe/equivalents. |
| **iOS payments wrapper** | StoreKit 2 for *digital-only* tiers if you ever add them; **Stripe SDK for the physical-garment subscription** — Apple's guideline 3.1.3(e) explicitly exempts "subscriptions… consumed outside of the app" (rentals, marketplaces, real-world services) from IAP. | Mandatory IAP would cost 15–30% — fatal at $89 plan. | Modeled on Rent the Runway, Stitch Fix, Nuuly — all bill via web/Stripe; iOS app is a viewer/management surface. |
| **Image hosting & delivery** | **Cloudflare R2 + Cloudflare Images** (or **Bunny.net** as cheaper alt) | AWS S3 + CloudFront (egress fees); Imgix (expensive at scale) | R2 has zero egress fees — critical when each product needs 8–12 high-res photos × thousands of SKUs × millions of mobile loads. Cloudflare Images provides automatic AVIF/WebP, responsive variants, signed URLs at the $0.005 per 1k-delivery price band. |
| **Search & faceting** | **Typesense Cloud** (open source, hosted) | Algolia (5×+ price); Meilisearch (less mature faceted search); raw Postgres FTS (won't handle Modesty-DNA personalization at scale) | Modesty DNA is essentially faceted vector search across 5 axes — Typesense handles this sub-50ms on a $99/mo starter cluster. Algolia would be $500+ at the same scale. |
| **Analytics** | **PostHog Cloud (EU region for GDPR optionality)** + **Klaviyo** for behavioral email/SMS | Mixpanel, Amplitude, Segment | PostHog: product analytics, feature flags, session replay, cohort exports under one bill. Klaviyo's e-commerce flows beat PostHog's for win-back/cart-abandonment. |
| **Customer support** | **Front** (shared inbox) on launch → **Intercom** at 500+ subs | Zendesk (overkill); Help Scout | Front handles WhatsApp, IG DMs, email, and SMS in one inbox — and a large share of Muslim-American DTC support flows through Instagram DMs (Haute Hijab CEO Melanie Elturk has publicly said she answers every DM personally; quoted in Fashionista interview). |
| **Transactional email** | **Postmark** for transactional; **Klaviyo** for marketing | Resend (newer); SendGrid (deliverability slipped) | Postmark has best-in-class transactional deliverability; Klaviyo is the e-commerce standard. |
| **Shipping API** | **Shippo** (multi-carrier USPS/UPS/FedEx, return labels) | EasyPost (similar) | Pre-built return-label workflow + inbound scan webhooks save weeks. |
| **3PL / warehousing** | **Hand-pack from Dearborn warehouse** for first 250 subscribers → **ShipBob** at 250+ | Self-warehouse forever (capex); Stord (enterprise-priced — Red Stag's comparison shows Stord targets mid-market+) | ShipBob's published economics (per Simpl Fulfillment's published 2026 breakdown: $275/mo minimum, $975 setup, ~$0.30/pick) fit sub-$5M ARR clothing brands. |
| **Dry cleaning** | **Tide Cleaners** (PERC-free, P&G national network) + **Zips Cleaners** | Local mom-and-pop (variance kills you) | RTR's own clothing-subscription FAQ explicitly states it "does not use (and have never used) halogenated cleaning solvents such as Perchloroethylene (PERC)" — you must match this to win the eco-conscious segment. Negotiate volume rates: at 500+ garments/wk, expect $4.50–$6.50 per garment all-in (Moneypantry baseline: $2–$5 per shirt, $5–$8 per dress at retail). |
| **Inventory mgmt** | **Custom Postgres tables** (you are the inventory system) | Cin7, Stitch Labs, Fishbowl | None model garment lifecycle (rented N times, last cleaned, condition score, hijab pairings) — you must build it. |
| **CI/CD** | **Xcode Cloud** for iOS builds + TestFlight, **GitHub Actions** for backend + Supabase migrations | Bitrise, Fastlane | Xcode Cloud is path of least resistance to TestFlight + App Store. GitHub Actions keeps backend in one repo. Keep Fastlane as a local emergency hatch for signing. |

## Phase 1 — Polish POC to TestFlight beta (Weeks 1–8)

**Goal:** Real auth, real billing, real garments, real subscribers (closed beta, 50 people in Dearborn).

**Features**

1. Apple Sign In + email/password (Supabase Auth) — required by App Store guideline 4.8.
2. Stripe-subscribed plan selection ($89 / $129 / $169) replacing mock plan picker.
3. Real product catalog backed by Supabase Postgres.
4. Image pipeline: Cloudflare R2 + Cloudflare Images variants.
5. "Build Your Box" with stock-aware atomic item locking (Postgres `SELECT … FOR UPDATE SKIP LOCKED`).
6. Shipping address + Apple Pay one-tap.
7. Real Calendar of religious occasions, seeded with **2026/2027 dates** (Ramadan begins evening of 17 Feb 2026, concludes 21 Mar 2026 per Human Relief Foundation; Eid al-Fitr Mar 19–21 2026 per IslamicFinder/Islamic Relief UK; Eid al-Adha 27–28 May 2026 per Makkah Compass; Rosh Hashanah 11–13 Sep 2026; Yom Kippur 20 Sep 2026; Hanukkah 4–12 Dec 2026; Christmas 25 Dec; LDS General Conference 4–5 Apr 2026 and 3–4 Oct 2026; Easter 5 Apr 2026 Gregorian).
8. Push notifications via APNs.
9. App Tracking Transparency dialog if any Meta SDK in use.

**Files/modules (additive to current SwiftUI codebase)**

```
CoveredCollection/
├── App/
│   ├── AppDelegate.swift               # APNs registration, deep links
│   └── Environment.swift               # Dev/Stage/Prod config
├── Networking/
│   ├── SupabaseClient.swift            # Singleton, swap for Convenience
│   ├── APIError.swift
│   └── Endpoints/
│       ├── ProductsEndpoint.swift
│       ├── BoxEndpoint.swift
│       ├── SubscriptionEndpoint.swift  # Stripe via Edge Function
│       └── CalendarEndpoint.swift
├── Auth/
│   ├── SignInWithAppleCoordinator.swift
│   └── AuthViewModel.swift
├── Payments/
│   ├── StripeSheetCoordinator.swift
│   └── BillingPortalView.swift         # WKWebView wrapper
├── Imaging/
│   ├── CloudflareImageURLBuilder.swift
│   └── AsyncImageCache.swift           # NSCache-backed
├── Inventory/
│   ├── BoxClaimService.swift           # transactional item lock
│   └── InventoryLifecycle.swift
└── Analytics/
    └── PostHogClient.swift
```

**Backend (Supabase) — v1 schema**

```sql
-- core entities
create table profiles (
  id uuid primary key references auth.users(id),
  full_name text, phone text,
  modesty_dna jsonb,           -- {neckline, sleeve, hem, opacity, silhouette}
  hijab_palette jsonb,
  prayer_friendly bool default true,
  shipping_address jsonb
);
create table brands (
  id serial primary key, name text, slug text unique,
  consignment_rate numeric, wholesale_rate numeric
);
create table products (
  id uuid primary key, brand_id int references brands(id),
  name text, modesty_axes jsonb, retail_price numeric,
  prayer_friendly bool, ramadan_collection bool,
  hijab_pairing_ids uuid[], image_keys text[]
);
create table product_variants (
  id uuid primary key, product_id uuid references products(id),
  size text, color text, sku text unique
);
create table physical_items (              -- one row per garment we own
  id uuid primary key, variant_id uuid references product_variants(id),
  acquired_at date, acquired_cost numeric,
  rental_count int default 0,
  status text check (status in ('available','reserved','out','cleaning','retired','lost')),
  last_cleaned_at timestamptz, condition_score int default 100
);
create table subscriptions (
  id uuid primary key, profile_id uuid references profiles(id),
  stripe_subscription_id text, plan text,
  status text, current_period_end timestamptz
);
create table boxes (
  id uuid primary key, profile_id uuid references profiles(id),
  status text,
  shipped_at timestamptz, returned_at timestamptz,
  outbound_tracking text, inbound_tracking text
);
create table box_items (
  id uuid primary key, box_id uuid references boxes(id),
  physical_item_id uuid references physical_items(id),
  fit_feedback jsonb, rating int
);
```

RLS: profiles see only their own rows; admin role bypasses.

**Effort:** 6–8 weeks, one full-time iOS engineer (the founder) + one part-time backend/ops contractor (budget $8–12K for 4 weeks).

**Exit criteria:** 50 paying beta subscribers in Dearborn ZIPs 48124/48126/48128; TestFlight rating ≥4.5; box-fulfilled-to-shipped cycle ≤48h; NPS ≥50.

## Phase 2 — Pre-launch operational readiness (Weeks 9–16)

**Goal:** Operational systems that won't break at 500 subscribers.

**Add**

1. **Inventory management v2** — bin locations, barcode scanning (Honeywell scanner + Code 128), restock alerts, "low-stock-causing-churn" alerts.
2. **Logistics workflow** — Shippo inbound webhook → auto-transition to `status='cleaning'` → cleaning-partner SOP → barcode scan back to `available`.
3. **Returns** — pre-paid USPS Ground Advantage label in every box ($7–$10 at commercial rates per EasyPost USPS rate chart for 5-lb apparel); 60-day "Rent With Confidence" policy mirroring RTR's published policy ("If you don't like items for any reason in the first 60 days, let us know. You'll get a free replacement when you create your next shipment.").
4. **Dry cleaning** — bin-and-drop SOP with Tide or Zips; track cost per item.
5. **Customer support** — Front inbox, IG DM integration, WhatsApp Business API (critical for Arab-American flows), Loom-based onboarding.
6. **Analytics** — PostHog events on every funnel step; weekly cohort retention; Stripe Sigma for MRR/churn.
7. **Operational dashboards** — internal Retool or Next.js admin (Supabase service-role).
8. **App Store assets** — screenshots, preview video, App Privacy nutrition labels, ATT rationale.

**Effort:** 6–8 weeks. **Most important hire:** Dearborn-local, Arabic-speaking ops manager at $55–70K + equity.

**Exit criteria:** outbound ≤24h; inbound-to-available ≤72h; CSAT ≥4.7/5; gross margin per box ≥55% on first shipment.

## Phase 3 — MVP launch (Weeks 17–28)

**Goal:** Open the waitlist; hit 1,000 paying subs.

**Add**

1. **Waitlist with referral mechanic** — first referrer + 5 referrals = first month free.
2. **Smart sizing** — capture fit feedback after every wear and feed into Modesty DNA so the second box is materially better. RTR's CEO Jennifer Hyman publicly attributes the FY25 turnaround to inventory + customer obsession (RTR investor release, Sept 11 2025: "I have conviction that this quarter's results prove that our focus on transforming our inventory and getting back to our customer-obsessed roots is working").
3. **Ratings & reviews** on every product.
4. **Religious-calendar push** — "Ramadan is in 21 days. Build your taraweeh box."
5. **Hijab pairing recommender** — Pinterest-style "complete the look."
6. **Photography v2** — in-house photo studio with hijabi models; abandon licensed brand imagery for owned brand imagery. Hire one local Dearborn modest-fashion photographer at $400–$600/day; 3 days/month = $1,500–$2,000/month.
7. **App Store launch.**

**Effort:** 10–12 weeks. Add: 1 photographer/stylist contractor; 1 brand/community manager (hijabi, ideally a Dearborn micro-influencer).

**Exit criteria:** 1,000 paying subs; ARPU ≥$115; CAC ≤$90 fully-loaded; M3 retention ≥70%; M6 ≥55%.

## Phase 4 — Growth (Months 7–18)

1. **Community/social** — in-app "Modest Looks" feed (UGC → lowers content cost). Staff one part-time moderator.
2. **AI styling assistant** — Claude/GPT API + your inventory + Modesty DNA + religious calendar; cache product embeddings in pgvector.
3. **Occasion-based curation** — Eid box, taraweeh box, walima/wedding box.
4. **Family/group plans** — sister-pair plans (share a wardrobe across 2 women in one household).
5. **B2B/events** — one-off rentals for MSA galas, MIST tournaments, ISNA/ICNA banquets, IMAN gala.
6. **Expanded categories** — modest activewear (Adidas Hijab Pro, Veil Garments, Haute Hijab Sport — Melanie Elturk publicly discussed the Haute Hijab Sport launch in *Salaam Gateway*); modest swim; plus-size depth; maternity (under-served); modest workwear capsule with INAYAH and Verona Collection.

## Phase 5 — Scale (Months 18–36)

1. **International** — UK first (Haute Hijab's second-largest market after the US per Melanie Elturk in *Naira NYC* interview: "this past year was our first real foray into the international market with our launch in the UK. They're our biggest market after the US"). Canada (Toronto/Mississauga/Markham) close second.
2. **White-label** — license Modesty DNA + ops to LDS, Orthodox Jewish, and South Asian wedding rental verticals.
3. **Marketplace** — peer-to-peer modest rentals à la Pickle (which raised $12M Series A March 12, 2025, co-led by FirstMark Capital and Craft Ventures with participation from Burst Capital and FJ Labs, per Fortune; total funding to $20M).

## Testing strategy

- **Unit tests** — XCTest; ~70% coverage on Modesty DNA, BoxClaimService, SubscriptionEndpoint.
- **Snapshot tests** — `swift-snapshot-testing` (Point-Free) on key screens; lock RTL Arabic in Phase 4.
- **End-to-end** — XCUITest on onboard → DNA quiz → plan select → checkout → first box.
- **Backend** — Supabase SQL tests with `pgTAP`; integration tests in Edge Functions with Deno std/testing.
- **Load** — k6 against prod endpoints before Ramadan and pre-Eid (3–5× normal load).

## CI/CD

- **iOS:** Xcode Cloud workflows — `PR → unit tests + build`; `main → TestFlight internal`; `tag v* → TestFlight external + App Store submission`.
- **Backend:** GitHub Actions; environment matrix (`dev`, `stage`, `prod`); Supabase CLI migrations gated by manual approval on prod; pgTAP on every PR.
