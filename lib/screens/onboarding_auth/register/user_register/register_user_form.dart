import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../../../blocs/blocs.dart';
import '../../../../config/responsive.dart';
import '../../../../generated/l10n.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../utils/validators.dart';
import '../../../../widgets/custom_button_gradiant.dart';

class RegisterUserForm extends StatefulWidget {
  final TabController tabController;

  const RegisterUserForm({Key? key, required this.tabController})
      : super(key: key);

  @override
  State<RegisterUserForm> createState() => _RegisterUserFormState();
}

class _RegisterUserFormState extends State<RegisterUserForm> {
  String? dropdownValue;
  // String? name;
  final GlobalKey<FormState> _formKeyUser = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OnboardingBloc, OnboardingState>(
      builder: (context, state) {
        if (state is OnboardingLoaded) {
          DateTime? picked;
          // date picker
          Future<void> _showDatePicker() async {
            picked = await showDatePicker(
              context: context,
              initialDate: DateTime((DateTime.now().year - 18)),
              firstDate: DateTime(1900),
              lastDate: DateTime(DateTime.now().year - 18),
              locale: const Locale('es', 'ES'),
              // (2101)
            );
            // Date ->
            picked != null
                ? context.read<OnboardingBloc>().add(
                      UpdateUser(
                        user: state.user.copyWith(
                          dateOfBirth: Timestamp.fromDate(picked!),
                        ),
                      ),
                    )
                : null;
          }

          return Center(
            child: Form(
              key: _formKeyUser,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  //campo formulario NOMBRE
                  TextFormField(
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.name,
                    style: Responsive.isMobile(context)
                        ? null
                        : Theme.of(context).textTheme.headline6,
                    decoration: InputDecoration(
                      // border: OutlineInputBorder(),
                      labelText: S.of(context).title_user_name_desc,
                      icon: const Icon(Icons.person),
                    ),
                    validator: (name) => Validators.isValidateOnlyTextMinMax(
                      text: name!,
                      minCaracter: 3,
                      maxCarater: 50,
                      messageError: S.of(context).title_user_error_name,
                    ),
                    onChanged: (value) {
                      context.read<OnboardingBloc>().add(
                            UpdateUser(user: state.user.copyWith(name: value)),
                          );
                      // name = value;
                    },
                  ),
                  TextFormField(
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.name,
                    style: Responsive.isMobile(context)
                        ? null
                        : Theme.of(context).textTheme.headline6,
                    decoration: InputDecoration(
                      // border: OutlineInputBorder(),
                      labelText: S.of(context).title_user_location_desc,
                      icon: const Icon(Icons.person),
                    ),
                    validator: (location) =>
                        Validators.isValidateOnlyTextMinMax(
                      text: location!,
                      minCaracter: 5,
                      maxCarater: 100,
                      messageError: S.of(context).title_user_error_location,
                    ),
                    onChanged: (value) {
                      context.read<OnboardingBloc>().add(
                            UpdateUser(
                              user: state.user.copyWith(location: value),
                            ),
                          );
                      // name = value;
                    },
                  ),
                  // Intertar mas secciones
                  // const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Icon(Icons.date_range, size: 45),
                      const SizedBox(width: 25),
                      Expanded(
                        child: MaterialButton(
                          height: 55,
                          child: Text(
                            S.of(context).bttn_date_birth,
                            style: Responsive.isMobile(context)
                                ? null
                                : Theme.of(context).textTheme.headline6,
                          ),
                          onPressed: _showDatePicker,
                          color: const Color.fromARGB(225, 242, 203, 208),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  //
                  CustomButtonGradiant(
                    height: Responsive.isMobile(context) ? 45 : 55,
                    width: Responsive.isMobile(context) ? 180 : 220,
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
                      if (!_formKeyUser.currentState!.validate() &&
                          picked == null) return;
                      widget.tabController.animateTo(
                        widget.tabController.index + 1,
                        curve: Curves.elasticIn,
                      );
                    },
                  ),
                ],
              ),
            ),
          );
        } else {
          return Text(S.of(context).error_desc);
        }
      },
    );
  }
}
// final listGender = <String>[
    //   S.of(context).gender_male, // male
    //   S.of(context).gender_female, // female
    // ];
                  // Genero
                  // SizedBox(
                  //   width: double.infinity,
                  //   height: 55,
                  //   child: DropdownButton<String>(
                  //     isExpanded: true,
                  //     hint: const Text('Sexo'),
                  //     focusColor: Colors.pink,
                  //     value: dropdownValue,
                  //     icon: const Icon(
                  //       Icons.keyboard_arrow_down_outlined,
                  //       size: 45,
                  //     ),
                  //     elevation: 16,
                  //     style: const TextStyle(
                  //         color: Colors.deepPurple, fontSize: 18),
                  //     borderRadius: const BorderRadius.all(Radius.circular(10)),
                  //     underline: Container(
                  //       height: 2,
                  //       color: Colors.black12,
                  //     ),
                  //     // cambiar por tipo Categorias
                  //     items: listGender.map<DropdownMenuItem<String>>(
                  //       (String value) {
                  //         return DropdownMenuItem<String>(
                  //           value: value,
                  //           child: Text(value),
                  //         );
                  //       },
                  //     ).toList(),

                  //     onChanged: (index) {
                  //       setState(() {
                  //         dropdownValue = index!;
                  //         context.read<OnboardingBloc>().add(UpdateUser(
                  //               user: state.user.copyWith(gender: index),
                  //             ));
                  //       });
                  //     },
                  //   ),
                  // ),
