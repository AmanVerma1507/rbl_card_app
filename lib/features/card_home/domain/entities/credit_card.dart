import 'card_benefit.dart';
import 'card_bill_info.dart';

/// Domain entity representing an RBL credit card.
class CreditCard {
  const CreditCard({
    required this.id,
    required this.name,
    required this.variantLabel,
    required this.assetPath,
    required this.billInfo,
    this.lastFourDigits = '0000',
    this.annualFee = 0,
    this.joiningFee = 0,
    this.hiddenCharges = 0,
    this.benefits = const [],
  });

  final String id;

  /// Short display name, e.g. "Gold", "Privilege", "Travel".
  final String name;

  /// Subtitle shown on mini-thumbnail, e.g. "RBL Gold Visa".
  final String variantLabel;

  /// Path to the card art PNG inside assets/.
  final String assetPath;

  /// Current billing information for this card.
  final CardBillInfo billInfo;

  /// Last 4 digits of card number (display only, mock).
  final String lastFourDigits;

  /// Annual fee in INR (₹0 for all current RBL cards).
  final double annualFee;

  /// One-time joining fee in INR.
  final double joiningFee;

  /// Any hidden charges in INR.
  final double hiddenCharges;

  /// Cashback / reward benefits shown in the benefits section.
  final List<CardBenefit> benefits;

  @override
  bool operator ==(Object other) =>
      identical(this, other) || (other is CreditCard && other.id == id);

  @override
  int get hashCode => id.hashCode;
}
