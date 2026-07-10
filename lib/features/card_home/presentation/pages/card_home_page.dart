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
/// Scroll animation (VERIFIED against reference video, frame-by-frame at
/// 0.1s resolution — see notes below):
///
/// • The card carousel does **NOT** scale/shrink while scrolling. Comparing
///   the card's left/right edge x-position at t=0.80s (fully visible) vs
///   t=1.30s (mid-scroll) shows identical width — only the TOP portion of
///   the card gets progressively clipped away behind the pinned
///   [SliverAppBar]. This is plain scroll-under-pinned-header behavior,
///   NOT a Transform.scale effect.
/// • The card is therefore a normal (non-persistent, non-shrinking) sliver
///   that scrolls away like any other list item once the user scrolls past
///   it — it does not stay pinned at a reduced size.
/// • The scale/parallax effect DOES exist, but only on the **horizontal**
///   card-to-card swipe inside [CardCarouselConnected] (verified at
///   t=10.20–10.30s: the outgoing/incoming side card is visibly smaller
///   than the centered card during the swipe gesture). That animation
///   belongs inside the carousel widget's PageView (via viewportFraction +
///   a scale Transform driven by page scroll offset) — it is unrelated to
///   this page's vertical scroll and must not be reproduced here.
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
// Scrollable body — card scrolls away normally under the pinned app bar
// (no shrink/scale delegate — see class doc above for why).
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
            // Pinned + opaque background — this is what actually clips the
            // card as it scrolls underneath, matching the video.
            SliverAppBar(
              pinned: true,
              backgroundColor: AppColors.background,
              elevation: 0,
              leading: const _BackButton(),
              title: const _AppBarTitle(),
              centerTitle: true,
              titleSpacing: 0,
            ),

            // ── Card carousel (plain sliver — scrolls away naturally) ──
            // RepaintBoundary isolates the carousel's own internal
            // horizontal-swipe animation from repainting the rest of the
            // scroll view on every frame.
            const SliverToBoxAdapter(
              child: RepaintBoundary(child: CardCarouselConnected()),
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
