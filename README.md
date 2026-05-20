# Covered Collection — Executive Overview

## TL;DR

- **Build Covered Collection as the *Nuuly for modestwear*** — a US iOS-led subscription rental for Muslim-American women (and adjacent LDS, Orthodox Jewish, and modest-curious Christian segments), beachheading Dearborn → Detroit metro → Chicago → NJ/NY → Houston → Bay Area. The US modest fashion market is large (DinarStandard's *State of the Global Islamic Economy 2024/25* — the 11th edition — reports modest fashion at US$327B in 2023, projected to US$433B by 2028) and the rental category for modestwear is structurally underserved: the only direct competitor found (rentmodestmagnolia.com) has no published pricing, no press coverage, no funding announcements, and gates everything behind a free-trial wall.
- **Keep the SwiftUI POC as the demo;** rebuild the production stack on **Supabase + Stripe Billing + Cloudflare R2/Images + Typesense + PostHog + Postmark/Klaviyo + Shippo + ShipBob (Phase 2) + Tide Cleaners/Zips for dry cleaning**. Reasoning per choice in the development plan.
- **Bootstrap to ~1,500 active subscribers** (≈$1.9M ARR at $129 blended ARPU) before raising any equity. Then raise a **$2.5–$3.5M seed** from a coalition of (a) Muslim-founder-friendly capital — the Affinis Labs / Elixir Capital / MAVCAP $250M fund explicitly targeting the global Islamic Economy (per Salaam Gateway), Hijra Capital, and Lightship Capital, which already backed Haute Hijab — plus (b) consumer/marketplace generalists FJ Labs, Craft Ventures, and FirstMark Capital (Pickle's backers per Fortune, March 12, 2025).

## What's in this document

1. **[Development Plan](./development-plan.md)** — five phases, files/modules per phase, tech-stack decisions with rationale, Claude Code prompts to execute each step, testing/CI strategy.
2. **[Business Plan](./business-plan.md)** — investor-grade: market sizing with DinarStandard/Pew/ISPU citations; ICPs across Muslim, LDS, Orthodox Jewish, conservative Christian, modest-curious secular; competitive landscape (RTR, Nuuly, Pickle, Armoire, Haverdash, Le Tote post-mortem, Modest Magnolia, Modanisa, Haute Hijab, INAYAH, Aab, Sweet Salt, Mikarose, Dainty Jewell's); unit economics; operations; GTM with specific named influencers/markets; 36-month projections; funding strategy with Shariah considerations; legal/regulatory; brand/positioning.
3. **[Claude Code Prompts Library](./claude-code-prompts.md)** — 25 ready-to-paste prompts covering backend, auth, payments, photography, App Store, push, deep linking, ATT, design system v2, accessibility, performance, Arabic RTL i18n, and more.

## Founder context assumptions (labeled as assumptions)

- Founder is based in **Plymouth, MI** — Dearborn is a 15-min drive and is the densest Arab/Muslim community in the US (the 2020 Census recorded 54.5% Middle Eastern/North African ancestry in Dearborn; in a 2023 survey the city flipped to MENA-majority — Dearborn is described in *The Conversation*'s 2023 piece as "the first Arab-American majority city in the US").
- Founder wants the business to be at minimum *Shariah-aware* (no riba in funding, no haram products, low gharar in contracts) and will likely brand around values without seeking formal AAOIFI certification at MVP — recommended path in the Business Plan.
- Founder has a working SwiftUI POC (iOS 17+, "Modesty DNA" 5-axis preference engine, 24 mock products across 8 brands, 3 plans at $89/$129/$169, JSON persistence, procedural image placeholders) — treated as Phase 0 complete.

## North-Star metric and quarterly OKRs (Year 1)

- **North star:** *Paid Active Subscribers (PAS)* — the only number that gets reported weekly to the team and to investors.
- **Q1 2026:** Phase 1 complete; 50 closed-beta paying subs in Dearborn ZIPs; NPS ≥ 50.
- **Q2 2026:** App Store public launch by 7 days *before* Ramadan (Ramadan 2026 begins evening of Tuesday 17 Feb per Human Relief Foundation and IslamicFinder); 250 paid subs by end of Eid al-Fitr (≈20 Mar 2026).
- **Q3 2026:** 500 paid subs; first full-cycle dry-cleaning SLA validated; ShipBob 3PL onboarded.
- **Q4 2026:** 1,000 paid subs; close pre-seed $400–$750K SAFE; M3 retention ≥70%.

## The single most important decision in this plan

**Launch publicly by January 21, 2026** so that the Ramadan content engine has 4 weeks of pre-warming. Per Rawshot's compiled industry stats, *"searches for 'modest fashion' increase by 500% during the month of Ramadan globally"* — Ramadan is to modest fashion what Q4 is to general retail. Missing this window pushes the next equivalent demand spike to Ramadan 2027.

---

## Recommendations (decision-ready)

Numbered for execution against a calendar that ends at January 21, 2026.

1. **By Day 7** — Set up the Delaware C-corp; reserve `coveredcollection.com` (verify it's owned), `@coveredcollection` social handles, the App Store name. Run a USPTO TESS search for "Covered Collection" in IC 025 and IC 035; if clean, file 1(b) intent-to-use in both classes (~$1,500 in filing fees).
2. **By Day 14** — Mystery-shop Modest Magnolia (rentmodestmagnolia.com): sign up, photograph everything, document pricing tiers, brand list, garment quality, packaging, return SLA. This is the single most-leveraged piece of competitive intelligence you can gather. Without it you are over- or under-pricing by guess.
3. **By Day 21** — Execute Prompts 1–3 (Supabase, Apple Sign In, Stripe). Stand up the Dev environment.
4. **By Day 45** — Phase 1 complete; 50 beta subscribers in Dearborn ZIP codes 48124/48126/48128. Recruit through 5 micro-influencers at $250–$500 each plus your first ICA bulletin partnership.
5. **By Day 60** — Lease a 2,500–4,000 sq ft Dearborn or Livonia warehouse; build first SOPs; sign master agreement with Tide or Zips at $4.50–$6.50/garment.
6. **By Day 90** — Open the public Dearborn waitlist. Drive 3,000 signups via the "Founding 50" influencer cohort + ISNA-list direct email.
7. **By Day 110** — File **App Store submission** with Apple Review notes explicitly citing Guideline 3.1.3(e); plan for 2 rejection cycles.
8. **By January 21, 2026** — **Public launch.** Ramadan content engine pre-warms for 4 weeks. Eid (March 19–21) is the cash-conversion moment.
9. **By April 2026** — Hit 500 paid subs; close the **pre-seed $400–$750K SAFE** (warm-intro into Affinis Labs, Lightship Capital, Backstage Capital).
10. **By M9 (post-Ramadan 2026)** — Hit 1,000 paid subs; begin building the seed deck around proven Dearborn LTV/CAC.
11. **By M18 (Ramadan 2027)** — Raise the **$2.5–$3.5M seed**; expand to Chicago, NJ, and Houston; onboard ShipBob for distributed fulfillment; begin Phase 4 (AI styling, family plans, B2B/events).
12. **By M36** — At $10.1M ARR and ≥5% net margin, open conversations with strategic acquirers (URBN, RTR) and international strategics (Modanisa, Mayhoola).

**Triggers that change these recommendations:**

- If Phase 1 churn after 3 months exceeds 10%, **stop adding marketing spend** and run a fit-and-modesty-match diagnostic before any further growth investment.
- If Modest Magnolia's pricing comes in below $59/mo with national footprint, **drop Core to $79 and lead with curation depth** as the differentiator.
- If Ramadan 2026 demand is >3× plan, **pause new subscriber acquisition** to protect retention; backlog the excess for the post-Eid window.
- If Stripe issues a notice of concern (chargebacks >0.5%), **immediately migrate to Adyen as a parallel processor** and run both for 90 days.
- If a Muslim-American backlash event occurs around the brand, **stand down all paid media for 72 hours, issue a founder-voice IG Reel addressing it directly, and convene the Shariah Advisory Board** before resuming.

## Caveats and known limitations

1. **Modest Magnolia** intelligence is incomplete. The competitor's website gates everything behind a free-trial wall and there is no press, funding announcement, Crunchbase entry, or founder identifiable. **A mystery-shopper signup before any pricing-strategy commitment is mandatory.**
2. **TAM/SAM/SOM** is founder-grade; no published reports specifically size US modest-rental. The $9M Year-3 SOM is a directional anchor, not a forecast commitment.
3. **Influencer rates** are general-market benchmarks (Hootsuite, Shopify, Influencer Marketing Hub); no published rate card specifically for hijabi creators exists. Plan to A/B test 5 micro-creator deals at $1.5K each in Q1 to establish actual ROAS.
4. **Stripe-on-rental** has worked for RTR, Nuuly, Stitch Fix, and Pickle for years; structural risk is low. Risk only materializes if chargebacks rise above 0.65–0.75%.
5. **Formal Shariah certification** is deferred deliberately. AAOIFI compliance is meaningful for Islamic banks, not consumer apparel; community trust will come from the Shariah Advisory Board, the Zakat commitment, and the founder's voice, not a paper certificate.
6. **Financial projections** are deterministic. Before pitching seed, build a Monte Carlo with churn, ARPU, and CAC as stochastic dimensions.
7. **Hoda Katebi** appears in mainstream "modest fashion influencer" lists but per her own website rejects fashion brand sponsorships. Reaching out for paid partnership will damage authenticity; engage only as an ops-side garment-quality consultant.
8. **Dina Tokio** is internationally famous but no longer wears hijab and is polarizing; do not use her in launch marketing.
9. **iOS-first** is correct for the demographic but build an Android app by Month 18 to capture the LDS Utah segment, which skews more Android than the US Muslim segment.
10. **Ramadan 2026 (Feb 17 – Mar 21)** is the single most important launch window. Every milestone is back-calculated from a "live with Ramadan campaign by January 21 2026" cadence. If that slips, defer to **Eid al-Adha** in late May 2026 rather than launching cold in April.
11. **Roolee's revenue** is reported variably across third-party aggregators — LeadIQ ~$15M (Oct 2024), Zippia peak $19M (2023–2024), RocketReach $6.6M. The truth is somewhere in the $10–18M range; the point for our purposes is "single-state, single-channel modest brand at meaningful scale" — which is true regardless of which estimate you trust.
12. **Pew demographics caveat:** the most-cited "3.45M US Muslims" figure is from Pew's January 3, 2018 short-read and covers all ages as of 2017. Pew's 2023–24 Religious Landscape Study reports Muslims at 1.2% of US adults (n=36,908, published February 2025). These are not interchangeable; use the appropriate one for the appropriate sentence.
13. **Nuuly figures:** the 300,000 subscriber count is *ending* (at January 31, 2025), not average; FY25 operating profit was $13M per Digital Commerce 360's coverage of URBN's February 26, 2025 earnings.
14. **Pickle Series A:** $12M co-led by FirstMark + Craft Ventures with **Burst Capital and FJ Labs participating** (Fortune, March 12, 2025); total raised $20M. The earlier seed in October 2023 was $8M, also co-led by Craft and FirstMark.
15. **The Modesty DNA engine** is a positioning-strong but UX-tricky construct — at quiz time, customers will not always know the words "neckline," "opacity," or "silhouette." Plan to A/B test a visually-driven Tinder-style swipe alternative in Phase 3 alongside the current slider-based quiz.
