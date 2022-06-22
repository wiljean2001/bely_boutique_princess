import 'package:bely_boutique_princess/utils/show_alert.dart';
import 'package:bely_boutique_princess/widgets/custom_carousel_sliders%20copy.dart';
import 'package:carousel_slider/carousel_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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

  static Route route({required Product product}) {
    return MaterialPageRoute(
      settings: const RouteSettings(name: routeName),
      builder: (context) {
        // print the status user with the authbloc
        return ProductScreen(product: product);
      },
    );
  }

  final Product product;
  // pruebas:
  // final
  const ProductScreen({
    Key? key,
    required this.product,
  }) : super(key: key);

  @override
  ProductScreenState createState() {
    return ProductScreenState(product);
  }
}

class ProductScreenState extends State<ProductScreen> {
  final Product product;
  ProductScreenState(this.product);

  final controller = CarouselController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          TransitionAppBar(
            avatar: Image.network(
              product.imageUrls.isNotEmpty
                  ? product.imageUrls[0]
                  : 'https://api.lorem.space/image/shoes?w=150&h=150',
              fit: BoxFit.fitWidth,
              alignment: Alignment.center,
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
                  CustomInfoProduct(product: product),
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
              isShowAdd: false, // mostrar opciones
              isShowFavorite: false, // mostrar opcion fav
              onTap: () {},
            );
          },
        );
      },
    );
  }
}
// //
// class CustomInfoMiniProduct extends StatelessWidget {
//   const CustomInfoMiniProduct({
//     Key? key,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       height: 150,
//       child: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 15),
//         child: Column(
//           children: [
//             Row(
//               crossAxisAlignment: CrossAxisAlignment.center,
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: <Widget>[
//                 const Icon(
//                   Icons.keyboard_arrow_left,
//                   size: 55,
//                 ),
//                 ConstrainedBox(
//                   constraints: const BoxConstraints(maxWidth: 270),
//                   child: SingleChildScrollView(
//                     scrollDirection: Axis.horizontal,
//                     primary: true,
//                     child: Row(
//                       children: const [
//                         _CustomMiniProduct(icon: Icons.shopping_bag),
//                         _CustomMiniProduct(icon: Icons.shopping_bag),
//                         _CustomMiniProduct(icon: Icons.shopping_bag),
//                         _CustomMiniProduct(icon: Icons.shopping_bag),
//                       ],
//                     ),
//                   ),
//                 ),
//                 const Icon(
//                   Icons.keyboard_arrow_right,
//                   size: 55,
//                 ),
//               ],
//             ),
//             Container(
//               alignment: AlignmentDirectional.topEnd,
//               child: ElevatedButton.icon(
//                 onPressed: () {},
//                 label: const Text("Solicitar"),
//                 icon: const Icon(Icons.add_shopping_cart),
//               ),
//             ),
//           ],
//         ),
//       ),
//       // color: Colors.blue,
//     );
//   }
// }

class CustomInfoProduct extends StatelessWidget {
  final Product product;
  const CustomInfoProduct({
    Key? key,
    required this.product,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: Responsive.isMobile(context) ? 340 : 400,
      padding: const EdgeInsets.all(10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          const Divider(height: 10),
          // Text(product.title, style: const TextStyle(fontSize: 22)),
          Text(product.descript, style: const TextStyle(fontSize: 18)),
          Text('S/ ${product.price}', style: const TextStyle(fontSize: 18)),
          Text(
            'Tallas: ${product.sizes.map((e) => e)}',
            style: const TextStyle(fontSize: 18),
          ),
          Padding(
            padding: EdgeInsets.symmetric(
                horizontal:
                    Responsive.isMobile(context) ? kPaddingS : kPaddingL),
            child: CustomCarouselSliders2(itImages: product.imageUrls),
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
                  onPressed: () {},
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
