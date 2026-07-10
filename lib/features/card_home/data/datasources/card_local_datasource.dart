import '../../domain/entities/card_benefit.dart';
import '../../domain/entities/card_bill_info.dart';
import '../models/credit_card_model.dart';

/// Local (hardcoded) data source providing mock card + benefit data.
///
/// Asset mapping (corrected from image analysis):
///   Frame 2147225164.png → cashback badge icon (benefit row 1 icon)
///   Frame 2147225165.png → brand logos (benefit row 2 icon)
///   Group 2147225137.png → grocery POS  (benefit row 3 icon)
///   IMG_3889 2.png       → Brand Offer card: travel / ixigo
///   IMG_3902 1.png       → Brand Offer card: gym / fitness
///   IMG_3904 2.png       → Selected Offer: spa
///   IMG_3905 2.png       → Selected Offer: golf
class CardLocalDatasource {
  static const _cashbackIcon = 'assets/Frame 2147225164.png';
  static const _brandLogosIcon = 'assets/Frame 2147225165.png';
  static const _groceryIcon = 'assets/Group 2147225137.png';

  Future<List<CreditCardModel>> getCards() async {
    await Future.delayed(const Duration(milliseconds: 400));

    return [
      CreditCardModel(
        id: 'rbl-gold-001',
        name: 'Gold',
        variantLabel: 'RBL Gold Visa',
        assetPath: 'assets/magnific_1sEyt9Pr4r 1.png',
        lastFourDigits: '4821',
        annualFee: 0,
        joiningFee: 0,
        hiddenCharges: 0,
        billInfo: const CardBillInfo(
          status: BillStatus.paid,
          statusLabel: 'BILL PAID',
          totalDue: 0,
          promoText: 'Turn your bill payment to RBL Coins and earn 5x rewards',
          promoRewardLabel: 'RBL Coins',
        ),
        benefits: const [
          CardBenefit(
            percentage: '1%',
            title: 'Cashback',
            description: 'Up to ₹1,500 on all transactions',
            iconAssetPath: _cashbackIcon,
          ),
          CardBenefit(
            percentage: 'Flat 5%',
            title: 'Cashback',
            description: 'On your online spends with top brands',
            iconAssetPath: _brandLogosIcon,
          ),
          CardBenefit(
            percentage: 'Flat 1%',
            title: 'Cashback',
            description: 'On grocery, fuel & utility payments',
            iconAssetPath: _groceryIcon,
          ),
        ],
      ),
      CreditCardModel(
        id: 'rbl-privilege-002',
        name: 'Privilege',
        variantLabel: 'RBL Privilege Visa',
        assetPath: 'assets/magnific_74r2FRxJAL 1.png',
        lastFourDigits: '7643',
        annualFee: 0,
        joiningFee: 0,
        hiddenCharges: 0,
        billInfo: CardBillInfo(
          status: BillStatus.upcoming,
          statusLabel: 'UPCOMING BILL',
          amountDue: 18540,
          totalDue: 18540,
          nextBillDate: DateTime.now().add(const Duration(days: 12)),
          promoText:
              'Pay early and get 2x Reward Points on your next purchase',
          promoRewardLabel: 'Reward Points',
        ),
        benefits: const [
          CardBenefit(
            percentage: '2%',
            title: 'Cashback',
            description: 'Up to ₹5,000 on premium purchases',
            iconAssetPath: _cashbackIcon,
          ),
          CardBenefit(
            percentage: 'Flat 5%',
            title: 'Cashback',
            description: 'On fashion, lifestyle & dining',
            iconAssetPath: _brandLogosIcon,
          ),
          CardBenefit(
            percentage: 'Flat 1%',
            title: 'Cashback',
            description: 'On all other everyday spends',
            iconAssetPath: _groceryIcon,
          ),
        ],
      ),
      CreditCardModel(
        id: 'rbl-travel-003',
        name: 'Travel',
        variantLabel: 'RBL Travel Visa',
        assetPath: 'assets/magnific_swqN4Ikl8e 1.png',
        lastFourDigits: '9012',
        annualFee: 0,
        joiningFee: 0,
        hiddenCharges: 0,
        billInfo: const CardBillInfo(
          status: BillStatus.overdue,
          statusLabel: 'BILL OVERDUE BY 3 DAYS',
          amountDue: 34200,
          totalDue: 35650,
          overdueDays: 3,
          promoText:
              'Clear your overdue amount and avoid late payment charges',
          promoRewardLabel: 'RBL Coins',
        ),
        benefits: const [
          CardBenefit(
            percentage: '1.5%',
            title: 'Cashback',
            description: 'Up to ₹3,000 on all transactions',
            iconAssetPath: _cashbackIcon,
          ),
          CardBenefit(
            percentage: 'Flat 5%',
            title: 'Cashback',
            description: 'On your online spends',
            iconAssetPath: _brandLogosIcon,
          ),
          CardBenefit(
            percentage: 'Flat 1%',
            title: 'Cashback',
            description: 'On your all other spends',
            iconAssetPath: _groceryIcon,
          ),
        ],
      ),
    ];
  }
}
