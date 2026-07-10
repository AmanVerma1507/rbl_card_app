import '../../domain/entities/card_bill_info.dart';
import '../models/credit_card_model.dart';

/// Local (hardcoded) data source providing mock card data.
///
/// In production this would call a REST API; for this assignment
/// all data is in-memory to satisfy the assignment's "no real backend" requirement.
class CardLocalDatasource {
  Future<List<CreditCardModel>> getCards() async {
    // Simulate a short network delay to demonstrate async BLoC loading state.
    await Future.delayed(const Duration(milliseconds: 400));

    return [
      CreditCardModel(
        id: 'rbl-gold-001',
        name: 'Gold',
        variantLabel: 'RBL Gold Visa',
        assetPath: 'assets/magnific_1sEyt9Pr4r 1.png',
        lastFourDigits: '4821',
        billInfo: const CardBillInfo(
          status: BillStatus.paid,
          statusLabel: 'BILL PAID',
          totalDue: 0,
          nextBillDate: null,
          promoText:
              'Turn your next bill payment to RBL Coins and earn 5x rewards',
          promoRewardLabel: 'RBL Coins',
        ),
      ),
      CreditCardModel(
        id: 'rbl-privilege-002',
        name: 'Privilege',
        variantLabel: 'RBL Privilege Visa',
        assetPath: 'assets/magnific_74r2FRxJAL 1.png',
        lastFourDigits: '7643',
        billInfo: CardBillInfo(
          status: BillStatus.upcoming,
          statusLabel: 'UPCOMING BILL',
          amountDue: 18540,
          totalDue: 18540,
          nextBillDate: DateTime.now().add(const Duration(days: 12)),
          promoText:
              'Pay your bill early and get 2x Reward Points on your next purchase',
          promoRewardLabel: 'Reward Points',
        ),
      ),
      CreditCardModel(
        id: 'rbl-travel-003',
        name: 'Travel',
        variantLabel: 'RBL Travel Visa',
        assetPath: 'assets/magnific_swqN4Ikl8e 1.png',
        lastFourDigits: '9012',
        billInfo: const CardBillInfo(
          status: BillStatus.overdue,
          statusLabel: 'BILL OVERDUE BY 3 DAYS',
          amountDue: 34200,
          totalDue: 35650,
          overdueDays: 3,
          promoText:
              'Clear your overdue amount now and avoid late payment charges',
          promoRewardLabel: 'RBL Coins',
        ),
      ),
    ];
  }
}
