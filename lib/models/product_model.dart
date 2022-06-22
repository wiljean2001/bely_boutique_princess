import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class Product extends Equatable {
  final String? id; // identificador - PK
  final String title; // titulo o nombre del producto
  final String descript; // descripcion del producto
  final double price; // descripcion del producto
  final List<dynamic> imageUrls; // imagenes - fotos
  final List<dynamic> sizes; //tallas
  final List<dynamic> categories;

  // Constructor
  const Product({
    this.id,
    required this.categories,
    required this.title,
    required this.descript,
    required this.price,
    required this.imageUrls,
    required this.sizes,
  });

  @override
  List<Object?> get props => [
        id,
        categories,
        title,
        price,
        descript,
        imageUrls,
        sizes,
      ];

// Snapshot de la Base de datos, obtener datos
  static Product fromSnapshot(DocumentSnapshot snap) {
    Product product = Product(
      id: snap.id,
      categories: snap['categories'],
      title: snap['title'],
      descript: snap['descript'],
      imageUrls: snap['imageUrls'],
      sizes: snap['sizes'],
      price: snap['price'],
    );
    return product;
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'categories': categories,
      'descript': descript,
      'imageUrls': imageUrls,
      'sizes': sizes,
      'price': price,
    };
  }

  Product copyWith({
    String? id,
    String? title,
    String? descript,
    List<dynamic>? imageUrls,
    List<dynamic>? sizes,
    List<dynamic>? categories,
    double? price,
  }) {
    return Product(
      id: id ?? this.id,
      title: title ?? this.title,
      descript: descript ?? this.descript,
      imageUrls: imageUrls ?? this.imageUrls,
      sizes: sizes ?? this.sizes,
      price: price ?? this.price,
      categories: categories ?? this.categories,
    );
  }
}
