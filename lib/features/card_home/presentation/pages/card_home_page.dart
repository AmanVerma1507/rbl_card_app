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

/// Root page for the RBL Card Home (Card Offers) screen.
///
/// Layout (top → bottom, scrollable):
/// 1. App bar  — "Credit Card Offers" title + back arrow
/// 2. Card carousel — parallax PageView
/// 3. Dot indicators — animated pill dots
/// 4. Card details   — name, RBL + VISA logos, ₹0 fee stats
/// 5. Cashback benefits — 3 benefit rows (per selected card)
/// 6. Brand Offers   — horizontal scrollable large image cards
/// 7. Selected Offers — 2-column offer grid
///
/// Sticky overlay (always visible):
/// 8. "Get Your Card" amber/gold CTA button
class CardHomePage extends StatefulWidget {
  const CardHomePage({super.key});

  @override
  State<CardHomePage> createState() => _CardHomePageState();
}

class _CardHomePageState extends State<CardHomePage> {
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<CardCarouselBloc>()..add(const LoadCards()),
      child: Scaffold(
        backgroundColor: AppColors.background,
        extendBody: true,
        body: Stack(
          children: [
            // ── Scrollable content ───────────────────────────────
            _ScrollBody(scrollController: _scrollController),

            // ── Sticky CTA at bottom ─────────────────────────────
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
// Scrollable body
// ────────────────────────────────────────────────────────────────────────────

class _ScrollBody extends StatelessWidget {
  const _ScrollBody({required this.scrollController});

  final ScrollController scrollController;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CardCarouselBloc, CardCarouselState>(
      buildWhen: (prev, curr) =>
          (prev is CardCarouselLoading && curr is CardCarouselLoaded) ||
          (prev is CardCarouselInitial && curr is CardCarouselLoading),
      builder: (context, state) {
        return CustomScrollView(
          controller: scrollController,
          physics: const BouncingScrollPhysics(),
          slivers: [
            // ── App bar ──────────────────────────────────────────
            SliverAppBar(
              pinned: false,
              floating: true,
              backgroundColor: AppColors.background,
              leading: const _BackButton(),
              title: const _AppBarTitle(),
              centerTitle: true,
              titleSpacing: 0,
            ),

            // ── Loading / Error ──────────────────────────────────
            if (state is CardCarouselLoading)
              const SliverFillRemaining(
                hasScrollBody: false,
                child: _LoadingView(),
              )
            else if (state is CardCarouselError)
              SliverFillRemaining(
                hasScrollBody: false,
                child: _ErrorView(message: state.message),
              )
            else ...[
              // ── Card carousel ────────────────────────────────
              const SliverToBoxAdapter(child: CardCarouselConnected()),

              // ── Dot indicators ───────────────────────────────
              const SliverToBoxAdapter(child: CardDotIndicator()),

              // ── Card name + logos + fee stats ────────────────
              const SliverToBoxAdapter(child: CardInfoPanel()),

              // ── Cashback benefit rows ────────────────────────
              const SliverToBoxAdapter(child: CashbackBenefitsSection()),

              // ── Brand Offers + Selected Offers ───────────────
              const SliverToBoxAdapter(child: OffersSection()),

              // ── Bottom padding to clear CTA button ──────────
              const SliverToBoxAdapter(child: SizedBox(height: 100)),
            ],
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
      icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
      color: AppColors.textPrimary,
    );
  }
}

// ────────────────────────────────────────────────────────────────────────────
// Loading / Error states
// ────────────────────────────────────────────────────────────────────────────

class _LoadingView extends StatelessWidget {
  const _LoadingView();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(
            width: 32,
            height: 32,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor:
                  AlwaysStoppedAnimation<Color>(AppColors.cardGoldPrimary),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Loading your cards…',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  const _ErrorView({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
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
      ),
    );
  }
}
