import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Full-width "Get Your Card" CTA button — sticky at the screen bottom.
///
/// Uses a gold/amber horizontal gradient matching the RBL Gold card palette.
class GetCardCtaButton extends StatelessWidget {
  const GetCardCtaButton({super.key, this.onTap});

  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.paddingOf(context).bottom;

    return Container(
      color: const Color(0xFF0D0D0D), // match scaffold background
      padding: EdgeInsets.fromLTRB(20, 10, 20, 10 + bottomInset),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          height: 52,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFFC8922A), Color(0xFFE8B84B)],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
            borderRadius: BorderRadius.circular(14),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFFC8922A).withValues(alpha: 0.4),
                blurRadius: 20,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          alignment: Alignment.center,
          child: Text(
            'Get Your Card',
            style: GoogleFonts.inter(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.3,
            ),
          ),
        ),
      ),
    );
  }
}
