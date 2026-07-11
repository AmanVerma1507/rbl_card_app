import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_colors.dart';
import '../bloc/card_carousel_bloc.dart';
import '../bloc/card_carousel_state.dart';

/// Small animated dot indicators below the card carousel.
///
/// Active dot is white and wider; inactive dots are dimmed and narrower.
/// Uses a narrow [BlocSelector] so only this widget rebuilds on index change.
class CardDotIndicator extends StatelessWidget {
  const CardDotIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocSelector<
      CardCarouselBloc,
      CardCarouselState,
      ({int totalCount, int selectedIndex})
    >(
      selector: (state) {
        if (state is CardCarouselLoaded) {
          // +1 for the "Add card" slot
          return (
            totalCount: state.cards.length + 1,
            selectedIndex: state.selectedIndex,
          );
        }
        return (totalCount: 0, selectedIndex: 0);
      },
      builder: (context, data) {
        if (data.totalCount == 0) return const SizedBox.shrink();

        return Padding(
          padding: const EdgeInsets.only(top: 25),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(data.totalCount, (i) {
              final isSelected = i == data.selectedIndex;
              return _DotItem(isSelected: isSelected);
            }),
          ),
        );
      },
    );
  }
}

class _DotItem extends StatelessWidget {
  const _DotItem({required this.isSelected});

  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 280),
      curve: Curves.easeOut,
      margin: const EdgeInsets.symmetric(horizontal: 3),
      width: isSelected ? 20 : 6,
      height: 6,
      decoration: BoxDecoration(
        color: isSelected
            ? AppColors.textPrimary
            : AppColors.textPrimary.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(3),
      ),
    );
  }
}
