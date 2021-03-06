// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(_current != null,
        'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.');
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(instance != null,
        'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?');
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `Bely Boutique Princess`
  String get AppTitle {
    return Intl.message(
      'Bely Boutique Princess',
      name: 'AppTitle',
      desc: '',
      args: [],
    );
  }

  /// `Error`
  String get error_title {
    return Intl.message(
      'Error',
      name: 'error_title',
      desc: '',
      args: [],
    );
  }

  /// `Algo salió mal`
  String get error_desc {
    return Intl.message(
      'Algo salió mal',
      name: 'error_desc',
      desc: '',
      args: [],
    );
  }

  /// `Búscanos como...`
  String get option_visit {
    return Intl.message(
      'Búscanos como...',
      name: 'option_visit',
      desc: '',
      args: [],
    );
  }

  /// `Cerrar Sesión`
  String get option_sign_out {
    return Intl.message(
      'Cerrar Sesión',
      name: 'option_sign_out',
      desc: '',
      args: [],
    );
  }

  /// ` // HOME SCREENS `
  String get COMMENT1 {
    return Intl.message(
      ' // HOME SCREENS ',
      name: 'COMMENT1',
      desc: '',
      args: [],
    );
  }

  /// `Cesta`
  String get shopping_card_screen {
    return Intl.message(
      'Cesta',
      name: 'shopping_card_screen',
      desc: '',
      args: [],
    );
  }

  /// `Cesta`
  String get tooltip_bttn_shopping_card {
    return Intl.message(
      'Cesta',
      name: 'tooltip_bttn_shopping_card',
      desc: '',
      args: [],
    );
  }

  /// `Buscar`
  String get tooltip_bttn_search_products {
    return Intl.message(
      'Buscar',
      name: 'tooltip_bttn_search_products',
      desc: '',
      args: [],
    );
  }

  /// `Error al cargar las interfaces`
  String get Error_displaying_interaces {
    return Intl.message(
      'Error al cargar las interfaces',
      name: 'Error_displaying_interaces',
      desc: '',
      args: [],
    );
  }

  /// ` // ONBOARDING SCREENS `
  String get COMMENT2 {
    return Intl.message(
      ' // ONBOARDING SCREENS ',
      name: 'COMMENT2',
      desc: '',
      args: [],
    );
  }

  /// `Bienvenido`
  String get title_app {
    return Intl.message(
      'Bienvenido',
      name: 'title_app',
      desc: '',
      args: [],
    );
  }

  /// `Esta es una tienda que se dedica a vender vestidos para las princesas de casa.`
  String get description_app {
    return Intl.message(
      'Esta es una tienda que se dedica a vender vestidos para las princesas de casa.',
      name: 'description_app',
      desc: '',
      args: [],
    );
  }

  /// `Inicia sesión con una cuenta existente de Bely Boutique Princess.`
  String get description_login {
    return Intl.message(
      'Inicia sesión con una cuenta existente de Bely Boutique Princess.',
      name: 'description_login',
      desc: '',
      args: [],
    );
  }

  /// `Empezar`
  String get bttn_start {
    return Intl.message(
      'Empezar',
      name: 'bttn_start',
      desc: '',
      args: [],
    );
  }

  /// `Correo electrónico o contraseña incorrecta.`
  String get validator_user_existent {
    return Intl.message(
      'Correo electrónico o contraseña incorrecta.',
      name: 'validator_user_existent',
      desc: '',
      args: [],
    );
  }

  /// `INICIAR SESIÓN`
  String get title_sign_in {
    return Intl.message(
      'INICIAR SESIÓN',
      name: 'title_sign_in',
      desc: '',
      args: [],
    );
  }

  /// `Correo electrónico`
  String get email {
    return Intl.message(
      'Correo electrónico',
      name: 'email',
      desc: '',
      args: [],
    );
  }

  /// `Correo no válido`
  String get validator_email_error {
    return Intl.message(
      'Correo no válido',
      name: 'validator_email_error',
      desc: '',
      args: [],
    );
  }

  /// `Nueva contraseña`
  String get password {
    return Intl.message(
      'Nueva contraseña',
      name: 'password',
      desc: '',
      args: [],
    );
  }

  /// `Contraseña no válida\n(Mínimo 8 caracteres, 1 letra mayúscula,\n1 carácter especial, 1 número).`
  String get validator_password_error {
    return Intl.message(
      'Contraseña no válida\n(Mínimo 8 caracteres, 1 letra mayúscula,\n1 carácter especial, 1 número).',
      name: 'validator_password_error',
      desc: '',
      args: [],
    );
  }

  /// `Registrarse`
  String get bttn_register {
    return Intl.message(
      'Registrarse',
      name: 'bttn_register',
      desc: '',
      args: [],
    );
  }

  /// `Registrar`
  String get title_register_screen {
    return Intl.message(
      'Registrar',
      name: 'title_register_screen',
      desc: '',
      args: [],
    );
  }

  /// `Error de registro`
  String get register_error_title {
    return Intl.message(
      'Error de registro',
      name: 'register_error_title',
      desc: '',
      args: [],
    );
  }

  /// `Usuario existente`
  String get register_error_desc {
    return Intl.message(
      'Usuario existente',
      name: 'register_error_desc',
      desc: '',
      args: [],
    );
  }

  /// `Ingresar`
  String get bttn_login {
    return Intl.message(
      'Ingresar',
      name: 'bttn_login',
      desc: '',
      args: [],
    );
  }

  /// `Regresar`
  String get bttn_go_back {
    return Intl.message(
      'Regresar',
      name: 'bttn_go_back',
      desc: '',
      args: [],
    );
  }

  /// `Usuario`
  String get title_user_screen {
    return Intl.message(
      'Usuario',
      name: 'title_user_screen',
      desc: '',
      args: [],
    );
  }

  /// `Ubicación`
  String get title_user_location {
    return Intl.message(
      'Ubicación',
      name: 'title_user_location',
      desc: '',
      args: [],
    );
  }

  /// `Ingresar ubicación`
  String get title_user_location_desc {
    return Intl.message(
      'Ingresar ubicación',
      name: 'title_user_location_desc',
      desc: '',
      args: [],
    );
  }

  /// `Ubicación no valido`
  String get title_user_error_location {
    return Intl.message(
      'Ubicación no valido',
      name: 'title_user_error_location',
      desc: '',
      args: [],
    );
  }

  /// `Nombre`
  String get title_user_name {
    return Intl.message(
      'Nombre',
      name: 'title_user_name',
      desc: '',
      args: [],
    );
  }

  /// `Ingresar nombre`
  String get title_user_name_desc {
    return Intl.message(
      'Ingresar nombre',
      name: 'title_user_name_desc',
      desc: '',
      args: [],
    );
  }

  /// `Nombre invalido`
  String get title_user_error_name {
    return Intl.message(
      'Nombre invalido',
      name: 'title_user_error_name',
      desc: '',
      args: [],
    );
  }

  /// `Sexo`
  String get gender {
    return Intl.message(
      'Sexo',
      name: 'gender',
      desc: '',
      args: [],
    );
  }

  /// `Femenino`
  String get gender_female {
    return Intl.message(
      'Femenino',
      name: 'gender_female',
      desc: '',
      args: [],
    );
  }

  /// `Seleccionar fecha de nacimiento`
  String get bttn_date_birth {
    return Intl.message(
      'Seleccionar fecha de nacimiento',
      name: 'bttn_date_birth',
      desc: '',
      args: [],
    );
  }

  /// `Seleccionar foto de perfil`
  String get title_picture_screen {
    return Intl.message(
      'Seleccionar foto de perfil',
      name: 'title_picture_screen',
      desc: '',
      args: [],
    );
  }

  /// `Imagen no seleccionada.`
  String get image_no_selected {
    return Intl.message(
      'Imagen no seleccionada.',
      name: 'image_no_selected',
      desc: '',
      args: [],
    );
  }

  /// `Subiendo imagen...`
  String get image_uploading {
    return Intl.message(
      'Subiendo imagen...',
      name: 'image_uploading',
      desc: '',
      args: [],
    );
  }

  /// ` // ADMIN BOARDING SCREENS `
  String get COMMENT3 {
    return Intl.message(
      ' // ADMIN BOARDING SCREENS ',
      name: 'COMMENT3',
      desc: '',
      args: [],
    );
  }

  /// `Administración`
  String get title_admin_screen {
    return Intl.message(
      'Administración',
      name: 'title_admin_screen',
      desc: '',
      args: [],
    );
  }

  /// `Administrador`
  String get title_administrator_screen {
    return Intl.message(
      'Administrador',
      name: 'title_administrator_screen',
      desc: '',
      args: [],
    );
  }

  /// `Usuarios con rol de: {role}`
  String role_user(Object role) {
    return Intl.message(
      'Usuarios con rol de: $role',
      name: 'role_user',
      desc: '',
      args: [role],
    );
  }

  /// `Masculino`
  String get gender_male {
    return Intl.message(
      'Masculino',
      name: 'gender_male',
      desc: '',
      args: [],
    );
  }

  /// `Vista de usuario`
  String get title_show_as_user {
    return Intl.message(
      'Vista de usuario',
      name: 'title_show_as_user',
      desc: '',
      args: [],
    );
  }

  /// `Panel de administración`
  String get title_dashboard_screen {
    return Intl.message(
      'Panel de administración',
      name: 'title_dashboard_screen',
      desc: '',
      args: [],
    );
  }

  /// `Tallas`
  String get title_size_screen {
    return Intl.message(
      'Tallas',
      name: 'title_size_screen',
      desc: '',
      args: [],
    );
  }

  /// `Productos`
  String get title_products {
    return Intl.message(
      'Productos',
      name: 'title_products',
      desc: '',
      args: [],
    );
  }

  /// `Roles`
  String get title_roles {
    return Intl.message(
      'Roles',
      name: 'title_roles',
      desc: '',
      args: [],
    );
  }

  /// `Tipo de productos`
  String get title_type_product {
    return Intl.message(
      'Tipo de productos',
      name: 'title_type_product',
      desc: '',
      args: [],
    );
  }

  /// `Agregar producto`
  String get title_create_product_screen {
    return Intl.message(
      'Agregar producto',
      name: 'title_create_product_screen',
      desc: '',
      args: [],
    );
  }

  /// `Actualizar producto`
  String get title_update_product_screen {
    return Intl.message(
      'Actualizar producto',
      name: 'title_update_product_screen',
      desc: '',
      args: [],
    );
  }

  /// `Ver producto`
  String get title_show_products_screen {
    return Intl.message(
      'Ver producto',
      name: 'title_show_products_screen',
      desc: '',
      args: [],
    );
  }

  /// `Categorías`
  String get title_categories {
    return Intl.message(
      'Categorías',
      name: 'title_categories',
      desc: '',
      args: [],
    );
  }

  /// `Crear categoría`
  String get title_create_category_screen {
    return Intl.message(
      'Crear categoría',
      name: 'title_create_category_screen',
      desc: '',
      args: [],
    );
  }

  /// `Actualizar categoría`
  String get title_update_category_screen {
    return Intl.message(
      'Actualizar categoría',
      name: 'title_update_category_screen',
      desc: '',
      args: [],
    );
  }

  /// `Ver categorias`
  String get title_show_categories_screen {
    return Intl.message(
      'Ver categorias',
      name: 'title_show_categories_screen',
      desc: '',
      args: [],
    );
  }

  /// `Editar Usuario`
  String get title_update_user_screen {
    return Intl.message(
      'Editar Usuario',
      name: 'title_update_user_screen',
      desc: '',
      args: [],
    );
  }

  /// ` // SETTINGS SCREENS `
  String get COMMENT4 {
    return Intl.message(
      ' // SETTINGS SCREENS ',
      name: 'COMMENT4',
      desc: '',
      args: [],
    );
  }

  /// `Configuraciones`
  String get title_settings_screen {
    return Intl.message(
      'Configuraciones',
      name: 'title_settings_screen',
      desc: '',
      args: [],
    );
  }

  /// `General`
  String get subtitle_general_settings {
    return Intl.message(
      'General',
      name: 'subtitle_general_settings',
      desc: '',
      args: [],
    );
  }

  /// `Lenguaje`
  String get option_language {
    return Intl.message(
      'Lenguaje',
      name: 'option_language',
      desc: '',
      args: [],
    );
  }

  /// `Seleccionar un idioma`
  String get title_select_language_option {
    return Intl.message(
      'Seleccionar un idioma',
      name: 'title_select_language_option',
      desc: '',
      args: [],
    );
  }

  /// `Notificaciones`
  String get option_notifications {
    return Intl.message(
      'Notificaciones',
      name: 'option_notifications',
      desc: '',
      args: [],
    );
  }

  /// `Tema`
  String get option_theme {
    return Intl.message(
      'Tema',
      name: 'option_theme',
      desc: '',
      args: [],
    );
  }

  /// `Elegir tema`
  String get title_theme {
    return Intl.message(
      'Elegir tema',
      name: 'title_theme',
      desc: '',
      args: [],
    );
  }

  /// `Por defecto`
  String get title_theme_default {
    return Intl.message(
      'Por defecto',
      name: 'title_theme_default',
      desc: '',
      args: [],
    );
  }

  /// `Oscuro`
  String get title_theme_dark {
    return Intl.message(
      'Oscuro',
      name: 'title_theme_dark',
      desc: '',
      args: [],
    );
  }

  /// `Cuenta`
  String get subtitle_account_settings {
    return Intl.message(
      'Cuenta',
      name: 'subtitle_account_settings',
      desc: '',
      args: [],
    );
  }

  /// `Editar perfil`
  String get option_edit_profile {
    return Intl.message(
      'Editar perfil',
      name: 'option_edit_profile',
      desc: '',
      args: [],
    );
  }

  /// `Cambiar contraseña`
  String get option_edit_password {
    return Intl.message(
      'Cambiar contraseña',
      name: 'option_edit_password',
      desc: '',
      args: [],
    );
  }

  /// `Contraseña actual`
  String get text_current_password {
    return Intl.message(
      'Contraseña actual',
      name: 'text_current_password',
      desc: '',
      args: [],
    );
  }

  /// `Contraseña actual`
  String get text_new_password {
    return Intl.message(
      'Contraseña actual',
      name: 'text_new_password',
      desc: '',
      args: [],
    );
  }

  /// `Cambiar contraseña`
  String get button_text_changue_password {
    return Intl.message(
      'Cambiar contraseña',
      name: 'button_text_changue_password',
      desc: '',
      args: [],
    );
  }

  /// `Terminos y condiciones`
  String get option_term_conditions {
    return Intl.message(
      'Terminos y condiciones',
      name: 'option_term_conditions',
      desc: '',
      args: [],
    );
  }

  /// `Ubícanos`
  String get title_map_screen {
    return Intl.message(
      'Ubícanos',
      name: 'title_map_screen',
      desc: '',
      args: [],
    );
  }

  /// `¿No estas registrado?`
  String get title_registration_question {
    return Intl.message(
      '¿No estas registrado?',
      name: 'title_registration_question',
      desc: '',
      args: [],
    );
  }

  /// `Terminos y condiciones`
  String get title_terms_conditions {
    return Intl.message(
      'Terminos y condiciones',
      name: 'title_terms_conditions',
      desc: '',
      args: [],
    );
  }

  /// ` // SETTINGS SCREENS `
  String get COMMENT5 {
    return Intl.message(
      ' // SETTINGS SCREENS ',
      name: 'COMMENT5',
      desc: '',
      args: [],
    );
  }

  /// `Ver ordenes`
  String get title_show_details_order {
    return Intl.message(
      'Ver ordenes',
      name: 'title_show_details_order',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'es'),
      Locale.fromSubtags(languageCode: 'en'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
