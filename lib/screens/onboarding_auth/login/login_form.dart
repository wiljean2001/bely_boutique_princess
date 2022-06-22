import 'package:bely_boutique_princess/utils/show_alert.dart';
import 'package:bely_boutique_princess/utils/validators.dart';

import '../../../blocs/auth/auth_bloc.dart';
import '../../../blocs/blocs.dart';
import '../../../config/responsive.dart';
import '../../../generated/l10n.dart';
import '/cubit/cubits.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../widgets/custom_button_gradiant.dart';

class LoginForm extends StatefulWidget {
  final TabController tabController;

  const LoginForm({Key? key, required this.tabController}) : super(key: key);

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool noShowPass = true;

  @override
  Widget build(BuildContext context) {
    final _contextSignUp = context.read<SignupCubit>();
    return BlocBuilder<SignupCubit, SignupState>(
      builder: (context, state) {
        return Center(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                // Text(
                //   S.of(context).title_sign_in,
                //   style: Theme.of(context).textTheme.headlineLarge,
                // ),
                Text(
                  S.of(context).description_login,
                  style: Responsive.isMobile(context)
                      ? Theme.of(context)
                          .textTheme
                          .headline6
                          ?.copyWith(color: Colors.black.withOpacity(.5))
                      : Theme.of(context)
                          .textTheme
                          .headline5
                          ?.copyWith(color: Colors.black.withOpacity(.5)),
                  textAlign: TextAlign.center,
                ),
                TextFormField(
                  textInputAction: TextInputAction.next,
                  style: Responsive.isMobile(context)
                      ? null
                      : Theme.of(context).textTheme.headline6,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    labelText: S.of(context).email,
                    icon: const Icon(Icons.email),
                  ),
                  validator: (email) => !Validators.isValidEmail(email!)
                      ? S.of(context).validator_email_error
                      : null,
                  onChanged: (value) {
                    _contextSignUp.emailChanged(value);
                  },
                ),
                TextFormField(
                  textInputAction: TextInputAction.next,
                  obscureText: noShowPass,
                  style: Responsive.isMobile(context)
                      ? null
                      : Theme.of(context).textTheme.headline6,
                  decoration: InputDecoration(
                    labelText: S.of(context).password,
                    icon: const Icon(Icons.lock),
                    suffixIcon: GestureDetector(
                      onTap: () {
                        setState(() {
                          noShowPass == true
                              ? noShowPass = false
                              : noShowPass = true;
                        });
                      },
                      child: const Icon(Icons.remove_red_eye_outlined),
                    ),
                  ),
                  toolbarOptions: const ToolbarOptions(),
                  validator: (pass) => !Validators.isValidPassword(pass!)
                      ? S.of(context).validator_password_error
                      : null,
                  // Validators.ispasswordValidator(pass!, context),
                  onChanged: (value) {
                    _contextSignUp.passwordChanged(value);
                  },
                ),
                CustomButtonGradiant(
                  // SignIn
                  height: Responsive.isMobile(context) ? 45 : 55,
                  width: Responsive.isMobile(context) ? 150 : 200,
                  icon: const Icon(Icons.check, color: Colors.white),
                  text: Text(
                    S.of(context).bttn_login,
                    style: Responsive.isMobile(context)
                        ? Theme.of(context)
                            .textTheme
                            .headline6
                            ?.copyWith(color: Colors.white)
                        : Theme.of(context)
                            .textTheme
                            .headline5
                            ?.copyWith(color: Colors.white),
                  ),
                  onPressed: () async {
                    if (!_formKey.currentState!.validate()) {
                      return;
                    }
                    await _contextSignUp.signInWithCredentials();
                    if (_contextSignUp.state.status == SignupStatus.success) {
                      // go to home screen
                      Navigator.pushNamedAndRemoveUntil(
                        context,
                        '/',
                        (route) => false,
                      );
                    }
                    ShowAlert.showErrorSnackBar(
                      context,
                      message: S.of(context).validator_user_existent,
                    );
                  },
                ),
                // const SizedBox(height: 5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => widget.tabController
                          .animateTo(widget.tabController.index + 1),
                      child: Text(
                        S.of(context).bttn_register,
                        style: Responsive.isMobile(context)
                            ? null
                            : Theme.of(context).textTheme.headline6?.copyWith(
                                  color: Theme.of(context).primaryColor,
                                ),
                      ),
                    )
                    // CustomButtonGradiant(
                    //   height: 45,
                    //   icon: const Icon(Icons.backspace, color: Colors.white),
                    //   text: Text(
                    //     S.of(context).bttn_go_back,
                    //     style: const TextStyle(color: Colors.white),
                    //   ),
                    //   onPressed: () =>
                    //       tabController.animateTo(tabController.index - 1),
                    //   width: 150,
                    // ),
                    //icon:
                    // const Icon(Icons.arrow_forward, color: Colors.white),
                    //  tabController.animateTo(tabController.index + 1),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
// await showDialog(
//   context: context,
//   builder: (BuildContext context) => AlertDialog(
//     title: Text(S.of(context).error_title),
//     content: Text(S.of(context).error_desc),
//   ),
// );
// await _contextSignUp.signInWithCredentials().then(
//   (value) {
//     context.read<AuthBloc>().add(
//           AuthUserChanged(user: _contextSignUp.state.user),
//         );
//     if (_contextSignUp.state.status ==
//         SignupStatus.success) {
//       // go to home screen
//       Navigator.pushNamedAndRemoveUntil(
//           context, '/', (route) => false);
//     }
//   },
// ).onError(
//   (error, stackTrace) async => await showDialog(
//     context: context,
//     builder: (BuildContext context) => AlertDialog(
//       title: Text(S.of(context).error_title),
//       content: Text(S.of(context).error_desc),
//     ),
//   ),
// );