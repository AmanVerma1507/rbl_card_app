import 'package:equatable/equatable.dart';
import '../../domain/entities/credit_card.dart';

/// Base class for all card carousel states.
abstract class CardCarouselState extends Equatable {
  const CardCarouselState();

  @override
  List<Object?> get props => [];
}

/// Waiting to load — emitted immediately on BLoC creation.
class CardCarouselInitial extends CardCarouselState {
  const CardCarouselInitial();
}

/// Fetching cards from the use case.
class CardCarouselLoading extends CardCarouselState {
  const CardCarouselLoading();
}

/// Cards successfully loaded; holds the full card list and selected index.
class CardCarouselLoaded extends CardCarouselState {
  const CardCarouselLoaded({
    required this.cards,
    required this.selectedIndex,
  });

  final List<CreditCard> cards;
  final int selectedIndex;

  CreditCard get selectedCard => cards[selectedIndex];

  /// Total outstanding across all cards.
  double get totalDue => cards.fold(
        0,
        (sum, card) => sum + (card.billInfo.totalDue ?? 0),
      );

  /// Number of cards with a non-zero balance.
  int get cardsWithDue =>
      cards.where((c) => (c.billInfo.totalDue ?? 0) > 0).length;

  CardCarouselLoaded copyWith({int? selectedIndex}) {
    return CardCarouselLoaded(
      cards: cards,
      selectedIndex: selectedIndex ?? this.selectedIndex,
    );
  }

  @override
  List<Object?> get props => [cards, selectedIndex];
}

/// An error occurred while loading cards.
class CardCarouselError extends CardCarouselState {
  const CardCarouselError(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}
