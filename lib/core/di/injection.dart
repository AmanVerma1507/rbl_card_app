import 'package:get_it/get_it.dart';
import '../../features/card_home/data/datasources/card_local_datasource.dart';
import '../../features/card_home/data/repositories/card_repository_impl.dart';
import '../../features/card_home/domain/repositories/card_repository.dart';
import '../../features/card_home/domain/usecases/get_cards_usecase.dart';
import '../../features/card_home/presentation/bloc/card_carousel_bloc.dart';

/// Global service locator instance.
final GetIt getIt = GetIt.instance;

/// Registers all dependencies into [GetIt].
///
/// Call this once from [main] before [runApp].
void setupDependencies() {
  // ── Data sources ────────────────────────────────────────────
  getIt.registerLazySingleton<CardLocalDatasource>(
    () => CardLocalDatasource(),
  );

  // ── Repositories ────────────────────────────────────────────
  getIt.registerLazySingleton<CardRepository>(
    () => CardRepositoryImpl(getIt<CardLocalDatasource>()),
  );

  // ── Use cases ───────────────────────────────────────────────
  getIt.registerLazySingleton<GetCardsUseCase>(
    () => GetCardsUseCase(getIt<CardRepository>()),
  );

  // ── BLoC (factory: new instance per page visit) ─────────────
  getIt.registerFactory<CardCarouselBloc>(
    () => CardCarouselBloc(getIt<GetCardsUseCase>()),
  );
}
