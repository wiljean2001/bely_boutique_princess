import 'package:flutter/material.dart';

import '../config/responsive.dart';

class CustomCardProduct extends StatelessWidget {
  const CustomCardProduct({
    Key? key,
    required this.name,
    required this.price,
    required this.imgPath,
    required this.added,
    // required this.isFavorite,
    required this.context,
    this.isShowAdd = true,
    this.isShowFavorite = true,
    required this.onTap,
  }) : super(key: key);

  final String name;
  final String price;
  final String imgPath;
  final bool added;
  // final bool isFavorite;
  final bool isShowAdd;
  final bool isShowFavorite;
  final BuildContext context;
  final Function onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          const EdgeInsets.only(top: 5.0, bottom: 5.0, left: 5.0, right: 5.0),
      child: InkWell(
        onTap: () => onTap(),
        splashColor: Theme.of(context).primaryColor,
        highlightColor: Theme.of(context).primaryColor,
        child: Container(
          constraints: BoxConstraints(
            maxHeight: Responsive.isMobile(context) ? 200 : 250,
            maxWidth: Responsive.isMobile(context) ? 150 : 250,
          ),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15.0),
              boxShadow: [
                BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    spreadRadius: 3.0,
                    blurRadius: 5.0)
              ],
              color: Colors.white),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // isShowFavorite
              //     ? Padding(
              //         padding: const EdgeInsets.all(5.0),
              //         child: Row(
              //           mainAxisAlignment: MainAxisAlignment.end,
              //           children: [
              //             isFavorite
              //                 ? const Icon(Icons.favorite,
              //                     color: Color(0xFFEF7532))
              //                 : const Icon(Icons.favorite_border,
              //                     color: Color(0xFFEF7532))
              //           ],
              //         ),
              //       )
              //     : const SizedBox(height: 5),
              // Hero(
              //     tag: imgPath.substring(0, 20),
              //     child: Container(
              Container(
                constraints: BoxConstraints(
                  maxHeight: Responsive.isMobile(context) ? 150.0 : 250,
                ),
                // width: 150.0,
                decoration: BoxDecoration(
                  image: DecorationImage(
                      image: NetworkImage(imgPath), fit: BoxFit.contain),
                ),
              ), // ),
              // Image.network(imgPath, fit: BoxFit.contain),
              const SizedBox(height: 7.0),
              Text(price,
                  style: const TextStyle(
                      color: Color(0xFFCC8053), fontSize: 14.0)),
              Text(name,
                  style: const TextStyle(
                      color: Color(0xFF575E67), fontSize: 14.0)),
              isShowAdd
                  ? Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                          color: const Color(0xFFEBEBEB), height: 1.0))
                  : const SizedBox(),
              isShowAdd
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Count restant
                        const Text('¡Quedan '),
                        Text(
                          '20',
                          style:
                              TextStyle(color: Theme.of(context).primaryColor),
                        ),
                        const Text(' disponibles!'),
                      ],
                    )
                  : const SizedBox(),
            ],
          ),
        ),
      ),
    );
  }
}

// if (!added) ...[
                      //   const Icon(Icons.shopping_basket,
                      //       color: Color(0xFFD17E50), size: 12.0),
                      //   const Text('Add to cart',
                      //       style: TextStyle(
                      //           color: Color(0xFFD17E50), fontSize: 12.0))
                      // ],
                      // if (added) ...[
                      //   const Icon(Icons.remove_circle_outline,
                      //       color: Color(0xFFD17E50), size: 12.0),
                      //   const Text('3',
                      //       style: TextStyle(
                      //           color: Color(0xFFD17E50),
                      //           fontWeight: FontWeight.bold,
                      //           fontSize: 12.0)),
                      //   const Icon(Icons.add_circle_outline,
                      //       color: Color(0xFFD17E50), size: 12.0),
                      // ],