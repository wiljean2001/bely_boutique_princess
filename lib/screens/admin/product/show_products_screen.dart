import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../blocs/blocs.dart';
import '../../../config/constrants.dart';
import '../../../generated/l10n.dart';
import '../../../widgets/custom_sliver_app_bar.dart';

class ShowProductsScreen extends StatefulWidget {
  const ShowProductsScreen({Key? key}) : super(key: key);

  @override
  State<ShowProductsScreen> createState() => _ShowProductsScreenState();
}

class _ShowProductsScreenState extends State<ShowProductsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Theme.of(context).scaffoldBackgroundColor.withOpacity(.2),
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: <Widget>[
          CustomSliverAppBar(
            title: S.of(context).title_show_products_screen,
            hasActions: false,
            hasIcon: false,
            isTextCenter: false,
          ),
          SliverToBoxAdapter(
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
                        return Column(
                          children: [
                            const CustomSearchProduct(),
                            Padding(
                              padding: const EdgeInsets.all(kPaddingM),
                              child: SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: DataTable(
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
                                  dataRowHeight: 70,
                                  sortAscending: true,
                                  columns: const [
                                    DataColumn(
                                      label: Text('N°',
                                          style: TextStyle(
                                              fontStyle: FontStyle.italic)),
                                      numeric: true,
                                    ),
                                    DataColumn(
                                      label: Text('Nombre',
                                          style: TextStyle(
                                              fontStyle: FontStyle.italic)),
                                      // onSort: (i, b) {
                                      //   setState(() {
                                      //     stateProduct.products.sort(
                                      //       (a, b) => a.title.compareTo(b.title),
                                      //     );
                                      //   });
                                      // },
                                    ),
                                    DataColumn(
                                      label: Text('Desc.',
                                          style: TextStyle(
                                              fontStyle: FontStyle.italic)),
                                    ),
                                    DataColumn(
                                      label: Text('Precio',
                                          style: TextStyle(
                                              fontStyle: FontStyle.italic)),
                                    ),
                                    DataColumn(
                                      label: Text('Categorías',
                                          style: TextStyle(
                                              fontStyle: FontStyle.italic)),
                                    ),
                                    DataColumn(
                                      label: Text('Imagen',
                                          style: TextStyle(
                                              fontStyle: FontStyle.italic)),
                                    ),
                                  ],
                                  rows: stateProduct.products.isNotEmpty
                                      ? stateProduct.products.map<DataRow>((e) {
                                          contIndex += 1;
                                          return DataRow(
                                            onLongPress: () {},
                                            cells: [
                                              DataCell(
                                                  Text(contIndex.toString())),
                                              DataCell(Text(e.title)),
                                              DataCell(Text(e.descript)),
                                              DataCell(Text(
                                                  'S/ ${e.price.toString()}')),
                                              DataCell(
                                                Wrap(
                                                  children: e.categories
                                                      .map(
                                                        (categP) => Wrap(
                                                          children:
                                                              stateCategory
                                                                  .categories
                                                                  .map(
                                                                    (categ) => categ.id ==
                                                                            categP
                                                                        ? Text(categ
                                                                            .name)
                                                                        : const Text(
                                                                            ''),
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
                                            ],
                                          );
                                        }).toList()
                                      : [],
                                ),
                              ),
                            ),
                          ],
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
              hintText: 'Search',
              border: InputBorder.none),
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
