import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_colors.dart';
import '../../domain/entities/credit_card.dart';
import '../bloc/card_carousel_bloc.dart';
import '../bloc/card_carousel_state.dart';

/// Card details panel shown below the carousel.
///
/// Displays (per selected card, with AnimatedSwitcher cross-fade):
///  • Card display name  — "The RBL {name} Credit Card"
///  • Brand logos row   — "RBL Bank" + "VISA"
///  • Fee stats row     — Annual Fee | Joining Fee | Hidden Charges
class CardInfoPanel extends StatelessWidget {
  const CardInfoPanel({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocSelector<CardCarouselBloc, CardCarouselState, CreditCard?>(
      selector: (state) =>
          state is CardCarouselLoaded ? state.selectedCard : null,
      builder: (context, card) {
        return AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          switchInCurve: Curves.easeOut,
          switchOutCurve: Curves.easeIn,
          transitionBuilder: (child, animation) => FadeTransition(
            opacity: animation,
            child: SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0, 0.04),
                end: Offset.zero,
              ).animate(animation),
              child: child,
            ),
          ),
          child: card == null
              ? const SizedBox.shrink()
              : _CardInfoContent(key: ValueKey(card.id), card: card),
        );
      },
    );
  }
}

// ────────────────────────────────────────────────────────────────────────────

class _CardInfoContent extends StatelessWidget {
  const _CardInfoContent({super.key, required this.card});

  final CreditCard card;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Card name
          Text(
            'The RBL ${card.name} Credit Card',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  letterSpacing: -0.3,
                ),
          ),
          const SizedBox(height: 10),

          // Brand logos row
          Row(
            children: [
              _RblBankBadge(),
              const SizedBox(width: 10),
              _VisaBadge(),
            ],
          ),
          const SizedBox(height: 20),

          // Fee stats row
          _FeeStatsRow(card: card),
        ],
      ),
    );
  }
}

// ── RBL Bank badge ────────────────────────────────────────────────────────────

class _RblBankBadge extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: AppColors.surfaceElevated,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.divider),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // "b" symbol styled like RBL's brand mark
          Container(
            width: 16,
            height: 16,
            decoration: const BoxDecoration(
              color: AppColors.cardGoldPrimary,
              shape: BoxShape.circle,
            ),
            child: const Center(
              child: Text(
                'b',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.w900,
                  height: 1,
                ),
              ),
            ),
          ),
          const SizedBox(width: 5),
          Text(
            'RBL Bank',
            style: GoogleFonts.inter(
              color: AppColors.textPrimary,
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

// ── Visa badge ────────────────────────────────────────────────────────────────

class _VisaBadge extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: AppColors.surfaceElevated,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.divider),
      ),
      child: Text(
        'VISA',
        style: GoogleFonts.inter(
          color: const Color(0xFF1A1F71),
          fontSize: 12,
          fontWeight: FontWeight.w900,
          letterSpacing: 1.5,
          shadows: const [
            Shadow(
              color: Color(0xFF1A1F71),
              blurRadius: 0,
            )
          ],
        ),
      ),
    );
  }
}

// ── Fee stats row ─────────────────────────────────────────────────────────────

class _FeeStatsRow extends StatelessWidget {
  const _FeeStatsRow({required this.card});

  final CreditCard card;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.divider),
      ),
      child: IntrinsicHeight(
        child: Row(
          children: [
            _FeeStat(
              value: '₹${card.annualFee.toInt()}',
              label: 'Annual Fee',
            ),
            const VerticalDivider(
              color: AppColors.divider,
              width: 1,
              thickness: 1,
              indent: 14,
              endIndent: 14,
            ),
            _FeeStat(
              value: '₹${card.joiningFee.toInt()}',
              label: 'Joining Fee',
            ),
            const VerticalDivider(
              color: AppColors.divider,
              width: 1,
              thickness: 1,
              indent: 14,
              endIndent: 14,
            ),
            _FeeStat(
              value: '₹${card.hiddenCharges.toInt()}',
              label: 'Hidden Charges',
            ),
          ],
        ),
      ),
    );
  }
}

class _FeeStat extends StatelessWidget {
  const _FeeStat({required this.value, required this.label});

  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 14),
        child: Column(
          children: [
            Text(
              value,
              style: GoogleFonts.inter(
                color: AppColors.textPrimary,
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: GoogleFonts.inter(
                color: AppColors.textSecondary,
                fontSize: 10,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
