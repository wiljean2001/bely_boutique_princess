import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:bely_boutique_princess/models/user_model.dart';
import 'package:bely_boutique_princess/utils/custom_alert_dialog.dart';
import 'package:bely_boutique_princess/utils/show_alert.dart';
import '../../../../blocs/role/role_bloc.dart';

class UserSearchDelegate extends SearchDelegate {
  List<User> resultUsers = <User>[];

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () => query = '',
        icon: const Icon(Icons.clear_outlined),
      )
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back_outlined),
      onPressed: () {
        context.read<RoleBloc>().add(const LoadUsers(role: 'admin'));
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return BlocBuilder<RoleBloc, RoleState>(
      builder: (context, state) {
        if (state is RoleLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        if (state is RoleLoaded) {
          List<User> users = state.users;
          print(users);
          resultUsers = users
              .where(
                (user) => user.name.toLowerCase().contains(
                      query.trim().toLowerCase(),
                    ),
              )
              .toList();
          return CustomScrollView(
            slivers: [
              SliverList(
                delegate: SliverChildListDelegate(
                  resultUsers
                      .map(
                        (e) => ListTile(
                          title: Text(e.name),
                          subtitle: Text(e.role),
                          onTap: () => CustomAlertDialog.contentButtonAndTitle(
                            context: context,
                            content: Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    const Text('Nombre'),
                                    const Text(':'),
                                    Text(e.name)
                                  ],
                                ),
                                MaterialButton(
                                  color: Theme.of(context).primaryColor,
                                  minWidth: 100,
                                  elevation: 10,
                                  onPressed: () {
                                    print(e.role);
                                    if (e.role == 'user') {
                                      context.read<RoleBloc>().add(
                                            UpdateRoleUser(
                                                user:
                                                    e.copyWith(role: 'admin')),
                                          );
                                    } else {
                                      context.read<RoleBloc>().add(
                                            UpdateRoleUser(
                                                user: e.copyWith(role: 'user')),
                                          );
                                    }
                                    ShowAlert.showSuccessSnackBar(
                                      context,
                                      message:
                                          'Rol de usuario cambiado correctamente.',
                                    );
                                  },
                                  child: Text(
                                    'Confirmar cambio de rol',
                                    style: TextStyle(
                                        color: Theme.of(context)
                                            .scaffoldBackgroundColor),
                                  ),
                                ),
                              ],
                            ),
                            title: Text('Confirmar el cambio de rol.'),
                          ),
                          // YYNoticeDialog(e),
                        ),
                      )
                      .toList(),
                ),
              ),
            ],
          );
        }
        return const Center(child: CircularProgressIndicator());
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return const Center(child: Text('Buscar usuario'));
  }
}
