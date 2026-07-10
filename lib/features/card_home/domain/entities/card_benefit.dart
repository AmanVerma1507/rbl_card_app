/// Domain entity for a single cashback / reward benefit on a credit card.
class CardBenefit {
  const CardBenefit({
    required this.percentage,
    required this.title,
    required this.description,
    required this.iconAssetPath,
  });

  /// Display percentage, e.g. "1.5%", "Flat 5%".
  final String percentage;

  /// Short label, e.g. "Cashback".
  final String title;

  /// Sub-description shown beneath the percentage + title.
  final String description;

  /// Asset path to the right-side icon image.
  final String iconAssetPath;
}
