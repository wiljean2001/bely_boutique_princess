import 'dart:async';
import 'dart:math';

import 'package:bely_boutique_princess/config/constrants.dart';
import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
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
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<LiquidPullToRefreshState> _refreshIndicatorKey =
      GlobalKey<LiquidPullToRefreshState>();

  static int refreshNum = 10;

  Future<void> _handleRefresh() {
    final Completer<void> completer = Completer<void>();
    Timer(const Duration(seconds: 3), () {
      completer.complete();
    });
    setState(() {
      refreshNum = Random().nextInt(100);
    });
    return completer.future.then<void>((_) {
      ScaffoldMessenger.of(_scaffoldKey.currentState!.context).showSnackBar(
        SnackBar(
          content: const Text('Refresh complete'),
          action: SnackBarAction(
            label: 'RETRY',
            onPressed: () {
              _refreshIndicatorKey.currentState!.show();
            },
          ),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    context.read<SizeProductBloc>().add(LoadAllSizeProducts());
    return Scaffold(
      // backgroundColor: Theme.of(context).scaffoldBackgroundColor.withOpacity(.2),
      key: _scaffoldKey,
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
                SliverFillRemaining(
                  child: LiquidPullToRefresh(
                    key: _refreshIndicatorKey, // key if you want to add
                    onRefresh: _handleRefresh, // refresh callback
                    showChildOpacityTransition: false,
                    child: BlocBuilder<SizeProductBloc, SizeProductState>(
                      builder: (context, stateSizesProduct) {
                        if (stateSizesProduct is SizeAllProductsLoaded) {
                          return GridView.count(
                            crossAxisCount: 2,
                            padding: const EdgeInsets.only(top: kPaddingS),
                            childAspectRatio:
                                Responsive.isMobile(context) ? 0.85 : 1,
                            children: stateProduct.products.isNotEmpty
                                ? stateProduct.products.map(
                                    (product) {
                                      String price = '';
                                      for (var element in product.prices) {
                                        price += 'S/ $element ';
                                      }
                                      return Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: kPaddingS),
                                        child: CustomCardProduct(
                                          context: context,
                                          added: true,
                                          imgPath: product.imageUrls.isNotEmpty
                                              ? product.imageUrls[0]
                                              : 'https://api.lorem.space/image/shoes?w=150&h=150',
                                          // isFavorite: false,
                                          name: product.title,
                                          price: price,
                                          onTap: () =>
                                              Navigator.of(context).pushNamed(
                                            ProductScreen.routeName,
                                            arguments: ProductScreenArguments(
                                              product,
                                              stateSizesProduct.sizeProducts,
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  ).toList()
                                : [const SizedBox()],
                          );
                          // return SliverGrid.count(
                          //   crossAxisCount: 2,
                          //   childAspectRatio:
                          //       Responsive.isMobile(context) ? 0.75 : 1,
                          //   children: stateProduct.products.isNotEmpty
                          //       ? stateProduct.products
                          //           .map(
                          //             (product) => Padding(
                          //               padding: const EdgeInsets.all(kPaddingS),
                          //               child: CustomCardProduct(
                          //                 context: context,
                          //                 added: true,
                          //                 imgPath: product.imageUrls.isNotEmpty
                          //                     ? product.imageUrls[0]
                          //                     : 'https://api.lorem.space/image/shoes?w=150&h=150',
                          //                 // isFavorite: false,
                          //                 name: product.title,
                          //                 price: 'S/ ${product.prices.toString()}',
                          //                 onTap: () =>
                          //                     Navigator.of(context).pushNamed(
                          //                   ProductScreen.routeName,
                          //                   arguments: ProductScreenArguments(
                          //                       product,
                          //                       stateSizesProduct.sizeProducts),
                          //                 ),
                          //               ),
                          //             ),
                          //           )
                          //           .toList()
                          //       : [const SizedBox()],
                          // );
                        }
                        return const Center(child: CircularProgressIndicator());
                      },
                    ),
                  ),
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
