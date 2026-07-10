import '../entities/credit_card.dart';

/// Abstract repository interface for card data.
/// The data layer provides the implementation.
abstract class CardRepository {
  /// Returns the list of credit cards owned by the user.
  Future<List<CreditCard>> getCards();
}
