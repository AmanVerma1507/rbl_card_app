import '../entities/credit_card.dart';
import '../repositories/card_repository.dart';

/// Use case: fetch all cards for the current user.
///
/// Thin orchestration layer that separates BLoC from the repository contract.
class GetCardsUseCase {
  const GetCardsUseCase(this._repository);

  final CardRepository _repository;

  Future<List<CreditCard>> call() => _repository.getCards();
}
