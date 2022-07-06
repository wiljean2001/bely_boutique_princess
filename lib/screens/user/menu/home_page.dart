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
      //   ScaffoldMessenger.of(_scaffoldKey.currentState!.context).showSnackBar(
      //     SnackBar(
      //       content: const Text('Refresh complete'),
      //       action: SnackBarAction(
      //         label: 'RETRY',
      //         onPressed: () {
      //           _refreshIndicatorKey.currentState!.show();
      //         },
      //       ),
      //     ),
      //   );
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
            return BlocBuilder<SizeProductBloc, SizeProductState>(
              builder: (context, stateSizesProduct) {
                if (stateSizesProduct is SizeAllProductsLoaded) {
                  return CustomScrollView(
                    // physics: const BouncingScrollPhysics(),
                    slivers: <Widget>[
                      CustomSliverAppBar(
                        title: S.of(context).AppTitle,
                        onTapOption: () {
                          showSearch(
                            context: context,
                            delegate: ProductSearchDelegate(
                              history,
                              products: stateProduct.products,
                              resultSizesProduct:
                                  stateSizesProduct.sizeProducts,
                            ),
                          );
                        },
                      ),
                      showAllProduct(
                        context,
                        stateProduct,
                        stateSizesProduct,
                      ), // Grid Products
                    ],
                  );
                }
                return const SizedBox();
              },
            );
          }
          return const SizedBox();
        },
      ),
    );
  }

  SliverFillRemaining showAllProduct(BuildContext context,
      ProductsLoaded stateProduct, SizeAllProductsLoaded stateSizesProduct) {
    return SliverFillRemaining(
      child: LiquidPullToRefresh(
        key: _refreshIndicatorKey, // key if you want to add
        onRefresh: _handleRefresh, // refresh callback
        color: Theme.of(context).primaryColor,
        showChildOpacityTransition: false,
        child: GridView.count(
          crossAxisCount: 2,
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.only(
            top: kPaddingS,
            bottom: 65,
          ),
          childAspectRatio: Responsive.isMobile(context) ? 0.85 : 1.2,
          children: stateProduct.products.isNotEmpty
              ? stateProduct.products.map(
                  (product) {
                    return Padding(
                      padding:
                          const EdgeInsets.symmetric(horizontal: kPaddingS),
                      child: CustomCardProduct(
                        context: context,
                        added: true,
                        imgPath: product.imageUrls.isNotEmpty
                            ? product.imageUrls[0]
                            : 'https://api.lorem.space/image/shoes?w=150&h=150',
                        // isFavorite: false,
                        name: product.title,
                        price: 'S/ ${product.prices.join(' S/ ')}',
                        onTap: () => Navigator.of(context).pushNamed(
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
        ),
      ),
    );
  }
}
