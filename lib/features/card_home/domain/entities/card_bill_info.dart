/// Billing status for a credit card.
enum BillStatus {
  /// Bill has been fully paid for the current cycle.
  paid,

  /// Bill is overdue — payment is past due date.
  overdue,

  /// Bill is upcoming — not yet due.
  upcoming,
}

/// Domain entity holding billing/payment information for a card.
class CardBillInfo {
  const CardBillInfo({
    required this.status,
    required this.statusLabel,
    this.amountDue,
    this.totalDue,
    this.nextBillDate,
    this.overdueDays,
    this.promoText,
    this.promoRewardLabel,
  });

  final BillStatus status;

  /// Human-readable label, e.g. "BILL PAID", "BILL OVERDUE BY 3 DAYS".
  final String statusLabel;

  /// Amount due in current billing cycle (null if paid).
  final double? amountDue;

  /// Total outstanding balance (may differ from current cycle due).
  final double? totalDue;

  /// Date the next bill is expected or the current bill is due.
  final DateTime? nextBillDate;

  /// Number of days overdue (only meaningful when status == overdue).
  final int? overdueDays;

  /// Promo banner copy text.
  final String? promoText;

  /// Promo reward unit, e.g. "RBL Coins", "Reward Points".
  final String? promoRewardLabel;
}
