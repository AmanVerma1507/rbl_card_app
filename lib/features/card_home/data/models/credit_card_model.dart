import '../../domain/entities/card_benefit.dart';
import '../../domain/entities/card_bill_info.dart';
import '../../domain/entities/credit_card.dart';

/// Data model extending [CreditCard] with JSON serialization.
class CreditCardModel extends CreditCard {
  const CreditCardModel({
    required super.id,
    required super.name,
    required super.variantLabel,
    required super.assetPath,
    required super.billInfo,
    super.lastFourDigits,
    super.annualFee,
    super.joiningFee,
    super.hiddenCharges,
    super.benefits,
  });

  factory CreditCardModel.fromJson(Map<String, dynamic> json) {
    return CreditCardModel(
      id: json['id'] as String,
      name: json['name'] as String,
      variantLabel: json['variant_label'] as String,
      assetPath: json['asset_path'] as String,
      lastFourDigits: json['last_four'] as String? ?? '0000',
      annualFee: (json['annual_fee'] as num?)?.toDouble() ?? 0,
      joiningFee: (json['joining_fee'] as num?)?.toDouble() ?? 0,
      hiddenCharges: (json['hidden_charges'] as num?)?.toDouble() ?? 0,
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
      benefits: (json['benefits'] as List<dynamic>?)
              ?.map((b) => CardBenefit(
                    percentage: b['percentage'] as String,
                    title: b['title'] as String,
                    description: b['description'] as String,
                    iconAssetPath: b['icon_asset_path'] as String,
                  ))
              .toList() ??
          const [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'variant_label': variantLabel,
      'asset_path': assetPath,
      'last_four': lastFourDigits,
      'annual_fee': annualFee,
      'joining_fee': joiningFee,
      'hidden_charges': hiddenCharges,
      'bill_status': billInfo.status.name,
      'status_label': billInfo.statusLabel,
      'amount_due': billInfo.amountDue,
      'total_due': billInfo.totalDue,
      'next_bill_date': billInfo.nextBillDate?.toIso8601String(),
      'overdue_days': billInfo.overdueDays,
      'promo_text': billInfo.promoText,
      'promo_reward_label': billInfo.promoRewardLabel,
      'benefits': benefits
          .map((b) => {
                'percentage': b.percentage,
                'title': b.title,
                'description': b.description,
                'icon_asset_path': b.iconAssetPath,
              })
          .toList(),
    };
  }
}
