import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_cards_usecase.dart';
import 'card_carousel_event.dart';
import 'card_carousel_state.dart';

/// BLoC managing the card carousel — card list, selection, and derived bill data.
///
/// Business logic is fully contained here; widgets only dispatch events
/// and react to emitted states.
class CardCarouselBloc extends Bloc<CardCarouselEvent, CardCarouselState> {
  CardCarouselBloc(this._getCardsUseCase) : super(const CardCarouselInitial()) {
    on<LoadCards>(_onLoadCards);
    on<CardSelected>(_onCardSelected);
  }

  final GetCardsUseCase _getCardsUseCase;

  Future<void> _onLoadCards(
    LoadCards event,
    Emitter<CardCarouselState> emit,
  ) async {
    emit(const CardCarouselLoading());
    try {
      final cards = await _getCardsUseCase();
      emit(CardCarouselLoaded(cards: cards, selectedIndex: 0));
    } catch (e) {
      emit(CardCarouselError('Failed to load cards: $e'));
    }
  }

  void _onCardSelected(
    CardSelected event,
    Emitter<CardCarouselState> emit,
  ) {
    final current = state;
    if (current is CardCarouselLoaded) {
      if (event.index < 0 || event.index > current.cards.length) return;
      emit(current.copyWith(selectedIndex: event.index));
    }
  }
}
