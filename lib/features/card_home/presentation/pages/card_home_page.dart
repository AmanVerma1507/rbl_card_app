import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/theme/app_colors.dart';
import '../bloc/card_carousel_bloc.dart';
import '../bloc/card_carousel_event.dart';
import '../bloc/card_carousel_state.dart';
import '../widgets/card_carousel.dart';
import '../widgets/card_info_panel.dart';
import '../widgets/card_thumbnail_strip.dart';
import '../widgets/offers_section.dart';
import '../widgets/scroll_reveal_card.dart';
import '../widgets/sticky_bill_bar.dart';

/// Root page for the RBL Card Home screen.
///
/// Layout (top → bottom):
/// 1. App bar (back arrow + "More actions" button)
/// 2. Card carousel (hero element with parallax)
/// 3. Dynamic content panel (bill status + info + promo)
/// 4. Scroll-reveal analytics card
/// 5. Offers section
/// Overlay (always on top):
/// 6. Sticky bill bar + thumbnail strip (pinned to bottom)
class CardHomePage extends StatefulWidget {
  const CardHomePage({super.key});

  @override
  State<CardHomePage> createState() => _CardHomePageState();
}

class _CardHomePageState extends State<CardHomePage> {
  final ScrollController _scrollController = ScrollController();
  double _scrollOffset = 0;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      setState(() => _scrollOffset = _scrollController.offset);
    });
  }

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
            // ── Scrollable body ──────────────────────────────────
            _ScrollBody(
              scrollController: _scrollController,
              scrollOffset: _scrollOffset,
            ),

            // ── Sticky bottom overlay ────────────────────────────
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  CardThumbnailStrip(),
                  StickyBillBar(),
                ],
              ),
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
  const _ScrollBody({
    required this.scrollController,
    required this.scrollOffset,
  });

  final ScrollController scrollController;
  final double scrollOffset;

  @override
  Widget build(BuildContext context) {
    // Bottom padding to clear the sticky bar + thumbnail strip (~140px).
    return BlocBuilder<CardCarouselBloc, CardCarouselState>(
      buildWhen: (prev, curr) =>
          (prev is CardCarouselLoading && curr is CardCarouselLoaded) ||
          (prev is CardCarouselInitial && curr is CardCarouselLoading),
      builder: (context, state) {
        return CustomScrollView(
          controller: scrollController,
          physics: const BouncingScrollPhysics(),
          slivers: [
            // App bar
            SliverAppBar(
              pinned: false,
              floating: true,
              backgroundColor: AppColors.background,
              leading: const _BackButton(),
              actions: const [_MoreActionsButton()],
              titleSpacing: 0,
            ),

            // Loading / error states
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
              // Card carousel
              const SliverToBoxAdapter(child: CardCarouselConnected()),

              // Dynamic card info panel
              const SliverToBoxAdapter(child: CardInfoPanel()),

              // Scroll-reveal analytics card
              SliverToBoxAdapter(
                child: ScrollRevealCard(
                  scrollOffset: scrollOffset,
                  revealAt: 120,
                ),
              ),

              // Offers section
              const SliverToBoxAdapter(child: OffersSection()),

              // Bottom padding to clear sticky bar (~160px)
              const SliverToBoxAdapter(
                child: SizedBox(height: 160),
              ),
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

class _MoreActionsButton extends StatelessWidget {
  const _MoreActionsButton();

  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
      onPressed: () {},
      style: TextButton.styleFrom(
        foregroundColor: AppColors.textPrimary,
        padding: const EdgeInsets.symmetric(horizontal: 16),
      ),
      label: Text(
        'More actions',
        style: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: AppColors.textPrimary,
        ),
      ),
      icon: const Icon(Icons.keyboard_arrow_down_rounded, size: 20),
      iconAlignment: IconAlignment.end,
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
              valueColor: AlwaysStoppedAnimation<Color>(AppColors.cardGoldPrimary),
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
