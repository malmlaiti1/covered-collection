# Covered Collection — Test Plan

Full-coverage test plan for the SwiftUI POC. Organized by layer, with a manual QA matrix at the end. Targets are XCTest + XCUITest; snapshot coverage via `swift-snapshot-testing`; accessibility via `XCUIElement.isAccessibilityElement` assertions and the Accessibility Inspector audit.

## 0. Test targets to add

| Target | Type | Scope |
|---|---|---|
| `CoveredCollectionTests` | Unit (XCTest) | Models, Stores, ViewModels, Utilities |
| `CoveredCollectionSnapshotTests` | Snapshot | All design-system components + every screen at iPhone 12/15 Pro Max/SE |
| `CoveredCollectionUITests` | UI (XCUITest) | End-to-end flows, deep links, accessibility |
| `CoveredCollectionPerfTests` | Performance | Cold/hot launch, scroll FPS, image decode |

## 1. Coverage targets

| Layer | Line coverage target | Branch coverage target |
|---|---|---|
| Models | 100% | 100% |
| Stores | 95% | 90% |
| ViewModels | 95% | 90% |
| Utilities | 90% | 85% |
| Feature views (logic-bearing) | 80% | 75% |
| Pure design-system views | snapshot-only | n/a |

Enforced via `xcodebuild` with `-enableCodeCoverage YES` and a CI gate that fails PRs below threshold.

---

## 2. Unit tests — Models

### 2.1 `ModestyDNA`
- Default `aminaDefault` initializes all five axes and tags set.
- `Codable` round-trip preserves every axis enum case.
- Every `Axis.displayName` returns non-empty.
- `optionalTags` set deduplicates duplicates.
- Equality is value-based across instances.

### 2.2 `Product`
- `Codable` round-trip preserves all fields including the optional `image_keys`.
- `id` uniqueness asserted across `MockData.products` (24 unique UUIDs).
- `modestyDNA` on every mock product is internally consistent (no axis enum out-of-range).

### 2.3 `SubscriptionPlan`
- All three plans ($89/$129/$169) parse from mock JSON.
- `pricePerMonth` is positive.
- Codable round-trip.

### 2.4 `CalendarEvent`
- Event date sorting is chronological.
- Date math: `daysUntil(.now)` is correct for known fixtures.
- Codable round-trip.

### 2.5 `UserProfile`
- Default profile has `firstName == "Amina"`, no plan, empty sets/arrays.
- Codable round-trip preserves Set<UUID> ordering invariance.
- Mutations to `savedProducts` do not mutate `queue`.

### 2.6 `CancellationReason` / `SubscriptionStatus` / `CounterOffer`
- All five reason cases have a non-empty `displayName`.
- `SubscriptionStatus` transitions documented; round-trip via `Codable`.
- `CounterOffer.id` is unique per case; `headline`/`subhead` non-empty.

---

## 3. Unit tests — Stores

### 3.1 `UserProfileStore`
- `bootstrap()` with no persisted file leaves profile at default.
- `bootstrap()` with persisted file restores values.
- `toggleSaved(_:)` adds when absent, removes when present.
- `addToQueue(_:)` is idempotent (does not double-add).
- `setCurrentPlan(_:)` updates `profile.currentPlan` and persists.
- `completeOnboarding(profile:)` sets `UserDefaults.hasCompletedOnboarding = true`.
- `persist()` debounces; multiple rapid mutations result in a single write within a 100ms window (verify via mocked `PersistenceManager`).
- Persistence failure does not crash; profile remains in-memory consistent.

### 3.2 `UserProfileStore` cancel-flow extension
- `pauseSubscription(days:)` sets `pausedUntil` to `Date() + days` and status to `.paused`.
- `cancelSubscription(reason:)` sets status `.cancelled` and stores reason.
- `applyCoreDowngrade()` flips `currentPlan` to Core ($89) and keeps status `.active`.
- `resumeSubscription()` clears `pausedUntil`, sets status `.active`.
- `recordCounterOfferAccepted(_:)` logs analytics event (verify via test double).

### 3.3 `ThemeStore`
- Singleton identity preserved across access.
- `accent` change is observable (`@Observable` triggers SwiftUI rebuilds — verify via `withObservationTracking`).
- Accent persists across cold start.

### 3.4 `DevModeStore`
- `authenticate(username:password:)` with `dev` / `Nanoose2!` returns true and enables mode.
- Wrong username returns false.
- Wrong password returns false.
- Empty credentials return false.
- `logout()` clears `devModeEnabled`.
- Credentials check is constant-time (no timing leak on length).

### 3.5 `AppTabSelection`
- Default tab is `.closet`.
- Setting `selected` notifies observers.

