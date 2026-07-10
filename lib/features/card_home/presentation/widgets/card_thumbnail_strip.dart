import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_colors.dart';
import '../../domain/entities/credit_card.dart';
import '../bloc/card_carousel_bloc.dart';
import '../bloc/card_carousel_event.dart';
import '../bloc/card_carousel_state.dart';

/// Horizontal strip of mini card thumbnails acting as a page indicator +
/// tap-to-jump navigation control.
///
/// Uses a narrow [BlocSelector] so only this widget rebuilds on selection changes.
class CardThumbnailStrip extends StatelessWidget {
  const CardThumbnailStrip({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocSelector<CardCarouselBloc, CardCarouselState,
        ({List<CreditCard> cards, int selectedIndex})>(
      selector: (state) {
        if (state is CardCarouselLoaded) {
          return (cards: state.cards, selectedIndex: state.selectedIndex);
        }
        return (cards: const [], selectedIndex: 0);
      },
      builder: (context, data) {
        if (data.cards.isEmpty) return const SizedBox.shrink();

        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ...data.cards.asMap().entries.map((entry) {
                final index = entry.key;
                final card = entry.value;
                final isSelected = index == data.selectedIndex;
                return _CardThumbnailItem(
                  card: card,
                  isSelected: isSelected,
                  onTap: () => context
                      .read<CardCarouselBloc>()
                      .add(CardSelected(index)),
                );
              }),
              // Add card thumbnail dot
              _AddCardDot(
                isSelected: data.selectedIndex == data.cards.length,
                onTap: () => context
                    .read<CardCarouselBloc>()
                    .add(CardSelected(data.cards.length)),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _CardThumbnailItem extends StatelessWidget {
  const _CardThumbnailItem({
    required this.card,
    required this.isSelected,
    required this.onTap,
  });

  final CreditCard card;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 280),
        curve: Curves.easeOut,
        margin: const EdgeInsets.symmetric(horizontal: 5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected
                ? AppColors.textPrimary
                : AppColors.divider,
            width: isSelected ? 2 : 1,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: Colors.white.withValues(alpha: 0.15),
                    blurRadius: 8,
                    spreadRadius: 0,
                  ),
                ]
              : null,
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(7),
          child: AnimatedOpacity(
            opacity: isSelected ? 1.0 : 0.5,
            duration: const Duration(milliseconds: 280),
            child: Image.asset(
              card.assetPath,
              width: 44,
              height: 44 * 1.586,
              fit: BoxFit.cover,
              cacheWidth: 120,
            ),
          ),
        ),
      ),
    );
  }
}

class _AddCardDot extends StatelessWidget {
  const _AddCardDot({
    required this.isSelected,
    required this.onTap,
  });

  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 280),
        curve: Curves.easeOut,
        margin: const EdgeInsets.symmetric(horizontal: 5),
        width: 44,
        height: 44 * 1.586,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: const Color(0xFF1C1C1C),
          border: Border.all(
            color: isSelected ? AppColors.textPrimary : AppColors.divider,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: AnimatedOpacity(
          opacity: isSelected ? 1.0 : 0.5,
          duration: const Duration(milliseconds: 280),
          child: const Icon(
            Icons.add_rounded,
            color: Color(0xFF888888),
            size: 18,
          ),
        ),
      ),
    );
  }
}
