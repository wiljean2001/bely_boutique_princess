// final theme = Provider.of<ThemeChanger>(context);

import 'package:bely_boutique_princess/generated/l10n.dart';
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
  @override
  Widget build(BuildContext context) {
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
      // TODO: Settings
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
                  YYNoticeDialog(context);
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
                onPressed: (BuildContext context) async =>
                    await _showMyDialog(theme),
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
                onPressed: (BuildContext context) {},
              ),
              SettingsTile(
                title: 'Cambiar contraseña',
                leading: const Icon(Icons.password_outlined),
                onPressed: (BuildContext context) {},
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
  themesAll? _character = themesAll.deffault;

  Future<void> _showMyDialog(ThemeChanger theme) async {
    ThemeData themeData = theme.getTheme();
    _character =
        themeData == ThemeData.dark() ? themesAll.dark : themesAll.deffault;
    return showDialog<void>(
      context: context,
      // barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Elegir tema',
            style: Theme.of(context).textTheme.headline4,
          ),
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
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  String _localizeLocale(BuildContext context, Locale locale) {
    if (locale == null) {
      return 'Lenguaje del sistema';
    } else {
      Future.delayed(
        Duration(seconds: 3),
        () {
          final localeString =
              LocaleNames.of(context)?.nameOf(locale.toString());
          print(localeString);
          //return localeString![0].toUpperCase() + localeString.substring(1);
          return 'Texto simple';
        },
      );
      return '';
    }
  }

  YYDialog YYNoticeDialog(BuildContext context) {
    return YYDialog().build(context)
      // ..width =
      // ..height = 110
      ..margin = const EdgeInsets.symmetric(horizontal: kPaddingM)
      ..backgroundColor =
          Theme.of(context).scaffoldBackgroundColor.withOpacity(0.9)
      ..borderRadius = 10.0
      ..showCallBack = () {
        print("showCallBack invoke");
      }
      ..dismissCallBack = () {
        print("dismissCallBack invoke");
      }
      ..widget(Padding(
        padding: const EdgeInsets.only(top: kPaddingS, bottom: kPaddingS),
        child: Column(
          children: S.delegate.supportedLocales
              .map((e) => ListTile(
                    title: Text(_localizeLocale(context, e)),
                  ))
              .toList(),
        ),
      ))
      // ..gravity = Gravity.bottom
      ..animatedFunc = (child, animation) {
        return ScaleTransition(
          child: child,
          scale: Tween(begin: 0.0, end: 1.0).animate(animation),
        );
      }
      ..show();
  }
}

/**
 * final ThemeChanger theme = Provider.of<ThemeChanger>(context);
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        iconTheme: Theme.of(context).iconTheme,
        elevation: 0,
      ),
      body: Padding(
        padding:
            const EdgeInsets.only(left: 20, right: 20, top: 110, bottom: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Configuraciones',
              style: Theme.of(context).textTheme.headlineLarge,
            ),
            Container(
              // seccion account
              child: Column(
                children: [
                  const SizedBox(height: 30),
                  Row(
                    children: [
                      const Icon(Icons.person_outline, size: 30),
                      const SizedBox(width: 25),
                      Text('Cuenta',
                          style: Theme.of(context).textTheme.headlineMedium),
                    ],
                  ),
                  const Divider(),
                  Row(
                    children: [
                      Text('Editar perfil',
                          style: Theme.of(context).textTheme.headlineSmall),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              child: Column(
                children: [
                  const SizedBox(height: 30),
                  Row(
                    children: [
                      const Icon(Icons.read_more_rounded, size: 30),
                      const SizedBox(width: 25),
                      Text('Extras',
                          style: Theme.of(context).textTheme.headlineMedium),
                    ],
                  ),
                  Divider(),
                  GestureDetector(
                    onTap: () async => await _showMyDialog(theme),
                    child: Row(
                      children: [
                        Text('Temas',
                            style: Theme.of(context).textTheme.headlineSmall),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
 */