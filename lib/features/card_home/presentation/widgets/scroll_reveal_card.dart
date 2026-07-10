import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

/// A card that fades and slides into view when the user scrolls past a
/// threshold. Use inside a [CustomScrollView] via a [SliverToBoxAdapter].
///
/// The parent page passes the current scroll offset; this widget computes
/// its own visibility and triggers the animation automatically.
class ScrollRevealCard extends StatefulWidget {
  const ScrollRevealCard({
    super.key,
    required this.scrollOffset,
    required this.revealAt,
  });

  /// Current scroll offset from the parent [CustomScrollView].
  final double scrollOffset;

  /// The scroll offset at which this card should begin revealing.
  final double revealAt;

  @override
  State<ScrollRevealCard> createState() => _ScrollRevealCardState();
}

class _ScrollRevealCardState extends State<ScrollRevealCard>
    with SingleTickerProviderStateMixin {
  bool _revealed = false;

  @override
  void didUpdateWidget(ScrollRevealCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!_revealed && widget.scrollOffset >= widget.revealAt) {
      setState(() => _revealed = true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSlide(
      offset: _revealed ? Offset.zero : const Offset(0, 0.1),
      duration: const Duration(milliseconds: 380),
      curve: Curves.easeOutCubic,
      child: AnimatedOpacity(
        opacity: _revealed ? 1.0 : 0.0,
        duration: const Duration(milliseconds: 380),
        curve: Curves.easeOut,
        child: const _ScrollRevealContent(),
      ),
    );
  }
}

class _ScrollRevealContent extends StatelessWidget {
  const _ScrollRevealContent();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.divider),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Want to track, analyse\nand spend smarter?',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          height: 1.4,
                        ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "We're setting this up.\nCheck back next billing cycle.",
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          height: 1.5,
                        ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),
            _BarChartIllustration(),
          ],
        ),
      ),
    );
  }
}

/// Simple bar-chart illustration drawn in-code — no PNG asset needed.
class _BarChartIllustration extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 56,
      height: 56,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: const [
          _Bar(fraction: 0.4, color: Color(0xFF3B82F6)),
          _Bar(fraction: 0.75, color: Color(0xFF22C55E)),
          _Bar(fraction: 0.55, color: Color(0xFF8B5CF6)),
          _Bar(fraction: 1.0, color: Color(0xFFF59E0B)),
        ],
      ),
    );
  }
}

class _Bar extends StatelessWidget {
  const _Bar({required this.fraction, required this.color});

  final double fraction;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 10,
      height: 56 * fraction,
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.85),
        borderRadius: BorderRadius.circular(3),
      ),
    );
  }
}
