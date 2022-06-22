import 'package:flutter/material.dart';

import '../../../generated/l10n.dart';
import '../../../widgets/custom_appbar.dart';
import '../../../widgets/custom_sliver_app_bar.dart';

class UpdateProductScreen extends StatelessWidget {
  const UpdateProductScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Theme.of(context).scaffoldBackgroundColor.withOpacity(.2),
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: <Widget>[
          CustomSliverAppBar(
            title: S.of(context).title_update_product_screen,
            hasActions: false,
            hasIcon: false,
            isTextCenter: false,
          ),
          SliverToBoxAdapter(
            child: DataTable(
              columns: const [
                DataColumn(label: Text('')),
              ],
              rows: const [
                DataRow(
                  cells: [DataCell(Text(''))],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
