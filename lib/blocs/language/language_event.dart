part of 'language_bloc.dart';

abstract class LanguageEvent extends Equatable {
  const LanguageEvent();

  @override
  List<Object> get props => [];
}

class ChangeLocale extends LanguageEvent {

  final Locale locale;
  const ChangeLocale(this.locale);

  @override
  List<Object> get props => [locale];
}
