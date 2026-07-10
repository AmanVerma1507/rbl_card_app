# Project: RBL Bank Card Home Screen (Flutter UI Assignment)

This file is the single source of truth for this project. Read this fully before writing any code.

## Context
This is a take-home Flutter assignment for a job application. Deadline: 2 days. The goal is
to replicate a CRED-style "Card Home" screen — pixel-perfect UI + smooth animations — using
Clean Architecture and BLoC. Assets referenced below are provided by the developer (Aman) in
`design_assets/` (or wherever he places them) — ask him for exact file paths if not found.

---

## 1. Screen Overview (from design assets + reference video analysis)

The screen is a **bank card management home screen**, similar to CRED app's card dashboard.
Reference video shows a real screen recording of the actual reference app (Federal Bank
Scapia card app) being used — replicate the same layout/behavior but reskin with RBL Bank
branding using the provided card art (Gold, Green/Privilege, Maroon/Travel variants — Visa,
RBL Bank logo, chip, contactless icon).

### Layout structure (top to bottom):
1. **Top app bar**: back arrow (left), "More actions" text button with chevron (right)
2. **Card carousel** (hero element):
   - Horizontal `PageView`-style carousel of credit cards
   - Currently-selected card is centered/full-size; adjacent cards **peek from left/right
     edges**, partially cut off, slightly scaled down and dimmed (parallax/depth effect)
   - Cards included: RBL Gold card, RBL Green (Privilege) card, RBL Maroon (Travel) card,
     plus a **"+ Add card" placeholder card** (dark rounded rect with centered "+" icon) at
     the end of the carousel
   - Swiping horizontally transitions between cards with scale + opacity animation on the
     side cards (not a flat instant swap)
3. **Bottom mini-card tab strip**: small thumbnail versions of each card in a horizontal
   row (acts as both an indicator and a tap-to-jump control), positioned near the bottom of
   the screen, above the sticky footer
