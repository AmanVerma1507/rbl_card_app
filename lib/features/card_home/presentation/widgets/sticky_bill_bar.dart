import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../bloc/card_carousel_bloc.dart';
import '../bloc/card_carousel_state.dart';

/// Thin sticky bar pinned to the bottom of the screen showing total bill due.
///
/// Uses a narrow [BlocSelector] to avoid rebuilding on card selection changes —
/// it only reacts to [totalDue] and [cardsWithDue] changes.
class StickyBillBar extends StatelessWidget {
  const StickyBillBar({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocSelector<CardCarouselBloc, CardCarouselState,
        ({double totalDue, int cardsWithDue})>(
      selector: (state) {
        if (state is CardCarouselLoaded) {
          return (
            totalDue: state.totalDue,
            cardsWithDue: state.cardsWithDue,
          );
        }
        return (totalDue: 0.0, cardsWithDue: 0);
      },
      builder: (context, data) {
        return Container(
          width: double.infinity,
          padding: EdgeInsets.only(
            left: 20,
            right: 20,
            top: 12,
            bottom: 12 + MediaQuery.paddingOf(context).bottom,
          ),
          decoration: BoxDecoration(
            color: AppColors.stickyBarBackground,
            border: const Border(
              top: BorderSide(color: AppColors.stickyBarBorder),
            ),
          ),
          child: data.totalDue > 0
              ? _DueContent(data: data)
              : _AllClearContent(),
        );
      },
    );
  }
}

class _DueContent extends StatelessWidget {
  const _DueContent({required this.data});

  final ({double totalDue, int cardsWithDue}) data;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Container(
              width: 7,
              height: 7,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.accentRed,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              'Total bill due in ${data.cardsWithDue} '
              'card${data.cardsWithDue > 1 ? 's' : ''}',
              style: GoogleFonts.inter(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
        Text(
          CurrencyFormatter.format(data.totalDue),
          style: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
      ],
    );
  }
}

class _AllClearContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 7,
          height: 7,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.accentGreen,
          ),
        ),
        const SizedBox(width: 8),
        Text(
          'All bills paid · No dues',
          style: GoogleFonts.inter(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }
}
