// final theme = Provider.of<ThemeChanger>(context);

import 'package:bely_boutique_princess/generated/l10n.dart';
import 'package:bely_boutique_princess/screens/user/update_user_screen.dart';
import 'package:bely_boutique_princess/utils/custom_alert_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_custom_dialog/flutter_custom_dialog.dart';
import 'package:flutter_localized_locales/flutter_localized_locales.dart';
import 'package:flutter_settings_ui/flutter_settings_ui.dart';

import '../blocs/blocs.dart';
import '../blocs/theme.dart';
import '../config/constrants.dart';
import '../config/theme_default.dart';
import 'package:provider/provider.dart';

import '../models/user_model.dart';
import 'onboarding_auth/onboarding_screen.dart';

enum themesAll { dark, light, deffault, otro }

// falta cambiar los textos a dinamicos

class SettingScreen extends StatefulWidget {
  static const String routeName = '/settings'; //route

  static Route route() {
    return MaterialPageRoute(
        settings: const RouteSettings(name: routeName),
        builder: (context) {
          return BlocProvider.of<AuthBloc>(context).state.status ==
                  AuthStatus.unauthenticated
              ? const OnboardingScreen()
              : const SettingScreen();
        });
  }

  const SettingScreen({Key? key}) : super(key: key);

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    themesAll? _character = themesAll.deffault;
    final ThemeChanger theme = Provider.of<ThemeChanger>(context);
    return Scaffold(
      // extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        iconTheme: Theme.of(context).iconTheme,
        title: Text(
          'Configuraciones',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        elevation: 0,
      ),
      // TODO : Settings
      body: SettingsList(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        sections: [
          SettingsSection(
            title: 'General',
            titleTextStyle: Theme.of(context).textTheme.headlineSmall,
            titlePadding: const EdgeInsets.only(left: 25, top: 10),
            tiles: [
              SettingsTile(
                title: 'Lenguaje',
                leading: const Icon(Icons.language_outlined),
                onPressed: (BuildContext context) {
                  // context.read<LanguageBloc>().add(ChangeLocale(S.delegate.supportedLocales));
                  // YYNoticeDialog(context);
                  CustomAlertDialog.contentButtonAndTitle(
                    context: context,
                    content: Column(
                      children: S.delegate.supportedLocales
                          .map(
                            (e) => ListTile(
                              title: Text(_localizeLocale(context, e)),
                              onTap: () {
                                // BlocProvider.of<LanguageBloc>(context)
                                //     .add(ChangeLocale(e));
                                print('CLICK');
                                context
                                    .read<LanguageBloc>()
                                    .add(ChangeLocale(e));
                              },
                            ),
                          )
                          .toList(),
                    ),
                    title: Text(
                      'Seleccionar un idioma',
                      style: Theme.of(context).textTheme.headline6,
                    ),
                  );
                },
              ),
              SettingsTile.switchTile(
                title: 'Notificaciones',
                leading: const Icon(Icons.notifications_outlined),
                switchValue: true,
                onToggle: (bool value) {},
              ),
              SettingsTile(
                  title: 'Tema',
                  leading: const Icon(Icons.palette_outlined),
                  onPressed: (BuildContext context) async {
                    ThemeData themeData = theme.getTheme();
                    _character = themeData == ThemeData.dark()
                        ? themesAll.dark
                        : themesAll.deffault;
                    return CustomAlertDialog.contentButtonAndTitle(
                      context: context,
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(
                            height: 50,
                            width: double.infinity,
                            child: ListTile(
                              title: const Text('Por defecto'),
                              leading: Radio<themesAll>(
                                value: themesAll.deffault,
                                groupValue: _character,
                                onChanged: (themesAll? value) {
                                  setState(() {
                                    _character = value;
                                    theme.setTheme(themeDefault());
                                    Navigator.of(context).pop();
                                  });
                                },
                              ),
                              onTap: () {
                                theme.setTheme(themeDefault());
                                Navigator.of(context).pop();
                              },
                            ),
                          ),
                          SizedBox(
                            height: 50,
                            width: double.infinity,
                            child: ListTile(
                              title: const Text('Oscuro'),
                              leading: Radio<themesAll>(
                                value: themesAll.dark,
                                groupValue: _character,
                                onChanged: (themesAll? value) {
                                  setState(() {
                                    _character = value;
                                    theme.setTheme(ThemeData.dark());
                                    Navigator.of(context).pop();
                                  });
                                },
                              ),
                              onTap: () {
                                theme.setTheme(ThemeData.dark());
                                Navigator.of(context).pop();
                              },
                            ),
                          ),
                        ],
                      ),
                      title: Text(
                        'Elegir tema',
                        style: Theme.of(context).textTheme.headline6,
                      ),
                    );
                  }
                  // await _showMyDialog(theme),
                  ),
            ],
          ),
          SettingsSection(
            title: 'Cuenta',
            titleTextStyle: Theme.of(context).textTheme.headlineSmall,
            titlePadding: const EdgeInsets.only(left: 25, top: 10),
            tiles: [
              SettingsTile(
                title: 'Editar perfil',
                leading: const Icon(Icons.edit_outlined),
                onPressed: (BuildContext context) {
                  Navigator.pushNamed(context, UpdateUserScreen.routeName);
                },
              ),
              SettingsTile(
                title: 'Cambiar contraseña',
                leading: const Icon(Icons.password_outlined),
                onPressed: (BuildContext context) => _changePassword(context),
              ),
            ],
          ),
        ],
      ),
    );
  }

// SettingsTile.switchTile(
  //   title: 'Use fingerprint',
  //   leading: const Icon(Icons.fingerprint),
  //   switchValue: true,
  //   onToggle: (bool value) {},
  // ),

  // Future<void> _showMyDialog(ThemeChanger theme) async {

  //   return showDialog<void>(
  //     context: context,
  //     // barrierDismissible: false, // user must tap button!
  //     builder: (BuildContext context) {
  //       return AlertDialog(
  //         title:
  //         content:
  //       );
  //     },
  //   );
  // }

  String _localizeLocale(BuildContext context, Locale locale) {
    if (locale == null) {
      return 'Lenguaje del sistema';
    } else {
      // print(LocaleNames.of(context)?.nameOf(locale.toString()));
      final localeString = LocaleNames.of(context)?.nameOf(
        locale.toString(),
      );
      return localeString!;
    }
  }

  _changePassword(BuildContext context) {
    CustomAlertDialog.contentButtonAndTitle(
        context: context,
        content: Form(
            key: _formKey,
            child: Column(
              children: [
                TextField(
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Contraseña actual',
                  ),
                )
              ],
            )),
        title: const Text("Cambiar contraseña"));
  }
}