4. **Dynamic content area below the card** — changes based on which card is selected:
   - Status row: e.g. "● BILL PAID" (green dot) or "● BILL OVERDUE BY 3 DAYS" (red dot)
   - Info card: "Next bill expected on [date]" + "Pay early" button, OR "Total due ₹[amount]"
     + "Pay now" button (red/filled CTA)
   - Promo banner card: rounded card with left text ("Turn your next bill payment to
     [rewards] coins" style copy) + right-side circular icon/illustration
   - This entire block should **cross-fade / transition** when switching cards (not just
     instantly swap content)
5. **Scroll-reveal section**: on scrolling down, an additional card fades/slides in —
   e.g. "Want to track, analyse and spend smarter? We're setting this up, check back next
   billing cycle" with a bar-chart style illustration
6. **Offers / rewards section** (uses the brand + category assets provided):
   - Category icons in rounded squares: grocery (POS machine + veggies basket), travel
     (airplane silhouette against sunset), gym (interior shot), spa (glass pavilion in
     forest), golf (club + ball on grass)
   - Brand logo row: Netflix, Myntra, Amazon, Flipkart (circular badges in a horizontal row)
   - A cashback/offer badge icon: dark card with green "%" badge — used as a section icon
     or promo tile
   - Lifestyle banner images (two people in red-toned fashion shot, iPhone product shot) —
     likely used as larger promotional tiles within this offers section (treat as generic
     promotional banner slots — use placeholder/mock images if actual assets unavailable)
7. **Sticky bottom bar**: "Total bill due in [N] card(s) · ₹[amount]" — thin bar pinned to
   bottom, sits above the mini-card tab strip or combined with it (verify against video)

### Animation requirements (from reference video, 60fps target):
- Card carousel: swipe gesture → adjacent cards scale (~0.85-0.9x) + reduce opacity
  (~0.6-0.7) + partial clip at screen edges; selected card animates to full scale/opacity.
  Use `PageView` with a custom `viewportFraction` (~0.8) + `AnimatedBuilder`/`Transform` on
  scroll offset, NOT a simple `PageView.builder` with default transitions.
- Content-below-card block: `AnimatedSwitcher` or explicit `TweenAnimationBuilder` for
  cross-fade + slight slide when card selection changes.
- Scroll-reveal card: appears via fade + slide-up as it enters viewport (use
  `NotificationListener<ScrollNotification>` + `AnimatedOpacity`/`AnimatedSlide`, or a
  visibility-detection approach). Keep duration ~250-400ms, ease-out curve.
- All animations should target 60fps — avoid rebuilding the whole tree on every frame; wrap
  independently-animating regions in `RepaintBoundary`.

---

## 2. Technical Requirements (from official assignment PDF)

### Architecture
- **Clean Architecture**: separate `data/`, `domain/`, `presentation/` layers per feature.
  - `domain/`: entities, repository interfaces, use cases
  - `data/`: models (freezed/json_serializable if used), repository implementations,
    data sources (mock/local for this assignment — no real backend)
  - `presentation/`: BLoC (events/states/bloc), widgets, pages

### State Management — BLoC
- Proper separation of **Events**, **States**, and business logic — no business logic inside
  widgets.
- Suggested BLoCs:
  - `CardCarouselBloc` — holds list of cards, currently selected index, exposes
    `CardSelected` event → emits state with selected card + derived bill-status data
  - Optionally a separate `OffersBloc` if offers data is treated as async-loaded (can also
    just be static/mock data passed via repository — keep it simple, don't over-engineer for
    a 2-day assignment)
- States must be predictable/testable — model as sealed classes / freezed unions
  (e.g. `CardCarouselInitial`, `CardCarouselLoaded(cards, selectedIndex)`).

### Dependency Injection
- Use **GetIt** (+ optionally `injectable` for codegen) to register repositories, use cases,
  and blocs.
- No direct instantiation of services/repos inside widgets — always resolve via `GetIt`
  (typically injected into BLoC via constructor, BLoC provided via `BlocProvider` reading
  from `GetIt`).

### Performance
- `const` constructors wherever possible.
- Avoid unnecessary rebuilds — scope `BlocBuilder`/`BlocSelector` narrowly, don't wrap whole
  page in one giant builder.
- `RepaintBoundary` around the card carousel and any independently-animating widgets.
- Proper image handling: use `Image.asset`/`CachedNetworkImage` with explicit sizing,
  `cacheWidth`/`cacheHeight` for large card art to avoid decoding oversized bitmaps.

### Responsiveness
- Support portrait AND landscape.
- Handle different screen sizes (phone + tablet) — use `LayoutBuilder`/`MediaQuery`-based
  sizing, avoid hardcoded pixel values for card dimensions; use relative/aspect-ratio-based
  sizing (credit cards have a fixed real-world aspect ratio ~1.586:1 — preserve it).
- Consistent look on Android and iOS (avoid platform-specific widgets unless intentional).

---

## 3. Deliverables (per assignment PDF)
1. GitHub repository link
2. APK/IPA (optional — IPA only if Mac/simulator available)
3. Demo video (UI + animation behavior + responsiveness)
4. README documentation (architecture explanation, how to run, folder structure, what's
   mocked vs real)

---

## 4. Working Agreement / Notes for Claude Code
- Prioritize getting the **card carousel + peek/parallax animation** right first — it's the
  centerpiece and the highest-risk item for time overrun.
- Use **mock/local data source** in `data/` layer (hardcoded list of card entities + offers)
  — no real API needed for this assignment.
- Keep BLoC scope minimal and clean rather than over-abstracted — this is a 2-day assignment,
  reviewers are checking for correct pattern usage and readable code, not enterprise scale.
- Ask Aman before assuming exact colors/hex values — extract from provided card art assets
  if pixel-accurate matching is required; otherwise use reasonable close approximations
  (Gold: amber/mustard gradient, Green: deep forest green, Maroon: deep maroon/wine).
- If a required asset (e.g. actual RBL card PNGs, brand logos) isn't present in the Flutter
  project's `assets/` folder yet, flag it clearly and ask rather than silently using a
  placeholder that could break "pixel-perfect" grading.
- Target platforms: Android first (primary), iOS if Mac available (see project owner's
  environment before assuming iOS build/test is possible).
