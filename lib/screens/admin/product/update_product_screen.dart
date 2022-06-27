import 'package:bely_boutique_princess/models/models.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_custom_dialog/flutter_custom_dialog.dart';
import 'package:flutter_dropdown/flutter_dropdown.dart';

import '../../../blocs/blocs.dart';
import '../../../blocs/type_product/type_product_bloc.dart';
import '../../../config/constrants.dart';
import '../../../generated/l10n.dart';
import '../../../utils/validators.dart';
import '../../../widgets/custom_appbar.dart';
import '../../../widgets/custom_sliver_app_bar.dart';
import 'show_products_screen.dart';

class UpdateProductScreen extends StatefulWidget {
  const UpdateProductScreen({Key? key}) : super(key: key);

  @override
  State<UpdateProductScreen> createState() => _UpdateProductScreenState();
}

class _UpdateProductScreenState extends State<UpdateProductScreen> {
  String? title;
  String? description;
  List<double>? price = [];

  @override
  Widget build(BuildContext context) {
    YYDialog.init(context);
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
          SliverFillRemaining(
            child: BlocBuilder<ProductBloc, ProductState>(
              builder: (context, stateProduct) {
                if (stateProduct is ProductLoading) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                if (stateProduct is ProductsLoaded) {
                  int contIndex = 0;
                  return BlocBuilder<CategoryBloc, CategoryState>(
                    builder: (context, stateCategory) {
                      if (stateCategory is CategoryLoaded) {
                        return DataTable2(
                          // showBottomBorder: true,
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

                          dataRowHeight: 100,
                          fixedLeftColumns: 1,
                          minWidth: 1000,
                          columns: const [
                            DataColumn2(
                              label: Text('N°',
                                  style:
                                      TextStyle(fontStyle: FontStyle.italic)),
                              numeric: true,
                              // size: ColumnSize.S,
                              fixedWidth: 50,
                            ),
                            DataColumn2(
                              label: Text('Nombre',
                                  style:
                                      TextStyle(fontStyle: FontStyle.italic)),
                              size: ColumnSize.L,
                              fixedWidth: 150,
                              // onSort: (i, b) {
                              //   setState(() {
                              //     stateProduct.products.sort(
                              //       (a, b) => a.title.compareTo(b.title),
                              //     );
                              //   });
                              // },
                            ),
                            DataColumn2(
                              label: Text('Desc.',
                                  style:
                                      TextStyle(fontStyle: FontStyle.italic)),
                              size: ColumnSize.L,
                              fixedWidth: 200,
                            ),
                            DataColumn2(
                              label: Text('Precio',
                                  style:
                                      TextStyle(fontStyle: FontStyle.italic)),
                              size: ColumnSize.L,
                            ),
                            DataColumn2(
                              label: Text('Categorías',
                                  style:
                                      TextStyle(fontStyle: FontStyle.italic)),
                              size: ColumnSize.L,
                            ),
                            DataColumn2(
                              label: Text('Imagen',
                                  style:
                                      TextStyle(fontStyle: FontStyle.italic)),
                              size: ColumnSize.L,
                            ),
                            DataColumn2(label: Text(""), fixedWidth: 250),
                          ],
                          rows: stateProduct.products.isNotEmpty
                              ? stateProduct.products.map<DataRow>((e) {
                                  contIndex += 1;
                                  return DataRow2(
                                    onLongPress: () {},
                                    cells: [
                                      DataCell(Text(contIndex.toString())),
                                      DataCell(Text(e.title)),
                                      DataCell(Text(e.descript)),
                                      DataCell(
                                          Text('S/ ${e.prices.toString()}')),
                                      DataCell(
                                        Wrap(
                                          children: e.categories
                                              .map(
                                                (categP) => Wrap(
                                                  children: stateCategory
                                                      .categories
                                                      .map(
                                                        (categ) => categ.id ==
                                                                categP
                                                            ? Text(categ.name)
                                                            : const Text(''),
                                                      )
                                                      .toList(),
                                                ),
                                              )
                                              .toList(),
                                        ),
                                      ),
                                      DataCell(
                                        Image.network(
                                          e.imageUrls.isNotEmpty
                                              ? e.imageUrls[0]
                                              : 'https://api.lorem.space/image/shoes?w=150&h=150',
                                          width: 60,
                                        ),
                                      ),
                                      DataCell(
                                        Row(
                                          children: [
                                            MaterialButton(
                                              textColor: Theme.of(context)
                                                  .primaryColorLight,
                                              color: Theme.of(context)
                                                  .primaryColor,
                                              splashColor: Theme.of(context)
                                                  .primaryColorLight,
                                              elevation: 10,
                                              onPressed: () =>
                                                  YYNoticeDialog(e),
                                              child: const Text(
                                                'Editar',
                                                style: TextStyle(fontSize: 10),
                                              ),
                                            ),
                                            VerticalDivider(
                                              color: Theme.of(context)
                                                  .primaryColor,
                                            ),
                                            MaterialButton(
                                              textColor: Theme.of(context)
                                                  .primaryColorLight,
                                              color: Theme.of(context)
                                                  .primaryColor,
                                              splashColor: Theme.of(context)
                                                  .primaryColorLight,
                                              elevation: 10,
                                              onPressed: () {},
                                              child: const Text(
                                                'Eliminar',
                                                style: TextStyle(fontSize: 10),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ],
                                  );
                                }).toList()
                              : [],
                        );
                      }
                      return const Center(child: CircularProgressIndicator());
                    },
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

  YYDialog YYNoticeDialog(Product product) {
    return YYDialog().build()
      // ..width =
      // ..height = 110
      ..margin = const EdgeInsets.symmetric(horizontal: kPaddingM)
      ..backgroundColor = Theme.of(context).scaffoldBackgroundColor
      ..borderRadius = 10.0
      ..showCallBack = () {
        print("showCallBack invoke");
      }
      ..dismissCallBack = () {
        print("dismissCallBack invoke");
      }
      ..widget(Padding(
        padding: const EdgeInsets.symmetric(
            horizontal: kPaddingL, vertical: kPaddingS),
        child: Column(
          children: [
            BlocBuilder<TypeProductBloc, TypeProductState>(
              builder: (context, stateSizeProduct) {
                if (stateSizeProduct is TypeProductLoading) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                if (stateSizeProduct is TypeProductsLoaded) {
                  return DropDown(
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
                  );
                }
                return const Center(
                  child: CircularProgressIndicator(),
                );
              },
            ),
            TextFormField(
              initialValue: product.title,
              textInputAction: TextInputAction.next,
              keyboardType: TextInputType.text,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Nombre',
              ),
              validator: (value) => Validators.isValidateOnlyTextMinMax(
                text: value!,
                minCaracter: 3,
                maxCarater: 35,
                messageError: 'Nombre no valido.',
              ),
              onSaved: (value) => setState(() {
                title = value;
              }),
            ),
            const SizedBox(height: kPaddingS),
            TextFormField(
                initialValue: product.descript,
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.multiline,
                maxLines: null,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Descripción',
                ),
                validator: (value) => Validators.isValidateOnlyTextMinMax(
                      text: value!,
                      minCaracter: 3,
                      maxCarater: 100,
                      messageError: 'Descripción no valido.',
                    ),
                onSaved: (value) => setState(() {
                      description = value;
                    })),
            const SizedBox(height: 10),
            TextFormField(
              textInputAction: TextInputAction.next,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Precio Max',
                suffixText: 'Soles',
                prefixText: 'S/',
              ),
              validator: (value) => Validators.isValidateOnlyTextMinMax(
                text: value!,
                minCaracter: 1,
                maxCarater: 6,
                messageError: 'Costo no valido.',
              ),
              initialValue: product.prices.first.toString(),
              onSaved: (value) => setState(() {
                price!.add(double.parse(value!));
              }),
            ),
            const SizedBox(height: 10),
            TextFormField(
              textInputAction: TextInputAction.next,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Precio Min',
                suffixText: 'Soles',
                prefixText: 'S/',
              ),
              validator: (value) => Validators.isValidateOnlyTextMinMax(
                text: value!,
                minCaracter: 1,
                maxCarater: 6,
                messageError: 'Costo no valido.',
              ),
              initialValue: product.prices.last.toString(),
              onSaved: (value) => setState(() {
                price!.add(double.parse(value!));
              }),
            ),
          ],
        ),
      ))
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