### 3.6 `PersistenceManager`
- `saveUserProfile(_:)` writes a parseable JSON file to the documents directory.
- `loadUserProfile()` returns nil when file absent.
- `loadUserProfile()` returns decoded profile when file present.
- `deleteUserProfile()` removes the file.
- Concurrent saves do not corrupt the file (run 100 parallel writes; final read decodes cleanly).
- Encoding/decoding errors are surfaced as throws, not silent.

---

## 4. Unit tests — ViewModels

### 4.1 `OnboardingViewModel`
- Initial step is the first axis.
- `advance()` moves to next step; on last step, finalizes profile.
- `back()` no-ops on first step.
- Selecting an axis value updates `draft.modestyDNA.<axis>`.
- Toggling a tag adds/removes it from `optionalTags`.
- `complete()` calls `store.completeOnboarding(profile:)` with the assembled draft.

### 4.2 `ClosetViewModel`
- Initial product list equals `MockData.products`.
- Filter by axis returns only products matching all five DNA axes.
- Filter by tag is intersected with axis filter.
- Search query "abaya" matches case-insensitively.
- Empty filter results return an empty array (not nil).
- Sorting by `featured` is stable (same order across calls).

### 4.3 `DevUploadViewModel`
- Adding an image appends to the pending list.
- Removing an image at index removes the right one.
- Submitting with 0 images is rejected.
- Submitting writes assets to the asset-catalog imageset directory (mock filesystem).
- Errors surface to a `lastError` published property.

---

## 5. Unit tests — Utilities

### 5.1 `Formatters`
- Price formatter outputs `$89` for `89`, `$1,234` for `1234`.
- Date formatter outputs "Mar 19, 2026" for fixed date.
- Locale switching produces RTL-correct strings for `ar`.

### 5.2 `ProceduralImage`
- Generates a non-nil UIImage for any seed.
- Same seed → identical image bytes (deterministic).
- Different seeds → different images (≥1% byte delta).

### 5.3 `ImagePickerWrapper`
- Coordinator forwards `didFinishPicking` to the completion handler.
- Cancellation calls the completion with nil.

---

## 6. Feature tests — logic-bearing views

For each feature view, assert: render does not crash, key elements exist, taps fire the expected store mutation.

### 6.1 `LoginView`
- Empty username/password disables "Sign In".
- `dev` / `Nanoose2!` enables dev mode AND sets `isSignedIn = true`.
- Any other non-empty creds sets `isSignedIn = true`, does NOT enable dev mode.
- `#if DEBUG` developer hint string is present in DEBUG builds, absent in RELEASE.

### 6.2 `ModestyDNAOnboardingView`
- Five axis steps are presented in order: Neckline → Sleeve → Hem → Opacity → Silhouette.
- Tags step follows axes.
- Success step is final.
- Skip button (if any) is gated by feature flag.

### 6.3 `ClosetView`
- Renders 24 product cards on first paint.
- Tapping a card pushes `ClosetRoute.productDetail(id)`.
- Filter chip selection updates the visible grid.
- Empty-filter result shows `EmptyStateView`.

### 6.4 `ProductDetailView`
- Renders product name, brand, price, modesty DNA tags.
- "Save" toggles `store.profile.savedProducts` membership.
- "Add to box" calls `store.addToQueue(id)`.
- Out-of-stock state disables "Add to box".

### 6.5 `MyBoxView`
- Empty box shows `EmptyStateView` with "Browse the closet" CTA.
- Non-empty box renders one row per UUID in `profile.currentBox`.
- Swipe-to-delete removes the item.

### 6.6 `SavedView`
- Renders all UUIDs in `profile.savedProducts`.
- Tapping a saved item routes to product detail.
- Unsaving from detail removes from list on return.

### 6.7 `PlansView`
- Renders 3 plan cards.
- Selection binding propagates.
- Primary CTA calls the completion handler.

### 6.8 `OccasionCalendarView`
- Lists `MockData.events` in chronological order.
- Renders the "days until" indicator.
- Tapping an event pushes the route.

### 6.9 `AccountView`
- Renders profile, DNA, plan, preferences, theme, support cards.
- "Sign out" presents confirmation dialog; confirming sets `isSignedIn = false`.
- Theme picker swatches: tapping each changes `theme.accent`.
- "Cancel subscription" row presents `CancelFlowView` as a sheet.
- DEBUG build shows `devCard`; RELEASE does not.

