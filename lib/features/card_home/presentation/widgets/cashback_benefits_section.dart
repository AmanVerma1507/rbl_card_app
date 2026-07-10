import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_colors.dart';
import '../../domain/entities/card_benefit.dart';
import '../../domain/entities/credit_card.dart';
import '../bloc/card_carousel_bloc.dart';
import '../bloc/card_carousel_state.dart';

/// Three cashback/reward benefit rows that update with the selected card.
///
/// Uses [AnimatedSwitcher] to cross-fade when the card changes.
/// Each row: [percentage + title + description] on left, [icon image] on right.
class CashbackBenefitsSection extends StatelessWidget {
  const CashbackBenefitsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocSelector<CardCarouselBloc, CardCarouselState, CreditCard?>(
      selector: (state) =>
          state is CardCarouselLoaded ? state.selectedCard : null,
      builder: (context, card) {
        return AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          switchInCurve: Curves.easeOut,
          transitionBuilder: (child, animation) => FadeTransition(
            opacity: animation,
            child: child,
          ),
          child: card == null || card.benefits.isEmpty
              ? const SizedBox.shrink()
              : _BenefitsList(key: ValueKey(card.id), benefits: card.benefits),
        );
      },
    );
  }
}

class _BenefitsList extends StatelessWidget {
  const _BenefitsList({super.key, required this.benefits});

  final List<CardBenefit> benefits;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.divider),
        ),
        child: Column(
          children: benefits.asMap().entries.map((entry) {
            final isLast = entry.key == benefits.length - 1;
            return _BenefitRow(
              benefit: entry.value,
              showDivider: !isLast,
            );
          }).toList(growable: false),
        ),
      ),
    );
  }
}

class _BenefitRow extends StatelessWidget {
  const _BenefitRow({
    required this.benefit,
    required this.showDivider,
  });

  final CardBenefit benefit;
  final bool showDivider;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
            children: [
              // Left — percentage + title + description
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: '${benefit.percentage} ',
                            style: GoogleFonts.inter(
                              color: AppColors.textPrimary,
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          TextSpan(
                            text: benefit.title,
                            style: GoogleFonts.inter(
                              color: AppColors.textPrimary,
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      benefit.description,
                      style: GoogleFonts.inter(
                        color: AppColors.textSecondary,
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),

              // Right — icon
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: AppColors.categoryTileBg,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.asset(
                    benefit.iconAssetPath,
                    fit: BoxFit.contain,
                    cacheWidth: 104,
                  ),
                ),
              ),
            ],
          ),
        ),
        if (showDivider)
          const Divider(
            height: 1,
            thickness: 1,
            color: AppColors.divider,
            indent: 16,
            endIndent: 16,
          ),
      ],
    );
  }
}
