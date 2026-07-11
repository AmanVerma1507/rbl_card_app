import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

/// A simple pill / nozzle-shaped drag-handle indicator.
///
/// Sits at the top-center of the scrollable content panel (between the
/// card carousel and the card info area) to suggest the content area
/// is a draggable bottom-sheet style panel.
///
/// Shape: a small rounded-rectangle pill — 40 × 4 px, centred.
class ContentSheetNozzle extends StatelessWidget {
  const ContentSheetNozzle({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: AppColors.background,
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Center(
        child: Container(
          width: 40,
          height: 4,
          decoration: BoxDecoration(
            color: AppColors.textPrimary,
            borderRadius: BorderRadius.circular(100),
          ),
        ),
      ),
    );
  }
}
