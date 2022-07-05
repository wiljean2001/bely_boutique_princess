import 'package:bely_boutique_princess/blocs/blocs.dart';
import 'package:bely_boutique_princess/utils/show_alert.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import '../../blocs/profile/profile_bloc.dart';
import '../../config/constrants.dart';
import '../../config/responsive.dart';
import '../../generated/l10n.dart';
import '../../models/user_model.dart';
import '../../utils/custom_alert_dialog.dart';
import '../../utils/validators.dart';
import '../../widgets/custom_image_container.dart';
import '../../widgets/custom_sliver_app_bar.dart';

class UpdateUserScreen extends StatefulWidget {
  static const String routeName = '/update_user';

  static Route route() {
    return MaterialPageRoute(
      settings: const RouteSettings(name: routeName),
      builder: (context) {
        return UpdateUserScreen();
      },
    );
  }

  @override
  State<UpdateUserScreen> createState() => _UpdateUserState();
}

class _UpdateUserState extends State<UpdateUserScreen> {
  XFile? xfile;
  String? _name;
  String? _locale;
  DateTime? picked;
  // date picker
  Future<void> _showDatePicker(DateTime? fecha) async {
    picked = await showDatePicker(
      context: context,
      initialDate: fecha != null ? fecha : DateTime((DateTime.now().year - 18)),
      firstDate: DateTime(1900),
      lastDate: DateTime(DateTime.now().year - 18),
      locale: const Locale('es', 'ES'),
      // (2101)
    );
  }

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          CustomSliverAppBar(
            title: S.of(context).title_update_user_screen,
            hasActions: false,
            hasIcon: false,
            isTextCenter: false,
          ),
          SliverToBoxAdapter(
            // TODO: PROFILEBLOC
            child: BlocBuilder<ProfileBloc, ProfileState>(
              builder: (context, stateProfile) {
                if (stateProfile is ProfileLoading) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                if (stateProfile is ProfileLoaded) {
                  picked = DateTime.tryParse(
                      stateProfile.user.dateOfBirth!.toDate().toString());
                  return Padding(
                    padding: const EdgeInsets.all(38),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "Elije tu imagen\n",
                            style: const TextStyle(fontSize: 16),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Container(
                                constraints: BoxConstraints(
                                  maxWidth:
                                      Responsive.isMobile(context) ? 150 : 450,
                                  maxHeight:
                                      Responsive.isMobile(context) ? 150 : 400,
                                ),
                                child: CustomImageContainer(
                                  imageUrl: stateProfile.user.image != ''
                                      ? stateProfile.user.image
                                      : 'empty',
                                ),
                              ),
                              const Icon(Icons.roundabout_right_sharp),
                              Container(
                                constraints: BoxConstraints(
                                  maxWidth:
                                      Responsive.isMobile(context) ? 150 : 450,
                                  maxHeight:
                                      Responsive.isMobile(context) ? 150 : 400,
                                ),
                                child: CustomImageContainer(
                                  onPressed: (XFile _file) {
                                    print('imagen');
                                    xfile = null;
                                    setState(() {
                                      xfile = _file;
                                    });
                                  },
                                  imageUrlLocal: xfile != null ? xfile! : null,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: kPaddingS),
                          TextFormField(
                              initialValue: stateProfile.user.name,
                              textInputAction: TextInputAction.next,
                              keyboardType: TextInputType.multiline,
                              maxLines: null,
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: 'Nombre',
                              ),
                              validator: (value) =>
                                  Validators.isValidateOnlyTextMinMax(
                                    text: value!,
                                    minCaracter: 3,
                                    maxCarater: 100,
                                    messageError: 'Nombre no valido.',
                                  ),
                              onSaved: (value) => setState(() {
                                    _name = value;
                                  })),
                          const SizedBox(height: kPaddingS),
                          TextFormField(
                              initialValue: stateProfile.user.location,
                              textInputAction: TextInputAction.next,
                              keyboardType: TextInputType.multiline,
                              maxLines: null,
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: 'Ubicación',
                              ),
                              validator: (value) =>
                                  Validators.isValidateOnlyTextMinMax(
                                    text: value!,
                                    minCaracter: 3,
                                    maxCarater: 100,
                                    messageError: 'Ubicación no valido.',
                                  ),
                              onSaved: (value) => setState(() {
                                    _locale = value;
                                  })),
                          const SizedBox(height: kPaddingS),
                          StatefulBuilder(
                            builder: (BuildContext context, setState) {
                              return ListTile(
                                title: const Text("Fecha de nacimiento"),
                                subtitle: Text(
                                  'Fecha guardada: ${picked!.toString().substring(0, 10)}',
                                  style: const TextStyle(fontSize: 16),
                                ),
                                onTap: () => _showDatePicker(DateTime.tryParse(
                                    stateProfile.user.dateOfBirth!
                                        .toDate()
                                        .toString())),
                                leading: Icon(
                                  Icons.edit_calendar,
                                  color: Theme.of(context).primaryColor,
                                  size: 34.0,
                                ),
                              );
                            },
                          ),
                          MaterialButton(
                            textColor: Theme.of(context).primaryColorLight,
                            color: Theme.of(context).primaryColor,
                            splashColor: Theme.of(context).primaryColorLight,
                            elevation: 10,
                            onPressed: () async {
                              if (!_formKey.currentState!.validate()) return;
                              _formKey.currentState!.save();
                              ShowAlert.showAlertSnackBar(context,
                                  message: 'Actualizando perfil...');
                              context.read<ProfileBloc>().add(
                                    UpdateUserProfile(
                                      image: stateProfile.user.image.isNotEmpty
                                          ? xfile != null
                                              ? xfile!
                                              : null
                                          : null,
                                      user: stateProfile.user.copyWith(
                                        name: _name,
                                        location: _locale,
                                        // image: ,
                                        dateOfBirth:
                                            Timestamp.fromDate(picked!),
                                      ),
                                    ),
                                  );
                              ShowAlert.showSuccessSnackBar(context,
                                  message: 'Perfil actualizado.');
                            },
                            // xfile;
                            child: SizedBox(
                              width: 100,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: const [
                                  Icon(Icons.save_as),
                                  Text(
                                    "Guardar",
                                    style: const TextStyle(fontSize: 14),
                                  )
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  );
                }
                return const Center(
                  child: CircularProgressIndicator(),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
