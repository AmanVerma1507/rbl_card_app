import 'package:equatable/equatable.dart';

/// Base class for all card carousel events.
abstract class CardCarouselEvent extends Equatable {
  const CardCarouselEvent();

  @override
  List<Object?> get props => [];
}

/// Triggers initial load of cards from the use case.
class LoadCards extends CardCarouselEvent {
  const LoadCards();
}

/// User selected a card by index (swipe or thumbnail tap).
class CardSelected extends CardCarouselEvent {
  const CardSelected(this.index);

  final int index;

  @override
  List<Object?> get props => [index];
}
