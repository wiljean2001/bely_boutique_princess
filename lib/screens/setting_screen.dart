import 'package:bely_boutique_princess/generated/l10n.dart';
import 'package:bely_boutique_princess/screens/user/update_user_screen.dart';
import 'package:bely_boutique_princess/utils/custom_alert_dialog.dart';
import 'package:bely_boutique_princess/utils/show_alert.dart';
import 'package:bely_boutique_princess/utils/terms_conditions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localized_locales/flutter_localized_locales.dart';
import 'package:flutter_settings_ui/flutter_settings_ui.dart';

import '../blocs/blocs.dart';
import '../blocs/theme.dart';
import '../config/constrants.dart';
import '../config/theme_default.dart';
import 'package:provider/provider.dart';

import '../utils/validators.dart';
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
          S.of(context).title_settings_screen,
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        elevation: 0,
      ),
      // TODO : Settings
      body: SettingsList(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        sections: [
          SettingsSection(
            title: S.of(context).subtitle_general_settings,
            titleTextStyle: Theme.of(context).textTheme.headlineSmall,
            titlePadding: const EdgeInsets.only(left: 25, top: 10),
            tiles: [
              // option language
              SettingsTile(
                title: S.of(context).option_language,
                leading: const Icon(Icons.language_outlined),
                onPressed: (BuildContext context) {
                  // Custom Alert Dialog
                  CustomAlertDialog.contentButtonAndTitle(
                    context: context,
                    content: Column(
                      children: S.delegate.supportedLocales
                          .map(
                            (e) => ListTile(
                              title: Text(_localizeLocale(context, e)),
                              onTap: () {
                                context.read<LanguageBloc>().add(
                                      ChangeLocale(locale: e),
                                    );
                                Navigator.pop(context);
                              },
                            ),
                          )
                          .toList(),
                    ),
                    title: Text(
                      S.of(context).title_select_language_option,
                      style: Theme.of(context).textTheme.headline6,
                    ),
                  );
                },
              ),
              // Option Notifications
              SettingsTile.switchTile(
                title: S.of(context).option_notifications,
                leading: const Icon(Icons.notifications_outlined),
                switchValue: true,
                onToggle: (bool value) {
                  ShowAlert.showAlertSnackBar(
                    context,
                    message: S.of(context).error_desc,
                  );
                },
              ),
              // Option Theme
              SettingsTile(
                  title: S.of(context).option_theme,
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
                              title: Text(S.of(context).title_theme_default),
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
                              title: Text(S.of(context).title_theme_dark),
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
                        S.of(context).title_theme,
                        style: Theme.of(context).textTheme.headline6,
                      ),
                    );
                  }
                  // await _showMyDialog(theme),
                  ),
            ],
          ),
          SettingsSection(
            title: S.of(context).subtitle_account_settings,
            titleTextStyle: Theme.of(context).textTheme.headlineSmall,
            titlePadding: const EdgeInsets.only(left: 25, top: 10),
            tiles: [
              SettingsTile(
                title: S.of(context).option_edit_profile,
                leading: const Icon(Icons.edit_outlined),
                onPressed: (BuildContext context) {
                  Navigator.pushNamed(context, UpdateUserScreen.routeName);
                },
              ),
              SettingsTile(
                title: S.of(context).option_edit_password,
                leading: const Icon(Icons.password_outlined),
                onPressed: (BuildContext context) => _changePassword(context),
              ),
              SettingsTile(
                title: S.of(context).option_term_conditions,
                leading: const Icon(Icons.text_snippet_outlined),
                onPressed: (BuildContext context) {
                  Navigator.pushNamed(context, TermsConditions.routeName);
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _localizeLocale(BuildContext context, Locale locale) {
    if (locale == null) {
      return '';
    } else {
      final localeString = LocaleNames.of(context)?.nameOf(
        locale.toString(),
      );
      return localeString!;
    }
  }

  String? newPassword, currentPassword;
  _changePassword(BuildContext context) {
    CustomAlertDialog.contentButtonAndTitle(
      context: context,
      content: StatefulBuilder(
        builder: (context, setState) {
          return Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    labelText: S.of(context).text_current_password,
                  ),
                  validator: (pass) =>
                      !Validators.isValidPassword(pass!) ? '' : null,
                  // Validators.ispasswordValidator(pass!, context),
                  onSaved: (value) {
                    currentPassword = value;
                  },
                ),
                const SizedBox(height: kPaddingS),
                TextFormField(
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    labelText: S.of(context).text_new_password,
                  ),
                  validator: (pass) => !Validators.isValidPassword(pass!)
                      ? S.of(context).validator_password_error
                      : null,
                  // Validators.ispasswordValidator(pass!, context),
                  onSaved: (value) {
                    newPassword = value;
                  },
                ),
                OutlinedButton(
                  onPressed: () {
                    if (!_formKey.currentState!.validate()) return;
                    _formKey.currentState!.save();
                    context.read<AuthBloc>().add(
                          AuthUserPasswordChanged(
                            currentPassword: currentPassword!,
                            newPassword: newPassword!,
                          ),
                        );
                  },
                  child: Text(S.of(context).button_text_changue_password),
                ),
              ],
            ),
          );
        },
      ),
      title: Text(S.of(context).button_text_changue_password),
    );
  }
}
