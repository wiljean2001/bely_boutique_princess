import 'package:bely_boutique_princess/models/user_model.dart';
import 'package:bely_boutique_princess/utils/show_alert.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_custom_dialog/flutter_custom_dialog.dart';

import '../../../../blocs/role/role_bloc.dart';
import '../../../../config/constrants.dart';

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
    YYDialog YYNoticeDialog(User user) {
      return YYDialog().build()
        // ..width =
        // ..height = 110
        ..margin = const EdgeInsets.symmetric(horizontal: kPaddingM)
        ..backgroundColor =
            Theme.of(context).scaffoldBackgroundColor.withOpacity(0.8)
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
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  const Text('Nombre'),
                  const Text(':'),
                  Text(user.name)
                ],
              ),
            ],
          ),
        ))
        ..widget(
          MaterialButton(
            color: Theme.of(context).primaryColor,
            minWidth: 100,
            elevation: 10,
            onPressed: () {
              print(user.role);
              if (user.role == 'user') {
                context.read<RoleBloc>().add(
                      UpdateRoleUser(user: user.copyWith(role: 'admin')),
                    );
              } else {
                context.read<RoleBloc>().add(
                      UpdateRoleUser(user: user.copyWith(role: 'user')),
                    );
              }
              ShowAlert.showSuccessSnackBar(
                context,
                message: 'Rol de usuario cambiado correctamente.',
              );
            },
            child: Text(
              'Confirmar cambio de rol',
              style:
                  TextStyle(color: Theme.of(context).scaffoldBackgroundColor),
            ),
          ),
        )
        // ..gravity = Gravity.bottom
        ..animatedFunc = (child, animation) {
          return ScaleTransition(
            child: child,
            scale: Tween(begin: 0.0, end: 1.0).animate(animation),
          );
        }
        ..show();
    }

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
                          onTap: () => YYNoticeDialog(e),
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