### 6.10 Cancel flow
- Step 1: tapping each of the 5 reasons selects it; "Continue" disabled until a selection exists.
- Step 2 — Price → shows discounted-month offer.
- Step 2 — No time / Frequency → shows pause offer with 30/60/90 chips.
- Step 2 — Fit / Other → shows downgrade-to-Core offer.
- Accepting an offer: dismisses flow, sets `pausedUntil` OR `currentPlan = Core` OR records discount.
- Declining advances to Step 3.
- Step 3 confirmation: tapping "Cancel my subscription" sets status `.cancelled` and dismisses.
- "Keep my subscription" pops back to Account without state change.
- Each step transition fires an analytics event (mocked).

### 6.11 `DevUploadView`
- Hidden unless `DevModeStore.shared.devModeEnabled == true`.
- Picker integration: selecting 3 photos populates pending list with 3 entries.
- "Save to assets" writes files to the expected imageset directories.

---

## 7. Navigation tests

For each `Route` enum (`AccountRoute`, `CalendarRoute`, `ClosetRoute`, `MyBoxRoute`):
- Every case decodes from its associated value without loss.
- Path push/pop preserves order (round-trip via `NavigationPath`).
- Deep link `coveredcollection://product/{uuid}` resolves to `ClosetRoute.productDetail`.

---

## 8. Snapshot tests

For each device class (iPhone SE 3, iPhone 15, iPhone 15 Pro Max) and color scheme (light only — POC has no dark mode):

- LoginView (empty, populated, dev creds entered)
- Each onboarding step (5 axis steps + tags + success)
- ClosetView (full, filtered, empty)
- ProductDetailView (in-stock, saved, out-of-stock)
- MyBoxView (empty, 3 items)
- SavedView (empty, 8 items)
- PlansView (no selection, Core selected, Curator selected, Edit selected)
- OccasionCalendarView
- AccountView (no plan, Core plan, paused, cancelled)
- CancelFlowView (each of 3 steps × each reason × each offer variant)
- All design-system components (Button × variants, Card, Badge, Tag, ProductCard sizes, ModestyDNABadgeRow)

Re-record fails the build until intentionally regenerated.

---

## 9. UI tests (XCUITest)

End-to-end happy paths and key sad paths.

### 9.1 First-launch flow
1. Cold launch → LoginView visible.
2. Enter regular creds → MainTabView appears with `closet` tab selected.
3. Closet shows ≥1 product card.

### 9.2 Onboarding flow
1. Cold launch, sign in, no prior onboarding.
2. ModestyDNAOnboardingView appears.
3. Pick a value on each of 5 axis steps + 2 tags.
4. Final "Success" step → tapping "Build your closet" enters MainTabView.
5. AccountView shows the chosen DNA values.

### 9.3 Build-a-box
1. Closet → tap product → "Add to box".
2. Switch to MyBox tab → product appears.
3. Swipe to delete → product gone.

### 9.4 Save/unsave
1. Closet → tap product → tap "Save".
2. Navigate to Account → Saved items → product appears.
3. Unsave from list → list empties.

### 9.5 Plan selection
1. Account → My Plan → choose Curator → "Update plan".
2. Account shows "Curator" as current.

### 9.6 Cancel-flow happy paths (×3)
- Price → accept $59 month → status remains active, discount recorded.
- No time → pause 60 days → AccountView shows "Paused until {date}".
- Fit → decline downgrade → confirm cancel → status `.cancelled`.

### 9.7 Cancel-flow back navigation
- At Step 2, tap "Back" → Step 1 selection retained.
- At Step 3, tap "Keep my subscription" → flow dismisses, status unchanged.

### 9.8 Sign-out
- Account → Sign out → confirm → LoginView reappears.
- Cold launch after sign-out lands on LoginView (state persisted).

### 9.9 Dev mode (DEBUG only)
- Login with `dev` / `Nanoose2!` → MainTabView shows Upload tab.
- Wrong dev password → upload tab absent.
- Sign out → dev mode cleared.

### 9.10 Theme switching
- Account → tap each accent swatch → primary buttons in Closet update color within one frame.

### 9.11 Negative paths
- Submit empty Login → button disabled.
- Add to box when offline (airplane mode) — fallback message (when backend lands).

---

## 10. Accessibility tests

Run on every screen via XCUITest + Accessibility Inspector audit:

- Every interactive element has a non-empty `accessibilityLabel`.
- Tap targets are ≥44×44pt (assert via `frame.size`).
- Text contrast ≥4.5:1 against background (audit pre-merge for the design system palette).
- VoiceOver reads onboarding axis sliders in axis-name + value form ("Neckline, modest").
- Dynamic Type: layouts do not clip at `.accessibility3` and `.accessibility5`.
- RTL: when `Locale` is `ar`, every leading constraint flips to trailing (verify on 5 representative screens once i18n lands).

---

## 11. Performance tests

Baseline device: iPhone 12, iOS 17.

