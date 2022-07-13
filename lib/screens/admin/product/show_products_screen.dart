import 'package:flutter/material.dart';

import 'package:data_table_2/data_table_2.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dropdown/flutter_dropdown.dart';

import '../../../blocs/blocs.dart';
import '../../../blocs/type_product/type_product_bloc.dart';
import '../../../config/constrants.dart';
import '../../../config/responsive.dart';
import '../../../generated/assets.dart';
import '../../../generated/l10n.dart';
import '../../../models/models.dart';
import '../../../widgets/custom_sliver_app_bar.dart';

class ShowProductsScreen extends StatefulWidget {
  const ShowProductsScreen({Key? key}) : super(key: key);

  @override
  State<ShowProductsScreen> createState() => _ShowProductsScreenState();
}

class _ShowProductsScreenState extends State<ShowProductsScreen> {
  @override
  Widget build(BuildContext context) {
    showProducts.clear();
    return Scaffold(
      // backgroundColor: Theme.of(context).scaffoldBackgroundColor.withOpacity(.2),
      body: CustomScrollView(
        slivers: <Widget>[
          CustomSliverAppBar(
            title: S.of(context).title_show_products_screen,
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
                    return const Center(child: CircularProgressIndicator());
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
                        setState(() {});
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
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                if (stateProduct is ProductsLoaded) {
                  int contIndex = 0;
                  return BlocBuilder<CategoryBloc, CategoryState>(
                    builder: (context, stateCategory) {
                      if (stateCategory is CategoryLoaded) {
                        return BlocBuilder<SizeProductBloc, SizeProductState>(
                          builder: (context, stateSizeProduct) {
                            if (stateSizeProduct is SizeProductsLoaded) {
                              if (typeProduct != null) {
                                return _customDataTable(stateProduct, contIndex,
                                    stateCategory, stateSizeProduct, context);
                              }
                              return const SizedBox();
                            }
                            return const SizedBox();
                          },
                        );
                      }
                      return const SizedBox();
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
  TypeProduct? typeProduct;
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
                ],
              );
            }).toList())
        : const SizedBox();
  }
}

class CustomSearchProduct extends StatelessWidget {
  const CustomSearchProduct({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: const Icon(Icons.search),
        title: TextFormField(
          decoration: const InputDecoration(
              hintText: 'Search', border: InputBorder.none),
          onChanged: (value) {
            // setState(() {
            //   _searchResult = value;
            //   usersFiltered = users
            //       .where((user) =>
            //           user.name.contains(_searchResult) ||
            //           user.role.contains(_searchResult))
            //       .toList();
            // });
          },
        ),
        trailing: IconButton(
          icon: const Icon(Icons.cancel),
          onPressed: () {
            // setState(() {
            //   controller.clear();
            //   _searchResult = '';
            //   usersFiltered = users;
            // });
          },
        ),
      ),
    );
  }
}
