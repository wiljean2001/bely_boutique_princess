import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../blocs/blocs.dart';
import '../../../models/models.dart';
import '../../../widgets/custom_card_product.dart';
import '../product_screen.dart';

class ProductSearchDelegate extends SearchDelegate {
  final List<Product> products;

  List<Product> history = [];
  List<Product> resultProducts = <Product>[];
  ProductSearchDelegate(this.history, {required this.products});
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
      onPressed: () => close(context, resultProducts),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    print(query);
    resultProducts = products
        .where((product) =>
            product.title.toLowerCase().contains(query.trim().toLowerCase()))
        .toList();
    history.addAll(resultProducts);
    // return Column(
    //   children: resultProducts.map((e) => Text(e.title)).toList(),
    // );
    return CustomScrollView(
      slivers: [
        SliverGrid.count(
          crossAxisCount: 2,
          childAspectRatio: 0.75,
          children: resultProducts.isNotEmpty
              ? resultProducts
                  .map(
                    (product) => Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: CustomCardProduct(
                        context: context,
                        added: true,
                        imgPath: product.imageUrls.isNotEmpty
                            ? product.imageUrls[0]
                            : 'https://api.lorem.space/image/shoes?w=150&h=150',
                        // isFavorite: false,
                        name: product.title,
                        price: 'S/ ${product.price.toString()}',
                        onTap: () => Navigator.of(context).pushNamed(
                            ProductScreen.routeName,
                            arguments: product),
                      ),
                    ),
                  )
                  .toList()
              : [const SizedBox()],
        ),
      ],
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 400, maxHeight: 400),
      child: Column(
        children: [
          SizedBox(
            height: 100,
            child: BlocBuilder<CategoryBloc, CategoryState>(
                builder: (context, state) {
              if (state is CategoryLoaded) {
                return Center(
                  child: Wrap(
                      children: state.categories.isNotEmpty
                          ? state.categories
                              .map(
                                (category) => InkWell(
                                  onTap: () {},
                                  child: Chip(
                                    avatar: CircleAvatar(
                                      child: category.imageUrl.isNotEmpty
                                          ? Image.network(category.imageUrl)
                                          : const SizedBox(),
                                    ),
                                    label: Text(category.name),
                                  ),
                                ),
                              )
                              .toList()
                          : []),
                );
              }
              return const Center(child: CircularProgressIndicator());
            }),
          ),
          history.isNotEmpty
              ? Column(children: history.map((e) => Text(e.title)).toList())
              : Container(
                  constraints:
                      const BoxConstraints(maxWidth: 400, maxHeight: 200),
                  child: const Text('Recomendaciones'),
                )
        ],
      ),
    );

    // return Container(
    //   constraints: const BoxConstraints(maxWidth: 400, maxHeight: 200),
    //   child: const Text('filstrados'),
    // );
  }
}
