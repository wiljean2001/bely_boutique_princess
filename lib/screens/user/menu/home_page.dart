import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../blocs/blocs.dart';

import '../../../config/responsive.dart';
import '../../../generated/l10n.dart';
import 'package:bely_boutique_princess/screens/user/product_screen.dart';
import 'package:bely_boutique_princess/screens/user/search/product_search_delegate.dart';
import 'package:bely_boutique_princess/widgets/Custom_loading_screen.dart';
import 'package:bely_boutique_princess/widgets/custom_card_product.dart';
import 'package:bely_boutique_princess/widgets/custom_sliver_app_bar.dart';
import 'package:bely_boutique_princess/models/models.dart';

class HomeView extends StatefulWidget {
  const HomeView({
    Key? key,
  }) : super(key: key);

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  bool isShowProducts = true;
  final List<Product> history = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Theme.of(context).scaffoldBackgroundColor.withOpacity(.2),
      body: BlocBuilder<ProductBloc, ProductState>(
        builder: (context, stateProduct) {
          if (stateProduct is ProductLoading) {
            return const CustomLoadingScreen();
          }
          if (stateProduct is ProductsLoaded) {
            return CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: <Widget>[
                CustomSliverAppBar(
                  title: S.of(context).AppTitle,
                  onTapOption: () {
                    showSearch(
                      context: context,
                      delegate: ProductSearchDelegate(
                        history,
                        products: stateProduct.products,
                      ),
                    );
                  },
                ),
                // SliverToBoxAdapter(
                //   child: MaterialButton(
                //     onPressed: () => setState(() {
                //       isShowProducts
                //           ? isShowProducts = false
                //           : isShowProducts = true;
                //     }),
                //     child: Text('Ver productos normales'),
                //   ),w
                // ),
                // isShowProducts?
                BlocBuilder<SizeProductBloc, SizeProductState>(
                  builder: (context, stateSizesProduct) {
                    if (stateSizesProduct is SizeAllProductsLoaded) {
                      return SliverGrid.count(
                        crossAxisCount: 2,
                        childAspectRatio:
                            Responsive.isMobile(context) ? 0.75 : 1,
                        children: stateProduct.products.isNotEmpty
                            ? stateProduct.products
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
                                      price: 'S/ ${product.prices.toString()}',
                                      onTap: () =>
                                          Navigator.of(context).pushNamed(
                                        ProductScreen.routeName,
                                        arguments: ProductScreenArguments(
                                            product,
                                            stateSizesProduct.sizeProducts),
                                      ),
                                    ),
                                  ),
                                )
                                .toList()
                            : [const SizedBox()],
                      );
                    }
                    return const SliverToBoxAdapter(
                        child: Center(child: CircularProgressIndicator()));
                  },
                )
              ],
            );
          }
          return const SizedBox();
        },
      ),
    );
  }
}