| Metric | Budget | Test |
|---|---|---|
| Cold launch to LoginView | < 1.8s | `XCTOSSignpostMetric.applicationLaunch` |
| Hot launch | < 0.4s | XCTApplicationLaunchMetric |
| Closet scroll FPS | 58–60 | `XCTOSSignpostMetric` over a scripted scroll |
| Image decode (one card) | < 16ms | OSSignpost in ProductImageView |
| Filter recompute on 24 products | < 5ms | unit-test microbenchmark |
| Persist user profile | < 30ms | unit-test microbenchmark |

Add `os_signpost` regions in: app launch, onboarding completion, closet first paint, filter apply, box add, cancel flow step transitions.

---

## 12. Property-based / fuzz tests

Use a lightweight property-checker (e.g., SwiftCheck or hand-rolled).

- For 1,000 random `ModestyDNA` values: encode → decode equals original.
- For 1,000 random `UserProfile`s: persist → load equals original.
- For random filter inputs over the 24-product set: `count(filtered) ≤ count(total)`; `filtered ⊆ total`.
- Cancel-flow state machine: from any state, any allowed transition lands in a valid state (no nil dereferences).

---

## 13. Security & data tests

- Keychain — Apple Sign In credential storage round-trip (once Prompt 2 lands).
- Defaults — no PII written to `UserDefaults` other than the documented flags (`isSignedIn`, `hasCompletedOnboarding`, accent).
- Logs — `print()` and `os.Logger` calls do not emit passwords, payment tokens, or email addresses (grep test on source + dynamic log capture).
- File permissions — persisted profile file is in the app sandbox, not iCloud-shared.
- Dev creds — fail-closed: any non-DEBUG build with `DevModeStore` enable attempt returns false (compile-time guard test).

---

## 14. CI gates

`xcodebuild test` in GitHub Actions on every PR:

1. Build for `iOS Simulator, iPhone 15, OS 17.5`.
2. Run all four test targets.
3. Enforce coverage thresholds from §1 (`xccov` parser, fail if below).
4. Snapshot diff: fail if any snapshot mismatch.
5. Lint: `swiftlint` strict mode.
6. Static analysis: `xcodebuild analyze` clean.

Nightly extended run:
- Add iPhone SE 3 and iPhone 15 Pro Max simulators.
- Run perf suite, post results to a Slack channel.

---

## 15. Manual QA matrix

Run before each App Store submission. One signature required per row.

| Area | Test | Pass criteria |
|---|---|---|
| Login | Sign in flow | LoginView → MainTabView |
| Login | Sign out flow | MainTabView → LoginView |
| Login | Dev login (DEBUG) | Upload tab visible |
| Onboarding | Fresh install | All 5 axis steps + tags + success render |
| Onboarding | Resume after kill | Skips onboarding once completed |
| Closet | First paint | 24 cards visible, no broken images |
| Closet | Filter | Filter chip narrows results, empty state on no match |
| Product detail | Save/unsave | Heart state correct on re-entry |
| Product detail | Add to box | Appears in MyBox tab |
| MyBox | Remove item | Swipe deletes |
| Plans | Change plan | AccountView reflects new plan |
| Calendar | Event ordering | Chronological |
| Account | Theme picker | Closet primary buttons update |
| Cancel | Each reason × each offer | All branches reachable; state mutations correct |
| Persistence | Kill + relaunch | Profile, plan, theme, sign-in all restored |
| Persistence | Delete + reinstall | Clean state on first open |
| Accessibility | VoiceOver walk-through | All elements announced meaningfully |
| Accessibility | Dynamic Type | No clipping at AX5 |
| Performance | Cold launch | Subjective: under 2s on iPhone 12 |
| RTL (once shipped) | `ar` locale | Layout flips, text reads RTL |

---

## 16. Test data fixtures

- `Tests/Fixtures/products_24.json` — frozen copy of mock product set.
- `Tests/Fixtures/profile_default.json`, `profile_paused.json`, `profile_cancelled.json`, `profile_full_box.json`.
- `Tests/Fixtures/events_2026.json` — frozen religious-calendar events.
- `Tests/Fixtures/snapshots/` — recorded snapshot baselines, committed to repo.

Re-record fixtures only when the corresponding model intentionally changes; coordinate with a code-owner approval in the PR.

---

## 17. Out of scope (deferred until backend lands)

- Supabase auth + session refresh tests
- Stripe PaymentSheet integration tests
- Cloudflare image-URL builder integration
- Push-notification scheduling tests
- Real network flake & offline-replay tests
- ATT consent flow tests

These join the suite as their respective prompts (1, 2, 3, 4, 6, 7) ship.
