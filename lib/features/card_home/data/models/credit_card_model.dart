import '../../domain/entities/card_bill_info.dart';
import '../../domain/entities/credit_card.dart';

/// Data model extending [CreditCard] with JSON serialization.
///
/// For this assignment the data source is local/mock, but the model
/// is structured to support a future REST API.
class CreditCardModel extends CreditCard {
  const CreditCardModel({
    required super.id,
    required super.name,
    required super.variantLabel,
    required super.assetPath,
    required super.billInfo,
    super.lastFourDigits,
  });

  factory CreditCardModel.fromJson(Map<String, dynamic> json) {
    return CreditCardModel(
      id: json['id'] as String,
      name: json['name'] as String,
      variantLabel: json['variant_label'] as String,
      assetPath: json['asset_path'] as String,
      lastFourDigits: json['last_four'] as String? ?? '0000',
      billInfo: CardBillInfo(
        status: BillStatus.values.byName(json['bill_status'] as String),
        statusLabel: json['status_label'] as String,
        amountDue: (json['amount_due'] as num?)?.toDouble(),
        totalDue: (json['total_due'] as num?)?.toDouble(),
        nextBillDate: json['next_bill_date'] != null
            ? DateTime.parse(json['next_bill_date'] as String)
            : null,
        overdueDays: json['overdue_days'] as int?,
        promoText: json['promo_text'] as String?,
        promoRewardLabel: json['promo_reward_label'] as String?,
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'variant_label': variantLabel,
      'asset_path': assetPath,
      'last_four': lastFourDigits,
      'bill_status': billInfo.status.name,
      'status_label': billInfo.statusLabel,
      'amount_due': billInfo.amountDue,
      'total_due': billInfo.totalDue,
      'next_bill_date': billInfo.nextBillDate?.toIso8601String(),
      'overdue_days': billInfo.overdueDays,
      'promo_text': billInfo.promoText,
      'promo_reward_label': billInfo.promoRewardLabel,
    };
  }
}
