import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'dart:ui';
import '../../repositories/language/preferences_repository.dart';
import '../../repositories/language/preferences_repository_impl.dart';

part 'language_event.dart';
part 'language_state.dart';

class LanguageBloc extends Bloc<LanguageEvent, LanguageState> {
  final PreferencesRepositoryImpl _preferencesRepository;
  final PreferencesState _initialState;

  LanguageBloc({
    required PreferencesRepositoryImpl preferencesRepository,
    required Locale initialLocale,
  })  : assert(preferencesRepository != null),
        _preferencesRepository = preferencesRepository,
        _initialState = PreferencesState(locale: initialLocale),
        super(
          PreferencesState(locale: initialLocale),
        ) {
    on<ChangeLocale>(_onchangelocale);
  }
  
  void _onchangelocale(
    ChangeLocale event,
    Emitter<LanguageState> emit,
  ) async {
    await _preferencesRepository.saveLocale(event.locale);
    emit(PreferencesState(locale: event.locale));
  }
}
