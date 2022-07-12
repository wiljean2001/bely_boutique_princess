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
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
