import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class Order extends Equatable {
  final String? id; // identificador - PK
  final String userId; // titulo o nombre de la talla del producto
  final List<String> orderDetailId; // titulo o nombre de la talla del producto
  final bool status; // titulo o nombre de la talla del producto
  final Timestamp orderDate; // titulo o nombre de la talla del producto

  // Constructor
  const Order({
    this.id,
    required this.userId,
    required this.orderDetailId,
    required this.status,
    required this.orderDate,
  });

  @override
  List<Object?> get props => [
        id,
        userId,
        orderDetailId,
        status,
        orderDate,
      ];

// Snapshot de la Base de datos, obtener datos
  static Order fromSnapshot(DocumentSnapshot snap) {
    Order sizeProduct = Order(
      id: snap.id,
      userId: snap['userId'],
      orderDetailId: snap['orderDetailId'],
      status: snap['status'],
      orderDate: snap['orderDate'],
    );
    return sizeProduct;
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'orderDetailId': orderDetailId,
      'status': status,
      'orderDate': orderDate,
    };
  }

  Order copyWith({
    String? id,
    String? userId,
    List<String>? orderDetailId,
    bool? status,
    Timestamp? orderDate,
  }) {
    return Order(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      orderDetailId: orderDetailId ?? this.orderDetailId,
      status: status ?? this.status,
      orderDate: orderDate ?? this.orderDate,
    );
  }
}
