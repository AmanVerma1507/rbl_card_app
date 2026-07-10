import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_colors.dart';

// ── Mock offer data (static — same for all cards) ─────────────────────────────

class _BrandOffer {
  const _BrandOffer({
    required this.brandName,
    required this.imagePath,
    required this.offerText,
    required this.badgeColor,
  });
  final String brandName;
  final String imagePath;
  final String offerText;
  final Color badgeColor;
}

const _brandOffers = [
  _BrandOffer(
    brandName: 'ixigo',
    imagePath: 'assets/IMG_3889 2.png',
    offerText:
        'Get 8% off on flight bookings, with a max discount of up to ₹1000',
    badgeColor: Color(0xFFFF6B35),
  ),
  _BrandOffer(
    brandName: 'FitLife',
    imagePath: 'assets/IMG_3902 1.png',
    offerText: 'Get 3 months complimentary gym membership at select outlets',
    badgeColor: Color(0xFF6366F1),
  ),
];

class _SelectedOffer {
  const _SelectedOffer({
    required this.title,
    required this.imagePath,
    required this.description,
  });
  final String title;
  final String imagePath;
  final String description;
}

const _selectedOffers = [
  _SelectedOffer(
    title: 'Golf Program',
    imagePath: 'assets/IMG_3905 2.png',
    description: 'Enjoy complimentary golf session every year',
  ),
  _SelectedOffer(
    title: 'Spa Services',
    imagePath: 'assets/IMG_3904 2.png',
    description: 'Premium spa access at 5-star hotel properties',
  ),
];

// ── Main widget ───────────────────────────────────────────────────────────────

/// Offers section showing:
/// 1. "Brand Offers and Benefits" — horizontal scrollable large image cards
/// 2. "Selected Offers"           — 2-column image grid
class OffersSection extends StatelessWidget {
  const OffersSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        SizedBox(height: 28),
        _BrandOffersSection(),
        SizedBox(height: 28),
        _SelectedOffersSection(),
      ],
    );
  }
}

// ── Brand Offers horizontal scroll ───────────────────────────────────────────

class _BrandOffersSection extends StatelessWidget {
  const _BrandOffersSection();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Brand Offers and Benefits',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
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
        ),
        const SizedBox(height: 14),
        SizedBox(
          height: 190,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            itemCount: _brandOffers.length,
            itemBuilder: (context, i) => _BrandOfferCard(offer: _brandOffers[i]),
          ),
        ),
      ],
    );
  }
}

class _BrandOfferCard extends StatelessWidget {
  const _BrandOfferCard({required this.offer});

  final _BrandOffer offer;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 240,
      margin: const EdgeInsets.only(right: 14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: AppColors.surface,
        border: Border.all(color: AppColors.divider),
      ),
      clipBehavior: Clip.hardEdge,
      child: Stack(
        children: [
          // Background image
          Positioned.fill(
            child: Image.asset(
              offer.imagePath,
              fit: BoxFit.cover,
              cacheWidth: 480,
            ),
          ),
          // Dark gradient overlay
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withValues(alpha: 0.75),
                  ],
                  stops: const [0.4, 1.0],
                ),
              ),
            ),
          ),
          // Brand badge + offer text
          Positioned(
            left: 14,
            right: 14,
            bottom: 14,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Brand badge
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: offer.badgeColor,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    offer.brandName,
                    style: GoogleFonts.inter(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  offer.offerText,
                  style: GoogleFonts.inter(
                    color: Colors.white,
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                    height: 1.4,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── Selected Offers 2-column grid ────────────────────────────────────────────

class _SelectedOffersSection extends StatelessWidget {
  const _SelectedOffersSection();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Selected Offers',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
              ),
              Text(
                'See all',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.accentBlue,
                      fontWeight: FontWeight.w600,
                    ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          // 2-column grid
          Row(
            children: _selectedOffers
                .map(
                  (offer) => Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(
                        right: offer == _selectedOffers.first ? 7 : 0,
                        left: offer == _selectedOffers.last ? 7 : 0,
                      ),
                      child: _SelectedOfferTile(offer: offer),
                    ),
                  ),
                )
                .toList(growable: false),
          ),
        ],
      ),
    );
  }
}

class _SelectedOfferTile extends StatelessWidget {
  const _SelectedOfferTile({required this.offer});

  final _SelectedOffer offer;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        color: AppColors.surface,
        border: Border.all(color: AppColors.divider),
      ),
      clipBehavior: Clip.hardEdge,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image
          AspectRatio(
            aspectRatio: 1.6,
            child: Image.asset(
              offer.imagePath,
              fit: BoxFit.cover,
              cacheWidth: 400,
            ),
          ),
          // Text content
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  offer.title,
                  style: GoogleFonts.inter(
                    color: AppColors.textPrimary,
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  offer.description,
                  style: GoogleFonts.inter(
                    color: AppColors.textSecondary,
                    fontSize: 11,
                    height: 1.4,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
