import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'dart:ui';
import '../../repositories/language/preferences_repository.dart';

part 'language_event.dart';
part 'language_state.dart';

class LanguageBloc extends Bloc<LanguageEvent, LanguageState> {
  final PreferencesRepository _preferencesRepository;
  final PreferencesState _initialState;

  LanguageBloc({
    required PreferencesRepository preferencesRepository,
    required Locale initialLocale,
  })  : assert(preferencesRepository != null),
        _preferencesRepository = preferencesRepository,
        _initialState = PreferencesState(locale: initialLocale),
        super(
          LanguageInitial(),
        );

  @override
  PreferencesState get initialState => _initialState;

  @override
  Stream<PreferencesState> mapEventToState(
    LanguageEvent event,
  ) async* {
    if (event is ChangeLocale) {
      await _preferencesRepository.saveLocale(event.locale);
      yield PreferencesState(locale: event.locale);
    }
  }
}
