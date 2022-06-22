import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../blocs/blocs.dart';
import '../../../config/responsive.dart';
import '../../../generated/l10n.dart';
import '../../../utils/validators.dart';
import '/cubit/signup/signup_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../blocs/onboarding/onboarding_bloc.dart';
import '../../../models/models.dart';
import '../../../widgets/custom_button_gradiant.dart';

class RegisterForm extends StatefulWidget {
  final TabController tabController;

  const RegisterForm({Key? key, required this.tabController}) : super(key: key);

  @override
  State<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final GlobalKey<FormState> _formKeyReg = GlobalKey<FormState>();

  bool noShowPass = true;

  @override
  Widget build(BuildContext context) {
    final _contextRegister = context.read<SignupCubit>();
    return BlocBuilder<SignupCubit, SignupState>(
      builder: (context, state) {
        return Center(
          child: Form(
            key: _formKeyReg,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                //campo formulario CORREO
                TextFormField(
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.emailAddress,
                  style: Responsive.isMobile(context)
                      ? null
                      : Theme.of(context).textTheme.headline6,
                  decoration: InputDecoration(
                    // border: OutlineInputBorder(),
                    labelText: S.of(context).email,
                    icon: const Icon(Icons.email),
                  ),
                  validator: (email) => !Validators.isValidEmail(email!)
                      ? S.of(context).validator_email_error
                      : null,
                  onChanged: (text) {
                    _contextRegister.emailChanged(text);
                  },
                ),
                //campo formulario CONTRASENA
                TextFormField(
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.text,
                  obscureText: noShowPass,
                  style: Responsive.isMobile(context)
                      ? null
                      : Theme.of(context).textTheme.headline6,
                  decoration: InputDecoration(
                    // border: OutlineInputBorder(),
                    labelText: S.of(context).password,
                    icon: const Icon(Icons.lock),
                    suffixIcon: GestureDetector(
                      onTap: () {
                        noShowPass == true
                            ? noShowPass = false
                            : noShowPass = true;
                        setState(() {});
                      },
                      child: const Icon(Icons.remove_red_eye_outlined),
                    ),
                  ),
                  toolbarOptions: const ToolbarOptions(),
                  validator: (pass) => !Validators.isValidPassword(pass!)
                      ? S.of(context).validator_password_error
                      : null,
                  onChanged: (text) {
                    _contextRegister.passwordChanged(text);
                  },
                ),
                // const SizedBox(height: 10),
                CustomButtonGradiant(
                  height: Responsive.isMobile(context) ? 45 : 55,
                  width: Responsive.isMobile(context) ? 170 : 220,
                  icon: const Icon(
                    Icons.check,
                    color: Colors.white,
                  ),
                  text: Text(
                    S.of(context).bttn_register,
                    style: Responsive.isMobile(context)
                        ? Theme.of(context).textTheme.headline6?.copyWith(
                              color: Colors.white,
                            )
                        : Theme.of(context).textTheme.headline5?.copyWith(
                              color: Colors.white,
                            ),
                  ),
                  onPressed: () async {
                    // validator form
                    if (!_formKeyReg.currentState!.validate()) return;
                    // SignUp
                    await _contextRegister.signUpWithCredentials();
                    User user = User(
                      // created a empty user
                      id: _contextRegister.state.user!.uid,
                      name: '',
                      dateOfBirth: Timestamp.fromDate(DateTime.now()),
                      // gender: '',
                      role: 'user',
                      image: '',
                      interests: const [],
                      location: '',
                    );
                    context.read<OnboardingBloc>().add(
                          StartOnboarding(
                            user: user,
                          ),
                        );
                    return widget.tabController
                        .animateTo(widget.tabController.index + 1);
                  },
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    TextButton(
                      onPressed: () => widget.tabController
                          .animateTo(widget.tabController.index - 1),
                      child: Text(
                        S.of(context).bttn_go_back,
                        style: Responsive.isMobile(context)
                            ? null
                            : Theme.of(context).textTheme.headline6?.copyWith(
                                  color: Theme.of(context).primaryColor,
                                ),
                      ),
                    ),
                  ],
                ),
                // CustomButtonGradiant(
                //   //BUtton Registrar
                //   height: 45,
                //   width: 150,
                //   icon: const Icon(Icons.arrow_back, color: Colors.white),
                //   text: Text(
                //     S.of(context).bttn_go_back,
                //     style: const TextStyle(color: Colors.white),
                //   ),
                //   onPressed: () {
                //     tabController.animateTo(tabController.index - 1);
                //   },
                // ),
              ],
            ),
          ),
        );
      },
    );
  }
}
