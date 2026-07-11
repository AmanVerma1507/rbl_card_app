import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/theme/app_colors.dart';
import '../bloc/card_carousel_bloc.dart';
import '../bloc/card_carousel_event.dart';
import '../bloc/card_carousel_state.dart';
import '../widgets/card_carousel.dart';
import '../widgets/card_dot_indicator.dart';
import '../widgets/card_info_panel.dart';
import '../widgets/cashback_benefits_section.dart';
import '../widgets/get_card_cta_button.dart';
import '../widgets/offers_section.dart';

/// Root page for the RBL Card Home (Credit Card Offers) screen.
///
/// ── Edge behaviour between card header and content (CONFIRMED spec) ──────
///
///   -------------------V-----------------
///
///   • RESTING (shrinkOffset == 0)   → flat straight edge, notch strip is
///     fully INVISIBLE (opacity 0) — card renders exactly as before, no
///     stray bar/stripe anywhere.
///   • SCROLLING (shrinkOffset > 0)  → notch strip fades in and a smooth
///     curved (U-shape) dip appears at the horizontal center, growing
///     deeper over the first ~30px of scroll, then holding at max depth.
///
/// IMPORTANT (fix for previous regression): the carousel's own
/// [Positioned] constraints are UNTOUCHED from the original — no `bottom`
/// value is set on it, so it fills the same space and scales exactly as
/// before. The notch strip is a separate, independently-positioned overlay
/// painted on top of the carousel's lower edge — it does not steal layout
/// space from the carousel, so the zoom/scale effect is unaffected.
class CardHomePage extends StatefulWidget {
  const CardHomePage({super.key});

  @override
  State<CardHomePage> createState() => _CardHomePageState();
}

class _CardHomePageState extends State<CardHomePage> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<CardCarouselBloc>()..add(const LoadCards()),
      child: Scaffold(
        backgroundColor: AppColors.background,
        extendBody: true,
        body: Stack(
          children: [
            // ── Main scrollable body ─────────────────────────────
            const _ScrollBody(),

            // ── Sticky "Get Your Card" CTA at bottom ─────────────
            const Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: GetCardCtaButton(),
            ),
          ],
        ),
      ),
    );
  }
}

// ────────────────────────────────────────────────────────────────────────────
// Scrollable body — UNCHANGED structure from your original.
// ────────────────────────────────────────────────────────────────────────────

class _ScrollBody extends StatelessWidget {
  const _ScrollBody();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CardCarouselBloc, CardCarouselState>(
      buildWhen: (prev, curr) =>
          (prev is CardCarouselLoading && curr is CardCarouselLoaded) ||
          (prev is CardCarouselInitial && curr is CardCarouselLoading),
      builder: (context, state) {
        if (state is CardCarouselLoading) {
          return const Center(child: _LoadingView());
        }
        if (state is CardCarouselError) {
          return Center(child: _ErrorView(message: state.message));
        }

        return CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            // ── App bar ──────────────────────────────────────────
            SliverAppBar(
              pinned: true,
              backgroundColor: AppColors.background,
              elevation: 0,
              leading: const _BackButton(),
              title: const _AppBarTitle(),
              centerTitle: true,
              titleSpacing: 0,
            ),

            // ── Card carousel + curved notch (both pinned) ──────────
            SliverPersistentHeader(
              pinned: true,
              delegate: CardHeaderDelegate(),
            ),

            // ── Dot page indicators ──────────────────────────────
            const SliverToBoxAdapter(child: CardDotIndicator()),

            // ── Card name + logos + fee stats ────────────────────
            const SliverToBoxAdapter(child: CardInfoPanel()),

            // ── Cashback benefit rows ────────────────────────────
            const SliverToBoxAdapter(child: CashbackBenefitsSection()),

            // ── Brand Offers + Selected Offers ───────────────────
            const SliverToBoxAdapter(child: OffersSection()),

            // ── Bottom padding to clear sticky CTA ───────────────
            const SliverToBoxAdapter(child: SizedBox(height: 110)),
          ],
        );
      },
    );
  }
}

// ────────────────────────────────────────────────────────────────────────────
// App bar components
// ────────────────────────────────────────────────────────────────────────────

class _AppBarTitle extends StatelessWidget {
  const _AppBarTitle();

