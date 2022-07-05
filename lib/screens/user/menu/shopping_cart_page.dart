import 'package:bely_boutique_princess/blocs/order_detail/order_detail_bloc.dart';
import 'package:bely_boutique_princess/config/constrants.dart';
import 'package:bely_boutique_princess/models/models.dart';
import 'package:bely_boutique_princess/utils/open_all.dart';
import 'package:bely_boutique_princess/widgets/Custom_loading_screen.dart';
import 'package:bely_boutique_princess/widgets/custom_card_product.dart';
import 'package:bely_boutique_princess/widgets/custom_card_shopping.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../blocs/blocs.dart';
import '../../../blocs/order/order_bloc.dart';
import '../../../config/responsive.dart';
import '../../../models/order_model.dart';
import '../product_screen.dart';

// falta cambiar los textos a dinamicos

class ShoppingCartView extends StatelessWidget {
  const ShoppingCartView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: <Widget>[
            SliverToBoxAdapter(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  const Padding(
                    padding: EdgeInsets.only(top: 15, left: 40),
                    child: Text(
                      'Cesta',
                      style: TextStyle(
                        fontSize: 25,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 300,
                    child: BlocBuilder<OrderDetailBloc, OrderDetailState>(
                      builder: (context, state) {
                        if (state is OrderDetailLoading) {
                          return const Center(
                              child: CircularProgressIndicator());
                        }
                        if (state is OrderDetailsLoaded) {
                          if (state.orders.isNotEmpty) {
                            // when orders is not empty
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                SizedBox(
                                  height: 250,
                                  child: CustomShowOrders(orders: state.orders),
                                ),
                                SalesLoading(orders: state.orders),
                              ],
                            );
                          }
                          return const _CustomProductSpace();
                        }
                        return const SizedBox();
                      },
                    ),
                  ),
                  Divider(
                    indent: 90.0,
                    endIndent: 90.0,
                    height: kPaddingM,
                    color: Theme.of(context).primaryColor,
                  ),
                  const Padding(
                    padding: EdgeInsets.only(left: 40),
                    child: Text(
                      'Seguro te gustara',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                  const ListViewShowProducts(),
                  const ListViewShowProducts(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SalesLoading extends StatelessWidget {
  final List<OrderDetails> orders;
  const SalesLoading({Key? key, required this.orders}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      padding: const EdgeInsets.only(right: kPaddingM),
      child: OutlinedButton(
        onPressed: () {
          // OrderDetails orderDetails =
          String mensaje = 'Hola, quiero consultar estos productos:\n';
          for (var order in orders) {
            for (var productShopping in _LIST_PRODUCT_SHOPPING_CART) {
              if (order.productId == productShopping.id) {
                mensaje +=
                    'ID Producto: ${productShopping.id}\nProducto: ${productShopping.title}\nCantidad: ${order.quantify}\n';
              }
            }
          }
          OpenAll.openwhatsapp(whatsapp: '+51953433761', message: mensaje);
        },
        child: const Text('Finalizar pedido'),
      ),
    );
  }
}

class ListViewShowProducts extends StatelessWidget {
  const ListViewShowProducts({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 220,
      child: BlocBuilder<ProductBloc, ProductState>(
        builder: (context, state) {
          if (state is ProductLoading) {
            return const CustomLoadingScreen();
          }
          if (state is ProductsLoaded) {
            return ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: state.products.length,
              itemBuilder: (BuildContext context, int index) {
                return BlocBuilder<SizeProductBloc, SizeProductState>(
                  builder: (context, stateSizesProduct) {
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

List<Product> _LIST_PRODUCT_SHOPPING_CART = [];

class CustomShowOrders extends StatelessWidget {
  final List<OrderDetails> orders;
  const CustomShowOrders({
    Key? key,
    required this.orders,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductBloc, ProductState>(
      builder: (context, state) {
        if (state is ProductsLoaded) {
          _LIST_PRODUCT_SHOPPING_CART.clear();
          return ListView.builder(
            itemCount: orders.length,
            itemBuilder: (BuildContext context, int index) {
              Product product = state.products.firstWhere(
                  (element) => element.id == orders[index].productId);
              _LIST_PRODUCT_SHOPPING_CART.add(product);
              return ListTile(
                title: Text(product.title),
                subtitle: Text(
                  'Cantidad solicitada: ${orders[index].quantify}',
                ),
                leading: product.imageUrls[0] != null
                    ? Image.network(product.imageUrls[0])
                    : const SizedBox(),
              );
            },
          );
        }
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}

//espacio de trabajo
class _CustomProductSpace extends StatelessWidget {
  const _CustomProductSpace({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: const [
          Icon(
            Icons.shopping_cart,
            color: Color(0xA9A9A9A9),
            size: 120,
          ),
          Text(
            'No hay nada en tu cesta',
            style: TextStyle(
              color: Color(0xA9A9A9A9),
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}
