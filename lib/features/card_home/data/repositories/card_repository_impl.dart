import '../../domain/entities/credit_card.dart';
import '../../domain/repositories/card_repository.dart';
import '../datasources/card_local_datasource.dart';

/// Concrete implementation of [CardRepository] backed by [CardLocalDatasource].
class CardRepositoryImpl implements CardRepository {
  const CardRepositoryImpl(this._datasource);

  final CardLocalDatasource _datasource;

  @override
  Future<List<CreditCard>> getCards() => _datasource.getCards();
}
