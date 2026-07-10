import 'package:flutter/material.dart';

/// Brand and semantic colors for the RBL Card Home screen.
abstract final class AppColors {
  // ── Background ──────────────────────────────────────────────
  static const Color background = Color(0xFF0D0D0D);
  static const Color surface = Color(0xFF1A1A1A);
  static const Color surfaceElevated = Color(0xFF242424);
  static const Color divider = Color(0xFF2E2E2E);

  // ── Card variants ────────────────────────────────────────────
  static const Color cardGoldPrimary = Color(0xFFC8922A);
  static const Color cardGoldSecondary = Color(0xFFE8B84B);
  static const Color cardGreenPrimary = Color(0xFF1A4731);
  static const Color cardGreenSecondary = Color(0xFF2D7A52);
  static const Color cardMaroonPrimary = Color(0xFF7B1C3E);
  static const Color cardMaroonSecondary = Color(0xFFB02B5A);

  // ── Accent / semantic ────────────────────────────────────────
  static const Color accentGreen = Color(0xFF22C55E);
  static const Color accentRed = Color(0xFFEF4444);
  static const Color accentAmber = Color(0xFFF59E0B);
  static const Color accentBlue = Color(0xFF3B82F6);

  // ── Text ─────────────────────────────────────────────────────
  static const Color textPrimary = Color(0xFFF5F5F5);
  static const Color textSecondary = Color(0xFFAAAAAA);
  static const Color textTertiary = Color(0xFF666666);
  static const Color textOnCard = Color(0xFFFFFFFF);

  // ── Sticky bar ───────────────────────────────────────────────
  static const Color stickyBarBackground = Color(0xFF111111);
  static const Color stickyBarBorder = Color(0xFF2A2A2A);

  // ── Add card placeholder ─────────────────────────────────────
  static const Color addCardBackground = Color(0xFF1C1C1C);
  static const Color addCardBorder = Color(0xFF333333);

  // ── Category tile background ─────────────────────────────────
  static const Color categoryTileBg = Color(0xFF1E1E1E);
}
