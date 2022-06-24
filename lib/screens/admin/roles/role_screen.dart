import 'package:bely_boutique_princess/config/responsive.dart';
import 'package:flutter/material.dart';

import 'package:data_table_2/data_table_2.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_custom_dialog/flutter_custom_dialog.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../blocs/blocs.dart';
import '../../../config/constrants.dart';
import '../../../generated/l10n.dart';
import '../../../models/models.dart';
import '../../../widgets/custom_sliver_app_bar.dart';

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
    YYDialog.init(context);
    return Scaffold(
        body: CustomScrollView(
      slivers: [
        CustomSliverAppBar(
          title: S.of(context).title_create_product_screen,
          hasActions: false,
          hasIcon: false,
          isTextCenter: false,
        ),
        SliverFillRemaining(
          child: BlocBuilder<RoleBloc, RoleState>(
            builder: (context, state) {
              if (state is RoleLoading) {
                return const Center(child: CircularProgressIndicator());
              }
              if (state is RoleLoaded) {
                // state .users[0].
                return Padding(
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
                        return DataRow2(
                          cells: [
                            DataCell(Text(e.name)),
                            DataCell(Row(children: [Text(e.role)])),
                          ],
                          onTap: () => YYNoticeDialog(e),
                        );
                      },
                    ).toList(),
                  ),
                );
              }
              return Text(S.of(context).error_desc);
            },
          ),
        ),
      ],
    ));
  }

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
        padding: EdgeInsets.only(top: kPaddingS, bottom: kPaddingS),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [Text('Nombre'), Text(':'), Text(user.name)],
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
          },
          child: Text(
            'Confirmar cambio de rol',
            style: TextStyle(color: Theme.of(context).scaffoldBackgroundColor),
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
}
