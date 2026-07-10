import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

/// Offers section with:
/// 1. Category icon row (grocery, travel, gym, spa, golf)
/// 2. Cashback badge header tile
/// 3. Brand logo strip (Netflix, Myntra, Amazon, Flipkart)
class OffersSection extends StatelessWidget {
  const OffersSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 28),
          _SectionHeader(
            badgeAsset: 'assets/Frame 2147225164.png',
            title: 'Offers & Rewards',
            subtitle: 'Exclusive deals for your cards',
          ),
          const SizedBox(height: 20),
          _CategoryRow(),
          const SizedBox(height: 24),
          _BrandLogosCard(),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

// ── Section header ────────────────────────────────────────────────────────────

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({
    required this.badgeAsset,
    required this.title,
    required this.subtitle,
  });

  final String badgeAsset;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: AppColors.surfaceElevated,
            borderRadius: BorderRadius.circular(12),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.asset(
              badgeAsset,
              fit: BoxFit.contain,
              cacheWidth: 88,
            ),
          ),
        ),
        const SizedBox(width: 14),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 2),
            Text(
              subtitle,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      ],
    );
  }
}

// ── Category row ─────────────────────────────────────────────────────────────

const _categories = [
  _CategoryData('Grocery', 'assets/Group 2147225137.png'),
  _CategoryData('Travel', 'assets/IMG_3889 2.png'),
  _CategoryData('Gym', 'assets/IMG_3902 1.png'),
  _CategoryData('Spa', 'assets/IMG_3904 2.png'),
  _CategoryData('Golf', 'assets/IMG_3905 2.png'),
];

class _CategoryData {
  const _CategoryData(this.label, this.assetPath);
  final String label;
  final String assetPath;
}

class _CategoryRow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: _categories
          .map((cat) => _CategoryTile(data: cat))
          .toList(growable: false),
    );
  }
}

class _CategoryTile extends StatelessWidget {
  const _CategoryTile({required this.data});

  final _CategoryData data;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 58,
          height: 58,
          decoration: BoxDecoration(
            color: AppColors.categoryTileBg,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppColors.divider),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(13),
            child: Image.asset(
              data.assetPath,
              fit: BoxFit.cover,
              cacheWidth: 116,
            ),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          data.label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w500,
              ),
        ),
      ],
    );
  }
}

// ── Brand logos card ──────────────────────────────────────────────────────────

class _BrandLogosCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.divider),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Top brands',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontSize: 15,
                    ),
              ),
              Text(
                'View all',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.accentBlue,
                      fontWeight: FontWeight.w600,
                    ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.asset(
              'assets/Frame 2147225165.png',
              fit: BoxFit.contain,
              cacheWidth: 700,
            ),
          ),
        ],
      ),
    );
  }
}
