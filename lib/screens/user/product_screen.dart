import 'package:bely_boutique_princess/utils/custom_alert_dialog.dart';
import 'package:bely_boutique_princess/utils/show_alert.dart';
import 'package:bely_boutique_princess/widgets/custom_carousel_sliders%20copy.dart';
import 'package:bely_boutique_princess/widgets/custom_multi_dropdown.dart';
import 'package:carousel_slider/carousel_controller.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_custom_dialog/flutter_custom_dialog.dart';
import 'package:flutter_dropdown/flutter_dropdown.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:pinch_zoom_image_last/pinch_zoom_image_last.dart';

import '../../blocs/blocs.dart';
import '../../config/constrants.dart';
import '../../config/responsive.dart';
import '../../models/models.dart';
import '../../widgets/Custom_loading_screen.dart';
import '../../widgets/custom_app_bar_avatar.dart';
import '../../widgets/custom_card_product.dart';
import '../../widgets/custom_carousel_sliders.dart';

// falta cambiar los textos a dinamicos

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
  @override
  Widget build(BuildContext context) {
    // print(context.read<AuthBloc>().state.user!.uid);
    // print(context.read<AuthBloc>().state.user!.email);
    // print(context.read<AuthBloc>().state.user!.reauthenticateWithCredential(AuthCredential(providerId: providerId, signInMethod: signInMethod)));
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
            avatar: PinchZoomImage(
              image: Image.network(
                product.imageUrls.isNotEmpty
                    ? product.imageUrls[0]
                    : 'https://api.lorem.space/image/shoes?w=150&h=150',
                fit: BoxFit.fitWidth,
                alignment: Alignment.center,
                width: double.infinity,
              ),
              // onZoomStart: () {
              //   print('Zoom started');
              // },
              // onZoomEnd: () {
              //   print('Zoom finished');
              // },
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
                        Expanded(child: CustomExtraProducts()),
                        SizedBox(
                          height: 10,
                        ),
                        Expanded(child: CustomExtraProducts()),
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

//  Cambiarlo para recibir de la base de datos
class CustomExtraProducts extends StatelessWidget {
  const CustomExtraProducts({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductBloc, ProductState>(
      builder: (context, state) {
        if (state is ProductLoading) return const CustomLoadingScreen();
        return ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: 10,
          itemBuilder: (BuildContext context, int index) {
            return CustomCardProduct(
              name: "blusas",
              price: "2.00",
              imgPath:
                  'https://api.lorem.space/image/shoes?w=${150 + index}&h=${150 + index}',
              added: false,
              // isFavorite: false,
              context: context,
              quantity: false, // mostrar opciones
              isShowFavorite: false, // mostrar opcion fav
              onTap: () {},
            );
          },
        );
      },
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
  int quantity = 0;
  String sizesProductString = '';
  @override
  Widget build(BuildContext context) {
    // Get Sizes product
    sizesProductString = '';
    for (var productColl in widget.product.sizes) {
      for (var sizeProductCall in widget.sizesProduct) {
        if (sizeProductCall.id == productColl)
          sizesProductString += '${sizeProductCall.size}, ';
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

          Padding(
            padding: EdgeInsets.symmetric(
                horizontal:
                    Responsive.isMobile(context) ? kPaddingS : kPaddingL),
            child: CustomCarouselSliders2(itImages: widget.product.imageUrls),
          ),
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
                                  items: widget.product.sizes,
                                  customWidgets: widget.product.sizes
                                      .map((e) => Text(e))
                                      .toList(),
                                  hint: const Text('Seleccionar Talla'),
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
                                      onPressed: () {},
                                      label: const Text("Solicitar"),
                                      icon: const Icon(Icons.add_shopping_cart),
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

class _CustomMiniProduct extends StatelessWidget {
  final IconData icon;
  const _CustomMiniProduct({
    Key? key,
    required this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Icon(icon, size: 90),
      ],
    );
  }
}

class ProductScreenArguments {
  final Product product;
  final List<SizeProduct> sizeProduct;

  ProductScreenArguments(this.product, this.sizeProduct);
}
