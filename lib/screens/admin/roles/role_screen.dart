import 'package:bely_boutique_princess/utils/custom_alert_dialog.dart';
import 'package:flutter/material.dart';

import 'package:data_table_2/data_table_2.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../blocs/blocs.dart';
import '../../../config/constrants.dart';
import '../../../generated/l10n.dart';
import '../../../models/models.dart';
import '../../../utils/show_alert.dart';
import '../../../widgets/custom_sliver_app_bar.dart';
import 'search/product_search_delegate.dart';

enum SingingCharacter { admin, user }

class RoleScreen extends StatefulWidget {
  const RoleScreen({Key? key}) : super(key: key);

  @override
  State<RoleScreen> createState() => _RoleScreenState();
}

class _RoleScreenState extends State<RoleScreen> {
  SingingCharacter? _character;

  @override
  Widget build(BuildContext context) {
    // role as title

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.read<RoleBloc>().add(const LoadUsers(role: 'user'));
          showSearch(
            context: context,
            delegate: UserSearchDelegate(),
          );
        },
        child: Icon(Icons.checklist_rtl_outlined),
      ),
      body: BlocBuilder<RoleBloc, RoleState>(
        builder: (context, state) {
          if (state is RoleLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is RoleLoaded) {
            return CustomScrollView(
              slivers: [
                CustomSliverAppBar(
                  title: S.of(context).title_administrator_screen,
                  hasActions: false,
                  hasIcon: false,
                  isTextCenter: false,
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.only(top: kPaddingM),
                    child: Text(
                      S.of(context).role_user(
                            state.role == 'user'
                                ? 'Usuario normal'
                                : S.of(context).title_administrator_screen,
                          ),
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ),
                ),
                SliverFillRemaining(
                  child: Padding(
                    padding: const EdgeInsets.all(kPaddingS),
                    child: DataTable2(
                      dataRowHeight: 70,
                      // columnSpacing: 12,
                      columns: const [
                        DataColumn2(label: Text('Nombre'), size: ColumnSize.L),
                        DataColumn2(label: Text('Rol'), size: ColumnSize.S),
                      ],
                      rows: state.users.map(
                        (e) {
                          _character = e.role == 'user'
                              ? SingingCharacter.user
                              : SingingCharacter.admin;
                          return DataTableRole(e, context);
                        },
                      ).toList(),
                    ),
                  ),
                ),
              ],
            );
          }
          return Text(S.of(context).error_desc);
        },
      ),
    );
  }

  DataRow2 DataTableRole(User e, BuildContext context) {
    return DataRow2(
      cells: [
        DataCell(Text(e.name)),
        DataCell(Row(children: [Text(e.role)])),
      ],
      onTap: () => CustomAlertDialog.contentButtonAndTitle(
        context: context,
        content: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [const Text('Nombre'), const Text(':'), Text(e.name)],
            ),
            Divider(color: Theme.of(context).primaryColor),
            MaterialButton(
              color: Theme.of(context).primaryColor,
              minWidth: 100,
              elevation: 10,
              onPressed: () {
                print(e.role);
                if (e.role == 'user') {
                  context.read<RoleBloc>().add(
                        UpdateRoleUser(user: e.copyWith(role: 'admin')),
                      );
                } else {
                  context.read<RoleBloc>().add(
                        UpdateRoleUser(user: e.copyWith(role: 'user')),
                      );
                }
                ShowAlert.showSuccessSnackBar(
                  context,
                  message: 'Rol de administrador cambiado correctamente.',
                );
              },
              child: Text(
                'Confirmar cambio de rol',
                style: TextStyle(
                  color: Theme.of(context).cardColor,
                ),
              ),
            ),
          ],
        ),
        title: Text('Confirmar cambio de rol.'),
      ),
    );
  }
}
