import 'package:bely_boutique_princess/widgets/custom_loading_screen.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dropdown/flutter_dropdown.dart';

import '../../../blocs/blocs.dart';
import '../../../blocs/type_product/type_product_bloc.dart';
import '../../../config/constrants.dart';
import '../../../generated/l10n.dart';
import '../../../models/type_product_model.dart';
import '../../../widgets/custom_sliver_app_bar.dart';

class ShowCategoriesScreen extends StatelessWidget {
  const ShowCategoriesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Theme.of(context).scaffoldBackgroundColor.withOpacity(.2),
      body: CustomScrollView(
        slivers: <Widget>[
          CustomSliverAppBar(
            title: S.of(context).title_show_categories_screen,
            hasActions: false,
            hasIcon: false,
            isTextCenter: false,
          ),
          SliverToBoxAdapter(
            child: BlocBuilder<TypeProductBloc, TypeProductState>(
              builder: (context, stateSizeProduct) {
                if (stateSizeProduct is TypeProductLoading) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                if (stateSizeProduct is TypeProductsLoaded) {
                  return Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: kPaddingL, vertical: kPaddingS),
                        child: DropDown(
                          isExpanded: true,
                          items: stateSizeProduct.typeProducts,
                          customWidgets: stateSizeProduct.typeProducts
                              .map((e) => Text(e.title))
                              .toList(),
                          onChanged: (TypeProduct? typeP) {
                            print(typeP!);
                            context.read<SizeProductBloc>().add(
                                  LoadSizeProducts(typeProductId: typeP.id),
                                );
                            context.read<CategoryBloc>().add(
                                  LoadCategories(typeProductId: typeP.id),
                                );
                          },
                          hint: const Text('Tipo de producto'),
                        ),
                      ),
                    ],
                  );
                }
                return const Center(
                  child: CircularProgressIndicator(),
                );
              },
            ),
          ),
          SliverFillRemaining(
            child: BlocBuilder<CategoryBloc, CategoryState>(
              builder: (context, state) {
                if (state is CategoryLoading) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                if (state is CategoryLoaded) {
                  int contIndex = 0;
                  return DataTable2(
                    // headingRowColor: MaterialStateProperty.all<Color>(
                    //   Theme.of(context).primaryColorLight.withOpacity(.3),
                    // ),
                    // dataRowColor: MaterialStateProperty.all<Color>(
                    //   Theme.of(context).primaryColorLight.withOpacity(.1),
                    // ),
                    // headingTextStyle: Theme.of(context)
                    //     .textTheme
                    //     .titleMedium
                    //     ?.copyWith(fontWeight: FontWeight.bold),
                    dataRowHeight: 70,
                    columnSpacing: 12,
                    // horizontalMargin: 12,
                    columns: const [
                      // DataColumn2(label: SizedBox()),
                      // DataColumn(label: SizedBox()),
                      DataColumn2(
                          label: Text('N°',
                              style: TextStyle(fontStyle: FontStyle.italic)),
                          size: ColumnSize.S,
                          numeric: true),
                      DataColumn2(
                          label: Text('Categoría',
                              style: TextStyle(fontStyle: FontStyle.italic)),
                          size: ColumnSize.L),
                      DataColumn2(
                          label: Text('Imagen',
                              style: TextStyle(fontStyle: FontStyle.italic)),
                          size: ColumnSize.S)
                    ],
                    rows: state.categories.isNotEmpty
                        ? state.categories.map<DataRow>((e) {
                            contIndex += 1;
                            return DataRow2(
                              cells: [
                                // DataCell(
                                //   Row(
                                //     children: [
                                //       IconButton(
                                //           onPressed: () {},
                                //           icon: Icon(Icons.edit_outlined)),
                                //       IconButton(
                                //           onPressed: () {},
                                //           icon: Icon(Icons.delete_outline))
                                //     ],
                                //   ),
                                // ),
                                DataCell(Text(contIndex.toString())),
                                DataCell(Text(e.name)),
                                DataCell(
                                  e.imageUrl.isNotEmpty
                                      ? Image.network(
                                          e.imageUrl,
                                          width: 60,
                                        )
                                      : const SizedBox(),
                                ),
                              ],
                            );
                          }).toList()
                        : [],
                  );
                }
                return const SizedBox();
              },
            ),
          ),
        ],
      ),
    );
  }
}
