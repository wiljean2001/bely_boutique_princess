import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class SizeProduct extends Equatable {
  final String? id; // identificador - PK
  final String size; // titulo o nombre de la talla del producto
  final String typeProductId; // titulo o nombre de la talla del producto

  // Constructor
  const SizeProduct({
    this.id,
    required this.size,
    required this.typeProductId,
  });

  @override
  List<Object?> get props => [
        id,
        size,
        typeProductId,
      ];

// Snapshot de la Base de datos, obtener datos
  static SizeProduct fromSnapshot(DocumentSnapshot snap) {
    SizeProduct sizeProduct = SizeProduct(
      id: snap.id,
      size: snap['size'],
      typeProductId: snap['typeProductId'],
    );
    return sizeProduct;
  }

  Map<String, dynamic> toMap() {
    return {
      'size': size,
      'typeProductId': typeProductId,
    };
  }

  SizeProduct copyWith({
    String? id,
    String? size,
    String? typeProductId,
  }) {
    return SizeProduct(
      id: id ?? this.id,
      size: size ?? this.size,
      typeProductId: typeProductId ?? this.typeProductId,
    );
  }
}
