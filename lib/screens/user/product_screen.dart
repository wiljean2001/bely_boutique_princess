import 'package:bely_boutique_princess/blocs/order_detail/order_detail_bloc.dart';
import 'package:bely_boutique_princess/utils/custom_alert_dialog.dart';
import 'package:bely_boutique_princess/utils/show_alert.dart';
import 'package:bely_boutique_princess/widgets/custom_carousel_sliders%20copy.dart';
import 'package:carousel_slider/carousel_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_custom_dialog/flutter_custom_dialog.dart';
import 'package:flutter_dropdown/flutter_dropdown.dart';
import 'package:pinch_zoom_image_last/pinch_zoom_image_last.dart';

import '../../blocs/blocs.dart';
import '../../config/constrants.dart';
import '../../config/responsive.dart';
import '../../models/models.dart';
import '../../widgets/custom_app_bar_avatar.dart';
import '../../widgets/list_view_products.dart';

class ProductScreen extends StatefulWidget {
  static const String routeName = '/product'; //route

  static Route route({
    required ProductScreenArguments productArguments,
  }) {
    return MaterialPageRoute(
      settings: const RouteSettings(name: routeName),
      builder: (context) {
        // print the status user with the authbloc
        return ProductScreen(
          productArguments: productArguments,
        );
      },
    );
  }

  final ProductScreenArguments productArguments;
  // pruebas:
  // final
  const ProductScreen({
    Key? key,
    required this.productArguments,
  }) : super(key: key);

  @override
  ProductScreenState createState() {
    return ProductScreenState(
        productArguments.product, productArguments.sizeProduct);
  }
}

class ProductScreenState extends State<ProductScreen> {
  final Product product;
  final List<SizeProduct> sizesProduct;
  ProductScreenState(this.product, this.sizesProduct);

  final controller = CarouselController();

