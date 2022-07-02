import 'package:flutter/material.dart';

import '../../generated/l10n.dart';
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
        ],
      ),
    );
  }
}
