import 'dart:ui' show lerpDouble;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/credit_card.dart';
import '../bloc/card_carousel_bloc.dart';
import '../bloc/card_carousel_event.dart';
import '../bloc/card_carousel_state.dart';

/// Horizontal card carousel with parallax scale + opacity animation.
///
/// - [PageView] with viewportFraction = 0.82 so adjacent cards peek —
///   matches the ~15-18% edge-peek measured in the reference video.
/// - Scale (1.0 → 0.87) and opacity (1.0 → 0.55) on off-center cards are
///   driven by a per-item [AnimatedBuilder] listening to [pageController].
///   These values were checked against the reference video's horizontal
///   swipe (t≈10.20–10.30s) where the outgoing/incoming card is visibly
///   smaller than the centered one — confirmed this scale/parallax effect
///   is real and only happens on horizontal swipe (NOT on vertical page
///   scroll, see card_home_page.dart doc comment).
/// - Wrapped in [RepaintBoundary] to isolate repaints from the rest of the
///   scroll view.
///
/// IMPORTANT: [PageView.builder] already listens to [pageController] and
/// rebuilds itself efficiently on scroll — it must NOT be wrapped in an
/// outer [AnimatedBuilder] listening to the same controller, since that
/// would reconstruct the entire PageView.builder widget config on every
/// single scroll frame instead of letting only the per-item transform
/// (inside [_buildCardItem]) update. The per-item AnimatedBuilder below is
/// sufficient and keeps rebuilds scoped to just the scale/opacity wrapper —
/// the actual card content (`child`) is never rebuilt during scroll.
class CardCarousel extends StatefulWidget {
  const CardCarousel({
    super.key,
    required this.cards,
    required this.initialIndex,
    required this.pageController,
  });

  final List<CreditCard> cards;
  final int initialIndex;
  final PageController pageController;

  @override
  State<CardCarousel> createState() => _CardCarouselState();
}

class _CardCarouselState extends State<CardCarousel> {
  /// Total items = real cards + 1 "Add card" placeholder.
  int get _itemCount => widget.cards.length + 1;

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: SizedBox(
        height: _cardHeight(context),
        // No outer AnimatedBuilder here — PageView.builder manages its own
        // rebuilds from pageController. Per-item scale/opacity animation
        // is handled inside _buildCardItem instead.
        child: PageView.builder(
          controller: PageController(viewportFraction: 0.65),
          itemCount: _itemCount,
          onPageChanged: (index) {
            if (index < widget.cards.length) {
              context.read<CardCarouselBloc>().add(CardSelected(index));
            }
          },
          itemBuilder: _buildCardItem,
        ),
      ),
    );
  }

  Widget _buildCardItem(BuildContext context, int index) {
    return AnimatedBuilder(
      animation: widget.pageController,
      builder: (context, child) {
        double pageValue =
            widget.pageController.hasClients &&
                widget.pageController.page != null
            ? widget.pageController.page!
            : widget.initialIndex.toDouble();

        final double delta = (pageValue - index).abs().clamp(0.0, 1.0);
        final double scale = lerpDouble(1.0, 0.87, delta)!;
        final double opacity = lerpDouble(1.0, 0.55, delta)!;

        return Transform.scale(
          scale: scale,
          child: Opacity(opacity: opacity, child: child),
        );
      },
      // Passed as `child`, NOT rebuilt on every animation tick — only the
      // Transform/Opacity wrapper above re-runs during scroll.
      child: _buildCardContent(context, index),
    );
  }

  Widget _buildCardContent(BuildContext context, int index) {
    final isAddCard = index == widget.cards.length;
    if (isAddCard) return const _AddCardPlaceholder();

    final card = widget.cards[index];
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: AspectRatio(
          aspectRatio: 1 / 1.586, // Physical credit card ratio (portrait)
          child: Image.asset(
            card.assetPath,
            fit: BoxFit.cover,
            cacheWidth: 600,
          ),
        ),
      ),
    );
  }

  double _cardHeight(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    // Card width is viewport fraction of screen; height = width * 1.586
    final cardWidth = screenWidth * 0.6 - 16; // minus horizontal padding
    return cardWidth * 1.586;
  }
}

// ────────────────────────────────────────────────────────────────────────────
// Add Card Placeholder
// ────────────────────────────────────────────────────────────────────────────

class _AddCardPlaceholder extends StatelessWidget {
  const _AddCardPlaceholder();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: AspectRatio(
        aspectRatio: 1 / 1.586,
        child: Container(
          decoration: BoxDecoration(
            color: const Color(0xFF1C1C1C),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: const Color(0xFF333333), width: 1.5),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: const Color(0xFF2A2A2A),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: const Color(0xFF444444),
                    width: 1.5,
                  ),
                ),
                child: const Icon(
                  Icons.add_rounded,
                  color: Color(0xFF888888),
                  size: 28,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Add new card',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: const Color(0xFF888888),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ────────────────────────────────────────────────────────────────────────────
// Convenience BLoC-connected builder
// ────────────────────────────────────────────────────────────────────────────

/// Builds the carousel connected to [CardCarouselBloc].
class CardCarouselConnected extends StatefulWidget {
  const CardCarouselConnected({super.key});

  @override
  State<CardCarouselConnected> createState() => _CardCarouselConnectedState();
}

class _CardCarouselConnectedState extends State<CardCarouselConnected> {
  PageController? _controller;

  // Initialized lazily to the real starting index (see build()) instead of
  // a hardcoded 0, so a non-zero initial selectedIndex doesn't trigger a
  // spurious animateToPage on the first legitimate BLoC-driven change.
  int? _lastSelectedIndex;

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CardCarouselBloc, CardCarouselState>(
      listenWhen: (prev, curr) {
        if (curr is! CardCarouselLoaded || prev is! CardCarouselLoaded) {
          return false;
        }
        return curr.selectedIndex != prev.selectedIndex;
      },
      listener: (context, state) {
        if (state is CardCarouselLoaded &&
            _controller != null &&
            _controller!.hasClients) {
          final idx = state.selectedIndex;
          if (idx != _lastSelectedIndex) {
            _lastSelectedIndex = idx;
            _controller!.animateToPage(
              idx,
              duration: const Duration(milliseconds: 380),
              curve: Curves.easeOutCubic,
            );
          }
        }
      },
      buildWhen: (prev, curr) => curr is CardCarouselLoaded,
      builder: (context, state) {
        if (state is! CardCarouselLoaded) return const SizedBox.shrink();

        if (_controller == null) {
          _controller = PageController(
            initialPage: state.selectedIndex,
            viewportFraction: 0.82,
          );
          _lastSelectedIndex = state.selectedIndex;
        }

        return CardCarousel(
          cards: state.cards,
          initialIndex: state.selectedIndex,
          pageController: _controller!,
        );
      },
    );
  }
}