  BoxFit imageBoxFit = BoxFit.fitWidth; // fit image

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          TransitionAppBar(
            // avatar:  Image.network(
            //   product.imageUrls.isNotEmpty
            //       ? product.imageUrls[0]
            //       : 'https://api.lorem.space/image/shoes?w=150&h=150',
            //   fit: BoxFit.fitWidth,
            //   alignment: Alignment.center,
            // ),
            avatar: GestureDetector(
              child: PinchZoomImage(
                image: Image.network(
                  product.imageUrls.isNotEmpty
                      ? product.imageUrls[0]
                      : 'https://api.lorem.space/image/shoes?w=150&h=150',
                  fit: imageBoxFit,
                  alignment: Alignment.center,
                  width: double.infinity,
                ),
              ),
              onTap: () {
                if (imageBoxFit == BoxFit.fitWidth) {
                  imageBoxFit = BoxFit.fitHeight;
                } else {
                  imageBoxFit = BoxFit.fitWidth;
                }
                setState(() {});
              },
            ),
            withIcon: true,
            title: product.title,
            extent: Responsive.isMobile(context) ? 300 : 600,
            textTheme: Theme.of(context).textTheme.bodyLarge!.copyWith(
              fontSize: 22,
              shadows: [
                Shadow(color: Theme.of(context).primaryColor, blurRadius: 10)
              ],
            ),
            onTapIcon: () => Navigator.of(context).pop(),
          ),
          SliverToBoxAdapter(
            child: ConstrainedBox(
              constraints:
                  BoxConstraints(minHeight: MediaQuery.of(context).size.height),
              child: Column(
                children: <Widget>[
                  CustomInfoProduct(
                      product: product, sizesProduct: sizesProduct),
                  // const CustomInfoMiniProduct(),

                  const Divider(
                    height: 10,
                    color: Colors.black,
                    endIndent: 20,
                    indent: 20,
                  ),
                  Container(
                    constraints: BoxConstraints(
                      maxHeight: Responsive.isMobile(context)
                          ? 500
                          : 600, // alto de los cards
                    ),
                    child: Column(
                      children: const [
                        ListViewShowProducts(),
                        ListViewShowProducts(isReverse: true),
                        // SizedBox(
                        //   height: 10,
                        // ),
                      ],
                    ),
                    // color: Colors.red,
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

class CustomInfoProduct extends StatefulWidget {
  final Product product;
  final List<SizeProduct> sizesProduct;
  const CustomInfoProduct({
    Key? key,
    required this.product,
    required this.sizesProduct,
  }) : super(key: key);
  @override
  State<CustomInfoProduct> createState() => _CustomInfoProductState();
}

class _CustomInfoProductState extends State<CustomInfoProduct> {
  String sizesProductString = '';
  List<SizeProduct> listSizesShow = [];
  int quantity = 0; // quantity products
  SizeProduct? listSizes; // sizes product

  @override
  Widget build(BuildContext context) {
    // Get Sizes product
    sizesProductString = '';
    listSizesShow.clear();
    for (var productColl in widget.product.sizes) {
      for (var sizeProductCall in widget.sizesProduct) {
        if (sizeProductCall.id == productColl) {
          sizesProductString += '${sizeProductCall.size}, ';
          listSizesShow.add(sizeProductCall);
        }
      }
    }
    return Container(
      height: Responsive.isMobile(context) ? 340 : 400,
      padding: const EdgeInsets.all(10),
      child: Wrap(
        crossAxisAlignment: WrapCrossAlignment.center,
        alignment: WrapAlignment.center,
        runAlignment: WrapAlignment.spaceAround,
        // mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          // const Divider(height: 10),
          // Text(product.title, style: const TextStyle(fontSize: 22)),
          Center(
            child: Text(
              widget.product.descript,
              style: const TextStyle(fontSize: 18),
              textAlign: TextAlign.center,
            ),
          ),
          const Text(
            'Precios: ',
            style: TextStyle(fontSize: 18),
          ),
          Text(
            'S/ ${widget.product.prices.join(' S/')}',
            style: const TextStyle(fontSize: 18),
            textAlign: TextAlign.center,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Tallas: ${sizesProductString.substring(
                  0,
                  sizesProductString.length > 2
                      ? sizesProductString.length - 2
                      : null,
                )}',
                style: const TextStyle(fontSize: 18),
              ),
            ],
          ),
          // IMAGES as mini images product
          Padding(
            padding: EdgeInsets.symmetric(
                horizontal:
                    Responsive.isMobile(context) ? kPaddingS : kPaddingL),
            child: CustomCarouselSliders2(
              itImages: widget.product.imageUrls,
            ),
          ),
          // BUTTON TO REQUEST PRODUCT
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: Container(
              alignment: AlignmentDirectional.topEnd,
              child: Container(
                constraints: BoxConstraints(
                  minWidth: Responsive.isMobile(context) ? 100 : 200,
                  minHeight: Responsive.isMobile(context) ? 45 : 50,
                ),
                child: ElevatedButton.icon(
                  onPressed: () {
                    CustomAlertDialog.contentButtonAndTitleWithouthAnimation(
                      context: context,
                      gravity: Gravity.bottom,
                      content: StatefulBuilder(
                        builder: (context, setState) {
                          return Container(
                            height: 200,
                            padding: const EdgeInsets.symmetric(
                                horizontal: kPaddingM),
                            child: Wrap(
                              children: [
                                const Text("Cantidad:"),
                                Row(
                                  children: [
                                    Expanded(
                                      child: Slider(
                                        value: quantity.toDouble(),
                                        onChanged: (value) {
                                          setState(() {
                                            quantity = value.round();
                                          });
                                        },
                                        min: 0,
                                        max: 50,
                                      ),
                                    ),
                                    Text(quantity.toString()),
                                  ],
                                ),
                                const Text("Talla:"),
                                DropDown(
                                  isExpanded: true,
                                  items: listSizesShow,
                                  customWidgets: listSizesShow
                                      .map((e) => Text(e.size))
                                      .toList(),
                                  hint: const Text('Seleccionar Talla'),
                                  onChanged: (SizeProduct? values) {
                                    listSizes = values;
                                  },
                                ),
                                Container(
                                  alignment: AlignmentDirectional.topEnd,
                                  child: Container(
                                    constraints: BoxConstraints(
                                      minWidth: Responsive.isMobile(context)
                                          ? 100
                                          : 200,
                                      minHeight: Responsive.isMobile(context)
                                          ? 45
                                          : 50,
                                    ),
                                    child: ElevatedButton.icon(
                                      label: const Text("Solicitar"),
                                      icon: const Icon(Icons.add_shopping_cart),
                                      onPressed: () {
                                        // read
                                        if (quantity > 0 && listSizes != null) {
                                          OrderDetails orderDetails =
                                              OrderDetails(
                                            productId: widget.product.id!,
                                            userId: context
                                                .read<AuthBloc>()
                                                .state
                                                .user!
                                                .uid,
                                            quantify: quantity,
                                            sizeProduct: listSizes!.size,
                                            orderDate: Timestamp.fromDate(
                                                DateTime.now()),
                                          );
                                          BlocProvider.of<OrderDetailBloc>(
                                                  context)
                                              .add(AddOrderDetail(
                                                  order: orderDetails));
                                          ShowAlert.showMessage(
                                            msg:
                                                'Agregado al carrito excitosamente!.',
                                            backGroundColor:
                                                Colors.green.shade400,
                                          );
                                          return;
                                        }
                                        ShowAlert.showMessage(
                                          msg: 'Por favor completas el pedido.',
                                          backGroundColor: Colors.pink,
                                          textColor: Colors.white,
                                        );
                                        return;
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                      title: Text(''),
                    );
                  },
                  label: const Text("Solicitar"),
                  icon: const Icon(Icons.add_shopping_cart),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ProductScreenArguments {
  final Product product;
  final List<SizeProduct> sizeProduct;

  ProductScreenArguments(this.product, this.sizeProduct);
}
