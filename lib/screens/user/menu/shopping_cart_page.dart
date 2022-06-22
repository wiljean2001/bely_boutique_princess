import 'package:bely_boutique_princess/widgets/Custom_loading_screen.dart';
import 'package:bely_boutique_princess/widgets/custom_card_product.dart';
import 'package:bely_boutique_princess/widgets/custom_card_shopping.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../blocs/blocs.dart';

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
                  const _CustomProductSpace(),
                  const Divider(
                    indent: 90.0,
                    endIndent: 90.0,
                  ),
                  const Padding(
                    padding: EdgeInsets.only(left: 40),
                    child: Text(
                      'Seguro te gustara',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                  SizedBox(
                    height: 220,
                    child: BlocBuilder<ProductBloc, ProductState>(
                      builder: (context, state) {
                        if (state is ProductLoading) {
                          return const CustomLoadingScreen();
                        }
                        return ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: 10,
                          itemBuilder: (BuildContext context, int index) {
                            return CustomCardShopping(
                                name: "Vestidos de temporada",
                                price: "2.00",
                                imgPath:
                                    'https://api.lorem.space/image/shoes?w=${150 + index}&h=${150 + index}',
                                added: false,
                                isFavorite: false,
                                context: context);
                          },
                        );
                      },
                    ),
                  ),
                  // solucionado
                  SizedBox(
                    height: 220, // alto de los cards
                    child: BlocBuilder<ProductBloc, ProductState>(
                      builder: (context, state) {
                        if (state is ProductLoading) {
                          return const CustomLoadingScreen();
                        }
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
                              onTap: (){},
                            );
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
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
    return SizedBox(
      height: 300,
      child: Center(
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
      ),
    );
  }
}
