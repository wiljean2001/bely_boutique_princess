import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class OrderDetails extends Equatable {
  final String? id; // identificador - PK
  final String productId; // titulo o nombre de la talla del producto
  final String quantify; // titulo o nombre de la talla del producto
  final Timestamp orderDate; // titulo o nombre de la talla del producto

  // Constructor
  const OrderDetails({
    this.id,
    required this.productId,
    required this.quantify,
    required this.orderDate,
  });

  @override
  List<Object?> get props => [
        id,
        productId,
        quantify,
        orderDate,
      ];

// Snapshot de la Base de datos, obtener datos
  static OrderDetails fromSnapshot(DocumentSnapshot snap) {
    OrderDetails sizeProduct = OrderDetails(
      id: snap.id,
      productId: snap['productId'],
      quantify: snap['quantify'],
      orderDate: snap['orderDate'],
    );
    return sizeProduct;
  }

  Map<String, dynamic> toMap() {
    return {
      'productId': productId,
      'quantify': quantify,
      'orderDate': orderDate,
    };
  }

  OrderDetails copyWith({
    String? id,
    String? productId,
    String? quantify,
    Timestamp? orderDate,
  }) {
    return OrderDetails(
      id: id ?? this.id,
      productId: productId ?? this.productId,
      quantify: quantify ?? this.quantify,
      orderDate: orderDate ?? this.orderDate,
    );
  }
}
