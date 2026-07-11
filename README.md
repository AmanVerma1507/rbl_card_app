# RBL Card Home — Flutter UI Assignment

> A CRED-style credit card dashboard built with **Flutter**, implementing pixel-perfect UI, smooth animations, Clean Architecture, BLoC state management, and GetIt dependency injection.

---

## 📱 Screenshots

| Android |
|:---:|
| *(See `assets/` folder for design reference screenshots)* |

---

## 🎬 Demo Video

> A short demo video showcasing UI implementation, animations, and responsiveness is included in the submission.

---

## ✨ Features

- **CRED-style card carousel** with fan/stack swipe animations
- **Sticky bottom bill bar** that reveals on scroll
- **Scroll-reveal cards** for offers and cashback sections
- **Smooth curved notch bottom sheet** with custom `CustomClipper`
- **Dot indicator** synced with carousel page position
- **Thumbnail strip** for quick card switching
- **Edge-to-edge dark UI** with transparent status & navigation bars
- **Portrait and landscape support** via `LayoutBuilder`
- **Consistent behavior** across Android and iOS

---

## 🏗️ Architecture

This project follows **Clean Architecture** principles with a clear separation of concerns across three layers:

```
lib/
├── core/
│   ├── di/               # Dependency Injection (GetIt)
│   │   └── injection.dart
│   ├── theme/            # Design system
│   │   ├── app_colors.dart
│   │   └── app_theme.dart
│   └── utils/
│
└── features/
    └── card_home/
        ├── data/
        │   ├── datasources/      # Local data source
        │   ├── models/           # Data models
        │   └── repositories/     # Repository implementations
        │
        ├── domain/
        │   ├── entities/         # Pure Dart entities
        │   │   ├── credit_card.dart
        │   │   ├── card_benefit.dart
        │   │   └── card_bill_info.dart
        │   ├── repositories/     # Abstract repository contracts
        │   └── usecases/         # Business logic use cases
        │       └── get_cards_usecase.dart
        │
        └── presentation/
            ├── bloc/             # BLoC: Events, States, Bloc
            │   ├── card_carousel_bloc.dart
            │   ├── card_carousel_event.dart
            │   └── card_carousel_state.dart
            ├── pages/
            │   └── card_home_page.dart
            └── widgets/          # Modular UI components
                ├── card_carousel.dart
                ├── card_dot_indicator.dart
                ├── card_info_panel.dart
                ├── card_thumbnail_strip.dart
                ├── cashback_benefits_section.dart
                ├── content_sheet_nozzle.dart
                ├── get_card_cta_button.dart
                ├── offers_section.dart
                ├── scroll_reveal_card.dart
                └── sticky_bill_bar.dart
```

---

## 🧠 State Management — BLoC

State management is handled using the **BLoC pattern** (`flutter_bloc ^9.1.1`):

| File | Responsibility |
|------|---------------|
| `card_carousel_event.dart` | Defines all UI events (e.g., `CardPageChanged`, `CardSelected`) |
| `card_carousel_state.dart` | Immutable state using `Equatable` |
| `card_carousel_bloc.dart` | Pure business logic — no widget references |

**Principles followed:**
- Business logic is fully isolated from widgets
- State transitions are predictable and testable
- All state is immutable (`Equatable`)

---

## 💉 Dependency Injection — GetIt

Dependency Injection is handled via **GetIt** (`get_it ^8.0.3`):

- `injection.dart` registers all services, repositories, use cases, and BLoC factories
- No direct dependency instantiation inside widgets
- All layers are wired through the service locator at app startup via `setupDependencies()`

---

## ⚡ Performance Optimizations

| Practice | Implementation |
|----------|---------------|
| `const` constructors | Applied throughout widget tree wherever possible |
| Minimal rebuilds | `BlocBuilder` with `buildWhen` guards to avoid unnecessary rebuilds |
| Widget tree optimization | Decomposed into focused, single-responsibility widgets |
| `RepaintBoundary` | Applied around the card carousel to isolate repaints |
| Animation efficiency | Uses Flutter's native `AnimationController` + `CurvedAnimation` |
| 60fps animations | Curves tuned (`easeOutCubic`, `elasticOut`) for smooth 60fps rendering |
| Image handling | Assets bundled locally with proper asset declaration in `pubspec.yaml` |
| Icon tree-shaking | MaterialIcons reduced by 99.9% (1.6MB → 1.5KB) via automatic tree-shaking |

---

## 🎨 Animations

| Animation | Technique |
|-----------|-----------|
| Card fan/stack transition | `AnimatedBuilder` + `Transform` with staggered offsets |
| Scroll-reveal cards | `SlideTransition` + `FadeTransition` triggered by `ScrollController` |
| Sticky bill bar | `AnimatedSlide` + `AnimatedOpacity` on scroll threshold |
| Page dot indicator | Animated `Container` width/color transitions |
| Carousel swipe | `PageView` with physics + custom scroll curves |
| Bottom sheet notch | `CustomClipper` with cubic bezier curves |

---

## 📦 Dependencies

```yaml
dependencies:
  flutter_bloc: ^9.1.1      # BLoC state management
  equatable: ^2.0.7         # Value equality for states/events
  get_it: ^8.0.3            # Dependency injection
  intl: ^0.20.2             # Number/currency formatting
  google_fonts: ^6.2.1      # Custom typography

dev_dependencies:
  flutter_lints: ^6.0.0     # Lint rules
  flutter_test              # Unit & widget testing
```

---

## 🚀 Getting Started

### Prerequisites

- Flutter SDK `>=3.12.1`
- Dart SDK `>=3.0.0`
- Android Studio / Xcode (for device/emulator)

### Run the app

```bash
# Clone the repository
git clone <repository-url>
cd assignment_flutter_apk

# Install dependencies
flutter pub get

# Run on connected device / emulator
flutter run

# Build release APK
flutter build apk --release
```

### APK Location (after build)

```
build/app/outputs/flutter-apk/app-release.apk
```

---

## 📁 Project Info

| Property | Value |
|----------|-------|
| App Name | RBL Card Home |
| Package | `rbl_card_home` |
| Version | `1.0.0+1` |
| Flutter SDK | `^3.12.1` |
| Platform | Android, iOS |
| Architecture | Clean Architecture |
| State Management | BLoC |
| DI | GetIt |
| Theme | Dark (Material 3) |

---

## 📋 Submission Checklist

- [x] Pixel-perfect UI matching the design
- [x] Smooth animations (60fps)
- [x] Clean Architecture (Data / Domain / Presentation)
- [x] BLoC pattern (Events, States, Business Logic separated)
- [x] GetIt Dependency Injection
- [x] `const` constructors throughout
- [x] Minimal widget rebuilds
- [x] Portrait + Landscape support
- [x] Edge-to-edge dark UI
- [x] Android build verified
- [ ] GitHub Repository Link *(add link here)*
- [ ] APK *(attach or share link)*
- [ ] Demo Video *(attach or share link)*
