import 'package:bely_boutique_princess/blocs/search_order_detail/search_order_detail_bloc.dart';
import 'package:bely_boutique_princess/config/constrants.dart';
import 'package:bely_boutique_princess/utils/show_alert.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../blocs/blocs.dart';
import '../../blocs/order_detail/order_detail_bloc.dart';
import '../../generated/l10n.dart';
import '../../models/models.dart';
import '../../widgets/custom_sliver_app_bar.dart';
import 'package:anim_search_bar/anim_search_bar.dart';

class ScreenOrderDetails extends StatefulWidget {
  static const String routeName = '/order_view'; //route

  static Route route() {
    return MaterialPageRoute(
      settings: const RouteSettings(name: routeName),
      builder: (context) {
        // print the status user with the authbloc
        return const ScreenOrderDetails();
      },
    );
  }

  const ScreenOrderDetails({Key? key}) : super(key: key);

  @override
  State<ScreenOrderDetails> createState() => _ScreenOrderDetailsState();
}

class _ScreenOrderDetailsState extends State<ScreenOrderDetails> {
  TextEditingController textController = TextEditingController();
  @override
  void initState() {
    context.read<SearchOrderDetailBloc>().add(LoadingSearchOrderDetail());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          CustomSliverAppBar(
            title: S.of(context).title_show_details_order,
            hasActions: false,
            hasIcon: false,
            isTextCenter: false,
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.only(top: 10.0, right: 10, left: 10),

              /// In AnimSearchBar widget, the width, textController, onSuffixTap are required properties.
              /// You have also control over the suffixIcon, prefixIcon, helpText and animationDurationInMilli
              child: Column(
                children: [
                  Container(
                    constraints: const BoxConstraints(maxHeight: 50),
                    child: AnimSearchBar(
                      rtl: true,
                      width: 400,
                      textController: textController,
                      // prefixIcon: Icon(Icons.search_outlined),
                      suffixIcon: Icon(Icons.search_outlined),
                      onSuffixTap: () {
                        context.read<SearchOrderDetailBloc>().add(
                              SearchOrderDetailByUserID(
                                  userID: textController.text),
                            );
                        // context.read<OrderDetailBloc>().add(
                        //       LoadOrderDetailById(userId: textController.text),
                        //     );
                        // setState(() {
                        //   textController.clear();
                        // });
                      },
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.all(kPaddingS),
                    child: BlocBuilder<SearchOrderDetailBloc,
                        SearchOrderDetailState>(
                      builder: (context, stateSearchOrderD) {
                        if (stateSearchOrderD is SearchOrderDetailLoaded) {
                          return Wrap(
                            children: [
                              Text('Cliente: ${stateSearchOrderD.user.name}'),
                              const Divider(
                                  height: 0, color: Colors.transparent),
                              Text(
                                  'Ubicación: ${stateSearchOrderD.user.location}'),
                              const Divider(),
                              Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: stateSearchOrderD.orderDetails
                                      .map<Widget>(
                                    (orderDetail) {
                                      Product product = stateSearchOrderD
                                          .products
                                          .firstWhere((element) =>
                                              element.id ==
                                              orderDetail.productId);
                                      return Card(
                                        elevation: 8,
                                        child: Padding(
                                          padding:
                                              const EdgeInsets.all(kPaddingS),
                                          child: GestureDetector(
                                            onTap: () {
                                              ShowAlert.showSuccessSnackBar(
                                                context,
                                                message: 'Ver al producto',
                                              );
                                            },
                                            child: Column(
                                              // alignment:
                                              //     WrapAlignment.spaceBetween,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.stretch,
                                              children: [
                                                Text(
                                                    'ORDEN: ${orderDetail.id}'),
                                                Text(
                                                    'ID Producto: ${product.id}'),
                                                Text(
                                                    'Producto: ${product.title}'),
                                                Text(
                                                    'Cantidad: ${orderDetail.quantify}'),
                                                Text(
                                                    'Talla del producto: ${orderDetail.sizeProduct}'),
                                                Text(
                                                    'Fecha de pedido: ${orderDetail.orderDate.toDate().toString().substring(0, 10)}'),
                                              ],
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  ).toList()),
                            ],
                          );
                        }
                        return const SizedBox();
                      },
                    ),
                  ),
                  // Container(
                  //   margin: const EdgeInsets.all(kPaddingS),
                  //   child: BlocBuilder<OrderDetailBloc, OrderDetailState>(
                  //     builder: (context, state) {
                  //       if (state is OrderDetailsLoaded) {
                  //         _LIST_PRODUCT_SHOPPING_CART.clear();
                  //         orders = state.orders;
                  //         print(orders);
                  //         if (orders!.isNotEmpty) {
                  //           return BlocBuilder<ProductBloc, ProductState>(
                  //             builder: (context, stateProduct) {
                  //               if (stateProduct is ProductsLoaded) {
                  //                 _LIST_PRODUCT_SHOPPING_CART.addAll(
                  //                   stateProduct.products
                  //                       .where(
                  //                         (product) =>
                  //                             product.id == orders![0].userId,
                  //                       )
                  //                       .toList(),
                  //                 );
                  //                 // _LIST_PRODUCT_SHOPPING_CART.add(product);
                  //                 return Wrap(
                  //                   children: orders!.map<Widget>((e) {
                  //                     return Wrap(
                  //                       children: [
                  //                         const Text('Cliente: WILMER AYALA.'),
                  //                         const Divider(height: 0),
                  //                         const Text(
                  //                             'Ubicación: CALLE TACNA 105 / LA UNION'),
                  //                         const Divider(),
                  //                         Column(
                  //                           crossAxisAlignment:
                  //                               CrossAxisAlignment.stretch,
                  //                           children: [
                  //                             Card(
                  //                               elevation: 8,
                  //                               child: Padding(
                  //                                 padding: const EdgeInsets.all(
                  //                                     kPaddingS),
                  //                                 child: GestureDetector(
                  //                                   onTap: () {
                  //                                     ShowAlert
                  //                                         .showSuccessSnackBar(
                  //                                       context,
                  //                                       message:
                  //                                           'Ver al producto',
                  //                                     );
                  //                                   },
                  //                                   child: Wrap(
                  //                                     alignment: WrapAlignment
                  //                                         .spaceBetween,
                  //                                     children: const [
                  //                                       Text(
                  //                                           'ORDEN: 123456789'),
                  //                                       Text(
                  //                                           'ID Producto: 123456789'),
                  //                                       Text(
                  //                                           'Producto: VESTIDO BLANCO'),
                  //                                       Text('Cantidad: 1'),
                  //                                       Text(
                  //                                           'Talla del producto: M'),
                  //                                       Text(
                  //                                           'Fecha de pedido: 30/10/22'),
                  //                                     ],
                  //                                   ),
                  //                                 ),
                  //                               ),
                  //                             ),
                  //                           ],
                  //                         ),
                  //                       ],
                  //                     );
                  //                   }).toList(),
                  //                 );
                  //               }
                  //               return const Center(
                  //                 child: CircularProgressIndicator(),
                  //               );
                  //             },
                  //           );
                  //         }
                  //       }
                  //       return const SizedBox();
                  //     },
                  //   ),
                  // ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/**
 * 




                          return ListView.builder(
                                  itemCount: orders!.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    Product product = state.products.firstWhere(
                                        (element) =>
                                            element.id ==
                                            orders![index].productId);
                                    _LIST_PRODUCT_SHOPPING_CART.add(product);
                                    return ListTile(
                                      title: Text(product.title),
                                      subtitle: Text(
                                        'Cantidad solicitada: ${orders![index].quantify}',
                                      ),
                                      leading: product.imageUrls[0] != null
                                          ? Image.network(product.imageUrls[0])
                                          : const SizedBox(),
                                      trailing: IconButton(
                                        onPressed: () {
                                          BlocProvider.of<OrderDetailBloc>(
                                                  context)
                                              .add(
                                            DeleteOrderDetail(
                                                orderId: orders![index].id!),
                                          );
                                        },
                                        icon: const Icon(Icons.clear_outlined),
                                      ),
                                    );
                                  },
                                );
 */