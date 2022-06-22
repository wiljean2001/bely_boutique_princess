import 'package:flutter/material.dart';

//estoy probando algo aun no lo implementare
class CustomCardShopping extends StatelessWidget {
  const CustomCardShopping({
    Key? key,
    required this.name,
    required this.price,
    required this.imgPath,
    required this.added,
    required this.isFavorite,
    required this.context,
  }) : super(key: key);

  final String name;
  final String price;
  final String imgPath;
  final bool added;
  final bool isFavorite;
  final BuildContext context;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          const EdgeInsets.only(top: 5.0, bottom: 5.0, left: 5.0, right: 5.0),
      child: InkWell(
        onTap: () {},
        child: Container(
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
            children: [
              Padding(
                  padding: const EdgeInsets.all(2.0),
                  child:
                      Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                    isFavorite
                        ? const Icon(Icons.favorite, color: Color(0xFFEF7532))
                        : const Icon(Icons.favorite_border,
                            color: Color(0xFFEF7532))
                  ])),
              Hero(
                  tag: imgPath,
                  child: Container(
                      height: 100.0,
                      width: 100.0,
                      decoration: BoxDecoration(
                          image: DecorationImage(
                              image: NetworkImage(imgPath),
                              fit: BoxFit.contain)))),
              const SizedBox(height: 5.0),
              Text(price,
                  style: const TextStyle(
                      color: Color(0xFFCC8053), fontSize: 14.0)),
              Text(name,
                  style: const TextStyle(
                      color: Color(0xFF575E67), fontSize: 14.0)),
              Padding(
                  padding: const EdgeInsets.all(2.0),
                  child:
                      Container(color: const Color(0xFFEBEBEB), height: 1.0)),
              Padding(
                padding: const EdgeInsets.only(left: 5.0, right: 5.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    if (!added) ...[
                      const Icon(Icons.shopping_basket,
                          color: Color(0xFFD17E50), size: 12.0),
                      const Text('Add to cart',
                          style: TextStyle(
                              color: Color(0xFFD17E50), fontSize: 12.0))
                    ],
                    if (added) ...[
                      const Icon(Icons.remove_circle_outline,
                          color: Color(0xFFD17E50), size: 12.0),
                      const Text('3',
                          style: TextStyle(
                              color: Color(0xFFD17E50),
                              fontWeight: FontWeight.bold,
                              fontSize: 12.0)),
                      const Icon(Icons.add_circle_outline,
                          color: Color(0xFFD17E50), size: 12.0),
                    ],
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
