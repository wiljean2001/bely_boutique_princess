import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class OrderDetails extends Equatable {
  final String? id; // identificador - PK
  final String productId; // titulo o nombre de la talla del producto
  final int quantify; // titulo o nombre de la talla del producto
  final Timestamp orderDate; // titulo o nombre de la talla del producto
  final String
      userId; // titulo o nombre de la talla del producto  // Constructor
  const OrderDetails({
    this.id,
    required this.productId,
    required this.userId,
    required this.quantify,
    required this.orderDate,
  });

  @override
  List<Object?> get props => [
        id,
        productId,
        userId,
        quantify,
        orderDate,
      ];

// Snapshot de la Base de datos, obtener datos
  static OrderDetails fromSnapshot(DocumentSnapshot snap) {
    OrderDetails sizeProduct = OrderDetails(
      id: snap.id,
      productId: snap['productId'],
      userId: snap['userId'],
      quantify: snap['quantify'],
      orderDate: snap['orderDate'],
    );
    return sizeProduct;
  }

  Map<String, dynamic> toMap() {
    return {
      'productId': productId,
      'userId': userId,
      'quantify': quantify,
      'orderDate': orderDate,
    };
  }

  OrderDetails copyWith({
    String? id,
    String? productId,
    String? userId,
    int? quantify,
    Timestamp? orderDate,
  }) {
    return OrderDetails(
      id: id ?? this.id,
      productId: productId ?? this.productId,
      userId: userId ?? this.userId,
      quantify: quantify ?? this.quantify,
      orderDate: orderDate ?? this.orderDate,
    );
  }
}