  @override
  Widget build(BuildContext context) {
    return const Text(
      'Credit Card Offers',
      style: TextStyle(
        color: AppColors.textPrimary,
        fontSize: 17,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}

class _BackButton extends StatelessWidget {
  const _BackButton();

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () => Navigator.maybePop(context),
      icon: const Icon(Icons.arrow_back, size: 20),
      color: AppColors.textPrimary,
    );
  }
}

// ────────────────────────────────────────────────────────────────────────────
// Loading / Error
// ────────────────────────────────────────────────────────────────────────────

class _LoadingView extends StatelessWidget {
  const _LoadingView();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const SizedBox(
          width: 32,
          height: 32,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            valueColor: AlwaysStoppedAnimation<Color>(
              AppColors.cardGoldPrimary,
            ),
          ),
        ),
        const SizedBox(height: 16),
        Text(
          'Loading your cards…',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ],
    );
  }
}

class _ErrorView extends StatelessWidget {
  const _ErrorView({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.error_outline_rounded,
            size: 48,
            color: AppColors.accentRed,
          ),
          const SizedBox(height: 16),
          Text(
            'Something went wrong',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          Text(
            message,
            style: Theme.of(context).textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

// ────────────────────────────────────────────────────────────────────────────
// CardHeaderDelegate
//
// Carousel Positioned is EXACTLY as your original (top/left/right only, no
// bottom) — its zoom/scale behaviour is untouched. The notch strip is a
// SEPARATE overlay painted after it in the Stack, so it sits on top without
// resizing/cropping the carousel.
// ────────────────────────────────────────────────────────────────────────────

class CardHeaderDelegate extends SliverPersistentHeaderDelegate {
  static const double _notchStripHeight = 30.0;
  static const double _maxNotchDepth = 25.0;
  static const double _notchGrowDistance = 30.0; // px of scroll to reach max

  @override
  double get maxExtent => 350;

  @override
  double get minExtent => 200;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    final carouselProgress = (shrinkOffset / (maxExtent - minExtent)).clamp(
      0.0,
      0.8,
    );

    // 0 at rest, grows to _maxNotchDepth over the first _notchGrowDistance
    // px of scroll, then holds.
    final scrollT = (shrinkOffset / _notchGrowDistance).clamp(0.0, 1.0);
    final notchDepth = scrollT * _maxNotchDepth;

    return Container(
      color: AppColors.background,
      child: Stack(
        clipBehavior: Clip.hardEdge,
        alignment: Alignment.topCenter,
        children: [
          // ── Card carousel — UNCHANGED, fills full delegate height ──
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Transform.scale(
              alignment: Alignment.topCenter,
              scale: 1 + (carouselProgress * 0.3),
              child: const CardCarouselConnected(),
            ),
          ),

          // ── Curved notch overlay ─────────────────────────────────
          // Invisible at rest (opacity 0 → shrinkOffset == 0), so there is
          // NO stray strip/bar when not scrolling. Fades in and curves as
          // scrollT grows.
          if (scrollT > 0.8)
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Opacity(
                opacity: scrollT,
                child: ClipPath(
                  clipper: _BowlNotchClipper(notchDepth: notchDepth),
                  child: Container(
                    height: _notchStripHeight,
                    color: AppColors.background,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) =>
      true;
}

// ────────────────────────────────────────────────────────────────────────────
// Smooth curved notch clipper — unchanged logic from before.
// ────────────────────────────────────────────────────────────────────────────

class _BowlNotchClipper extends CustomClipper<Path> {
  const _BowlNotchClipper({required this.notchDepth});

  final double notchDepth;

  static const double _notchHalfWidth = 20.0;

  @override
  Path getClip(Size size) {
    final w = size.width;
    final h = size.height;
    final cx = w / 2;
    final d = notchDepth;

    final path = Path()
      ..moveTo(0, 0)
      ..lineTo(cx - _notchHalfWidth, 0)
      ..cubicTo(
        cx - _notchHalfWidth * 0.3,
        d,
        cx + _notchHalfWidth * 0.4,
        d,
        cx + _notchHalfWidth,
        0,
      )
      ..lineTo(w, 0)
      ..lineTo(w, h)
      ..lineTo(0, h)
      ..close();

    return path;
  }

  @override
  bool shouldReclip(_BowlNotchClipper old) => old.notchDepth != notchDepth;
}
