# The Covered Collection — Rename Guide

## 1. Rename the source folder

```bash
mv LaylaAndCo CoveredCollection
```

## 2. Rename colorset folders inside Assets.xcassets/Colors/

```bash
cd CoveredCollection/Resources/Assets.xcassets/Colors

mv LaylaCream.colorset   CoveredCream.colorset
mv LaylaSurface.colorset CoveredSurface.colorset
mv LaylaOlive.colorset   CoveredOlive.colorset
mv LaylaGold.colorset    CoveredGold.colorset
mv LaylaRose.colorset    CoveredRose.colorset
mv LaylaInk.colorset     CoveredInk.colorset
mv LaylaMuted.colorset   CoveredMuted.colorset
mv LaylaBorder.colorset  CoveredBorder.colorset
mv LaylaSuccess.colorset CoveredSuccess.colorset
mv LaylaTagBg.colorset   CoveredTagBg.colorset
```

## 3. Replace Swift files

Copy every `.swift` file from this refactor package into the matching path
under `CoveredCollection/`. The folder structure is identical to the
original — only the root folder name changes (LaylaAndCo → CoveredCollection).

Key renames (old filename → new filename):
- LaylaAndCoApp.swift       → CoveredCollectionApp.swift
- LaylaButton.swift         → CoveredButton.swift
- LaylaCard.swift           → CoveredCard.swift
- LaylaTag.swift            → CoveredTag.swift
- LaylaBadge.swift          → CoveredBadge.swift

All other Swift filenames stay the same; only the content inside changes.

## 4. Regenerate the Xcode project

```bash
xcodegen generate
open CoveredCollection.xcodeproj
```

## 5. Files that are UNCHANGED and need no edits

These have no Layla references and can be copied as-is:
- All model files (Product.swift, ModestyDNA.swift, SubscriptionPlan.swift,
  CalendarEvent.swift, UserProfile.swift, MockData.swift)
- All route enums (ClosetRoute, AccountRoute, CalendarRoute, MyBoxRoute, PlansRoute)
- All persistence files (PersistenceManager.swift, UserProfileStore.swift,
  ProductRepository.swift)
- OnboardingViewModel.swift
- ClosetViewModel.swift
- AppTabSelection.swift
- AppTabSelection.swift
- .gitignore
