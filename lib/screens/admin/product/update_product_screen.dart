import 'package:bely_boutique_princess/models/models.dart';
import 'package:bely_boutique_princess/utils/custom_alert_dialog.dart';
import 'package:bely_boutique_princess/utils/show_alert.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_custom_dialog/flutter_custom_dialog.dart';
import 'package:flutter_dropdown/flutter_dropdown.dart';
import 'package:multi_select_flutter/util/multi_select_item.dart';

import '../../../blocs/blocs.dart';
import '../../../blocs/type_product/type_product_bloc.dart';
import '../../../config/constrants.dart';
import '../../../config/responsive.dart';
import '../../../generated/assets.dart';
import '../../../generated/l10n.dart';
import '../../../utils/validators.dart';
import '../../../widgets/custom_appbar.dart';
import '../../../widgets/custom_multi_dropdown.dart';
import '../../../widgets/custom_sliver_app_bar.dart';
import 'show_products_screen.dart';

class UpdateProductScreen extends StatefulWidget {
  const UpdateProductScreen({Key? key}) : super(key: key);

  @override
  State<UpdateProductScreen> createState() => _UpdateProductScreenState();
}

class _UpdateProductScreenState extends State<UpdateProductScreen> {
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
            child: Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: kPaddingL, vertical: kPaddingS),
              child: BlocBuilder<TypeProductBloc, TypeProductState>(
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
                        typeProduct = typeP;
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
            ),
          ),
          SliverFillRemaining(
            child: BlocBuilder<ProductBloc, ProductState>(
              builder: (context, stateProduct) {
                if (stateProduct is ProductLoading) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (stateProduct is ProductsLoaded) {
                  int contIndex = 0;
                  return BlocBuilder<CategoryBloc, CategoryState>(
                    builder: (context, stateCategory) {
                      if (stateCategory is CategoryLoaded) {
                        print(typeProduct);
                        if (typeProduct != null) {
                          return BlocBuilder<SizeProductBloc, SizeProductState>(
                            builder: (context, stateSizeProduct) {
                              if (stateSizeProduct is SizeProductsLoaded) {
                                return _customDataTable(stateProduct, contIndex,
                                    stateCategory, stateSizeProduct, context);
                              }
                              return const Center(
                                  child: CircularProgressIndicator());
                            },
                          );
                        }
                        return const SizedBox();
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

  List<Product> showProducts = [];
  Widget _customDataTable(
      ProductsLoaded stateProduct,
      int contIndex,
      CategoryLoaded stateCategory,
      SizeProductsLoaded stateSizeProduct,
      BuildContext context) {
    // showProducts

    // showaProducts!.addAll(stateProduct.products
    //     .map((e) => e.typeProductId == typeProduct!.id ? e : null)
    //     .toList());
    showProducts.clear();
    showProducts.addAll(
      stateProduct.products
          .where((element) => element.typeProductId == typeProduct!.id)
          .toList(),
    );

    return showProducts.isNotEmpty
        ? DataTable2(
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
            // fixedLeftColumns: 1,
            minWidth: 1200,
            columns: const [
              DataColumn2(
                label:
                    Text('N°', style: TextStyle(fontStyle: FontStyle.italic)),
                numeric: true,
                // size: ColumnSize.S,
                fixedWidth: 50,
              ),
              DataColumn2(
                label: Text('Nombre',
                    style: TextStyle(fontStyle: FontStyle.italic)),
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
                    style: TextStyle(fontStyle: FontStyle.italic)),
                size: ColumnSize.L,
                fixedWidth: 200,
              ),
              DataColumn2(
                label: Text('Precio',
                    style: TextStyle(fontStyle: FontStyle.italic)),
                fixedWidth: 130,
              ),
              DataColumn2(
                label: Text('Categorías',
                    style: TextStyle(fontStyle: FontStyle.italic)),
                fixedWidth: 130,
              ),
              DataColumn2(
                label: Text('Tallas',
                    style: TextStyle(fontStyle: FontStyle.italic)),
                fixedWidth: 130,
              ),
              DataColumn2(
                label: Text('Imagen',
                    style: TextStyle(fontStyle: FontStyle.italic)),
                // size: ColumnSize.L,
                fixedWidth: 100,
              ),
              DataColumn2(label: Text(""), fixedWidth: 250),
            ],
            // showProducts
            // stateProduct.products.isNotEmpty
            rows: showProducts.map<DataRow>((e) {
              contIndex += 1;
              return DataRow2(
                onLongPress: () {},
                cells: [
                  DataCell(Text(contIndex.toString())),
                  DataCell(Text(e.title)),
                  DataCell(Text(e.descript)),
                  DataCell(Text('S/ ${e.prices.join('\nS/')}')),
                  DataCell(
                    Wrap(
                      children: e.categories
                          .map(
                            (categP) => Wrap(
                              children: stateCategory.categories
                                  .map(
                                    (categ) => categ.id == categP
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
                    Wrap(
                      children: e.sizes
                          .map(
                            (sizesP) => Wrap(
                              children: stateSizeProduct.sizeProducts
                                  .map(
                                    (sizes) => sizes.id == sizesP
                                        ? Text('${sizes.size} ')
                                        : const Text(''),
                                  )
                                  .toList(),
                            ),
                          )
                          .toList(),
                    ),
                  ),
                  DataCell(
                    e.imageUrls.isNotEmpty
                        ? FadeInImage(
                            height: Responsive.isMobile(context) ? 150.0 : 250,
                            placeholder: const AssetImage(
                              Assets.imagesLogoTextoRosa,
                            ),
                            image: NetworkImage(
                              e.imageUrls[0],
                            ),
                          )
                        : const SizedBox(),
                  ),
                  DataCell(
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _updateProductDIalog(context, e),
                        MaterialButton(
                          textColor: Theme.of(context).primaryColorLight,
                          color: Theme.of(context).primaryColor,
                          splashColor: Theme.of(context).primaryColorLight,
                          elevation: 10,
                          onPressed: () {
                            CustomAlertDialog.contentButtonAndTitle(
                              context: context,
                              content: OutlinedButton(
                                onPressed: () {
                                  BlocProvider.of<ProductBloc>(context).add(
                                    DeleteProduct(product: e),
                                  );
                                },
                                child: Text('Confirmar'),
                              ),
                              title: Text('Confirmar eliminación'),
                            );
                          },
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
            }).toList())
        : const SizedBox();
  }

  String? title;
  String? description;
  List<double>? price = [];
  TypeProduct? typeProduct;
  List<String?>? sizesProduct = [];
  MaterialButton _updateProductDIalog(BuildContext context, Product e) {
    final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
    // e.prices.map((e) => price!.insert(0, ));
    // e.prices.insertAll(0, e.prices);
    price = [];
    // context.read<SizeProductBloc>().add(
    //       LoadSizeProducts(typeProductId: e.typeProductId),
    //     );
    // context.read<CategoryBloc>().add(
    //       LoadCategories(typeProductId: e.typeProductId),
    //     );
    return MaterialButton(
      textColor: Theme.of(context).primaryColorLight,
      color: Theme.of(context).primaryColor,
      splashColor: Theme.of(context).primaryColorLight,
      elevation: 10,
      onPressed: () => CustomAlertDialog.contentButtonAndTitle(
        context: context,
        content: Form(
          key: _formKey,
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
                    typeProduct = stateSizeProduct.typeProducts.firstWhere(
                      (typeProduct) => typeProduct.id == e.typeProductId,
                    );
                    return DropDown(
                      // TODO: falta iniciar y registrar
                      initialValue: typeProduct,
                      isExpanded: true,
                      items: stateSizeProduct.typeProducts,
                      customWidgets: stateSizeProduct.typeProducts
                          .map((e) => Text(e.title))
                          .toList(),
                      onChanged: (TypeProduct? typeP) {
                        typeProduct = typeP;
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
                initialValue: e.title,
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
                  initialValue: e.descript,
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
                initialValue: e.prices.first.toString(),
                onSaved: (value) => setState(() {
                  price!.insert(0, double.parse(value!));
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
                initialValue: e.prices.last.toString(),
                onSaved: (value) => setState(() {
                  price!.insert(1, double.parse(value!));
                }),
                // TODO : FALTA ACTUALIZAR CATEGORIAS, TALLAS E IMAGENES
              ),
              BlocBuilder<SizeProductBloc, SizeProductState>(
                builder: (context, state) {
                  if (state is SizeProductLoading) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  if (state is SizeProductsLoaded) {
                    String textButton = 'Actualizar lista existente';
                    // Only Sizes from products
                    List<MultiSelectItem<SizeProduct>> lista = [];

                    for (var sizeProduct in state.sizeProducts) {
                      for (var e in e.sizes) {
                        if (sizeProduct.id == e) {
                          lista.add(
                            MultiSelectItem(sizeProduct, sizeProduct.size),
                          );
                        }
                      }
                    }
                    return Column(
                      children: [
                        OutlinedButton(
                          onPressed: () {
                            if (textButton == 'Actualizar lista existente') {
                              textButton = 'Agregar otros tallas';
                              // All sizes
                              lista = state.sizeProducts
                                  .map((e) => MultiSelectItem(e, e.size))
                                  .toList();
                            } else {
                              textButton = 'Actualizar lista existente';
                              lista.clear();
                              for (var sizeProduct in state.sizeProducts) {
                                for (var e in e.sizes) {
                                  if (sizeProduct.id == e) {
                                    lista.add(
                                      MultiSelectItem(
                                          sizeProduct, sizeProduct.size),
                                    );
                                  }
                                }
                              }
                            }
                            setState(() {});
                          },
                          child: Text(textButton),
                        ),
                        CustomDropDown(
                          buttonText: const Text('Seleccionar tallas'),
                          listItems: lista,
                          onConfirm: (List<SizeProduct> values) {
                            sizesProduct = [];
                            values.map((e) => sizesProduct!.add(e.id)).toList();
                          },
                          title: const Text('Tallas'),
                          validator: (value) {
                            if (value.isNotEmpty) {
                              return null;
                            } else {
                              return 'Selecciona al menos una opción.';
                            }
                          },
                        ),
                      ],
                    );
                  }
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                },
              ),
              OutlinedButton(
                onPressed: () {
                  if (!_formKey.currentState!.validate()) return;
                  _formKey.currentState!.save();
                  BlocProvider.of<ProductBloc>(context).add(
                    UpdateProduct(
                      product: e.copyWith(
                          title: title,
                          descript: description,
                          prices: price,
                          // sizes:
                          typeProductId: typeProduct!.id
                          // categories:
                          // imageUrls:
                          ),
                    ),
                  );
                  Navigator.pop(context);
                  ShowAlert.showSuccessSnackBar(
                    context,
                    message: '¡Actualización realizado exitosamente!',
                  );
                },
                child: Text('Actualizar'),
              ),
            ],
          ),
        ),
        title: Text('Actualizar producto'),
      ),
      // YYNoticeDialog(e),
      child: const Text(
        'Editar',
        style: TextStyle(fontSize: 10),
      ),
    );
  }
}
