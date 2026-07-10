import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../domain/entities/card_bill_info.dart';
import '../../domain/entities/credit_card.dart';
import '../bloc/card_carousel_bloc.dart';
import '../bloc/card_carousel_state.dart';

/// Dynamic content panel that changes with the selected card.
///
/// Uses [AnimatedSwitcher] for cross-fade transitions when the card changes.
/// [BlocSelector] scopes rebuilds to only fire when [selectedIndex] changes.
class CardInfoPanel extends StatelessWidget {
  const CardInfoPanel({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocSelector<CardCarouselBloc, CardCarouselState, CreditCard?>(
      selector: (state) =>
          state is CardCarouselLoaded ? state.selectedCard : null,
      builder: (context, card) {
        return AnimatedSwitcher(
          duration: const Duration(milliseconds: 320),
          switchInCurve: Curves.easeOut,
          switchOutCurve: Curves.easeIn,
          transitionBuilder: (child, animation) {
            return FadeTransition(
              opacity: animation,
              child: SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(0, 0.05),
                  end: Offset.zero,
                ).animate(animation),
                child: child,
              ),
            );
          },
          child: card == null
              ? const SizedBox.shrink()
              : _CardInfoContent(key: ValueKey(card.id), card: card),
        );
      },
    );
  }
}

class _CardInfoContent extends StatelessWidget {
  const _CardInfoContent({super.key, required this.card});

  final CreditCard card;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          _StatusRow(billInfo: card.billInfo),
          const SizedBox(height: 14),
          _BillInfoCard(billInfo: card.billInfo),
          const SizedBox(height: 14),
          if (card.billInfo.promoText != null)
            _PromoBanner(
              promoText: card.billInfo.promoText!,
              cardName: card.name,
            ),
        ],
      ),
    );
  }
}

// ── Status Row ───────────────────────────────────────────────────────────────

class _StatusRow extends StatelessWidget {
  const _StatusRow({required this.billInfo});

  final CardBillInfo billInfo;

  Color get _dotColor => switch (billInfo.status) {
        BillStatus.paid => AppColors.accentGreen,
        BillStatus.overdue => AppColors.accentRed,
        BillStatus.upcoming => AppColors.accentAmber,
      };

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: _dotColor,
            boxShadow: [
              BoxShadow(
                color: _dotColor.withValues(alpha: 0.6),
                blurRadius: 6,
                spreadRadius: 1,
              ),
            ],
          ),
        ),
        const SizedBox(width: 8),
        Text(
          billInfo.statusLabel,
          style: GoogleFonts.inter(
            fontSize: 11,
            fontWeight: FontWeight.w700,
            color: _dotColor,
            letterSpacing: 1.2,
          ),
        ),
      ],
    );
  }
}

// ── Bill Info Card ───────────────────────────────────────────────────────────

class _BillInfoCard extends StatelessWidget {
  const _BillInfoCard({required this.billInfo});

  final CardBillInfo billInfo;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.divider),
      ),
      child: switch (billInfo.status) {
        BillStatus.paid => _PaidContent(billInfo: billInfo),
        BillStatus.upcoming => _UpcomingContent(billInfo: billInfo),
        BillStatus.overdue => _OverdueContent(billInfo: billInfo),
      },
    );
  }
}

class _PaidContent extends StatelessWidget {
  const _PaidContent({required this.billInfo});

  final CardBillInfo billInfo;

  @override
  Widget build(BuildContext context) {
    final next = billInfo.nextBillDate;
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                next != null
                    ? 'Next bill expected on ${_formatDate(next)}'
                    : 'No upcoming bill',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const SizedBox(height: 4),
              Text(
                'You\'re all caught up!',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
        ),
        const SizedBox(width: 12),
        OutlinedButton(
          onPressed: () {},
          child: const Text('Pay early'),
        ),
      ],
    );
  }
}

class _UpcomingContent extends StatelessWidget {
  const _UpcomingContent({required this.billInfo});

  final CardBillInfo billInfo;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                billInfo.nextBillDate != null
                    ? 'Bill due on ${_formatDate(billInfo.nextBillDate!)}'
                    : 'Upcoming bill',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const SizedBox(height: 4),
              Text(
                billInfo.amountDue != null
                    ? CurrencyFormatter.format(billInfo.amountDue!)
                    : 'Amount pending',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                    ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 12),
        OutlinedButton(
          onPressed: () {},
          child: const Text('Pay early'),
        ),
      ],
    );
  }
}

class _OverdueContent extends StatelessWidget {
  const _OverdueContent({required this.billInfo});

  final CardBillInfo billInfo;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (billInfo.overdueDays != null)
                Text(
                  'Overdue by ${billInfo.overdueDays} day${billInfo.overdueDays! > 1 ? 's' : ''}',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.accentRed,
                      ),
                ),
              const SizedBox(height: 4),
              Text(
                billInfo.totalDue != null
                    ? 'Total due ${CurrencyFormatter.format(billInfo.totalDue!)}'
                    : 'Payment overdue',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 12),
        ElevatedButton(
          onPressed: () {},
          child: const Text('Pay now'),
        ),
      ],
    );
  }
}

// ── Promo Banner ─────────────────────────────────────────────────────────────

class _PromoBanner extends StatelessWidget {
  const _PromoBanner({required this.promoText, required this.cardName});

  final String promoText;
  final String cardName;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.divider),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              promoText,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.textSecondary,
                    height: 1.5,
                  ),
            ),
          ),
          const SizedBox(width: 16),
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: AppColors.surfaceElevated,
              shape: BoxShape.circle,
            ),
            child: ClipOval(
              child: Image.asset(
                'assets/Frame 2147225164.png',
                fit: BoxFit.contain,
                cacheWidth: 120,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Helpers ──────────────────────────────────────────────────────────────────

String _formatDate(DateTime date) {
  const months = [
    'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
  ];
  return '${date.day} ${months[date.month - 1]}';
}
