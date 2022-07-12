import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs/blocs.dart';
import '../config/responsive.dart';
import '../screens/user/product_screen.dart';
import 'Custom_loading_screen.dart';
import 'custom_card_product.dart';

class ListViewShowProducts extends StatelessWidget {
  final bool isReverse;
  const ListViewShowProducts({
    Key? key,
    this.isReverse = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        maxHeight: Responsive.isMobile(context) ? 220 : 300,
      ),
      child: BlocBuilder<ProductBloc, ProductState>(
        builder: (context, state) {
          if (state is ProductLoading) {
            return const CustomLoadingScreen();
          }
          if (state is ProductsLoaded) {
            final rnList =
                List<int>.generate(state.products.length, (index) => index)
                  ..shuffle();
            return ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: state.products.length,
              reverse: isReverse,
              itemBuilder: (BuildContext context, int i) {
                return BlocBuilder<SizeProductBloc, SizeProductState>(
                  builder: (context, stateSizesProduct) {
                    int index = rnList[i];
                    // index = i;
                    if (stateSizesProduct is SizeAllProductsLoaded) {
                      return CustomCardProduct(
                        context: context,
                        added: true,
                        imgPath: state.products[index].imageUrls.isNotEmpty
                            ? state.products[index].imageUrls[0]
                            : 'https://api.lorem.space/image/shoes?w=150&h=150',
                        // isFavorite: false,
                        name: state.products[index].title,
                        price:
                            'S/ ${state.products[index].prices.join(' S/ ')}',
                        onTap: () => Navigator.of(context).pushNamed(
                          ProductScreen.routeName,
                          arguments: ProductScreenArguments(
                            state.products[index],
                            stateSizesProduct.sizeProducts,
                          ),
                        ),
                      );
                    }
                    return const SizedBox();
                  },
                );
              },
            );
          }
          return const SizedBox();
        },
      ),
    );
  }
}
