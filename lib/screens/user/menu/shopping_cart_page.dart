import 'package:bely_boutique_princess/blocs/order_detail/order_detail_bloc.dart';
import 'package:bely_boutique_princess/config/constrants.dart';
import 'package:bely_boutique_princess/models/models.dart';
import 'package:bely_boutique_princess/utils/open_all.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../blocs/blocs.dart';
import '../../../widgets/list_view_products.dart';

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
                        // state order datail is loaded
                        if (state is OrderDetailsLoaded) {
                          // orders is nnot empty then
                          if (state.orders.isNotEmpty) {
                            // when orders is not empty
                            // TODO: orders
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
                          // when orders is empty
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
                  // Recomend...
                  const ListViewShowProducts(),
                  const ListViewShowProducts(isReverse: true),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// TODO: ending sales
class SalesLoading extends StatelessWidget {
  final List<OrderDetails> orders;
  const SalesLoading({Key? key, required this.orders}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileBloc, ProfileState>(
      builder: (context, stateProfile) {
        if (stateProfile is ProfileLoaded) {
          return Container(
            height: 50,
            padding: const EdgeInsets.only(right: kPaddingM),
            child: OutlinedButton(
              onPressed: () {
                // OrderDetails orderDetails =
                String mensaje =
                    'Hola, quiero consultar estos productos:\nSoy: ${stateProfile.user.name} - ${stateProfile.user.id}\n';
                for (var order in orders) {
                  for (var productShopping in _LIST_PRODUCT_SHOPPING_CART) {
                    if (order.productId == productShopping.id) {
                      mensaje +=
                          'ORDEN: ${order.id}\nID Producto: ${productShopping.id}\nProducto: ${productShopping.title}\nCantidad: ${order.quantify}\nTalla del producto: ${order.sizeProduct}\n';
                    }
                  }
                }
                OpenAll.openwhatsapp(whatsapp: PHONE_BELY, message: mensaje);
              },
              child: const Text('Finalizar pedido'),
            ),
          );
        }
        return const SizedBox();
      },
    );
  }
}

List<Product> _LIST_PRODUCT_SHOPPING_CART = []; // list products of orders

// TODO: Show all orders
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
                trailing: IconButton(
                  onPressed: () {
                    BlocProvider.of<OrderDetailBloc>(context).add(
                      DeleteOrderDetail(orderId: orders[index].id!),
                    );
                  },
                  icon: const Icon(Icons.clear_outlined),
                ),
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

// TODO: when shopping cart is empty
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
