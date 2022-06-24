
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class SizeProduct extends Equatable {
  final String? id; // identificador - PK
  final String size; // titulo o nombre de la talla del producto

  // Constructor
  const SizeProduct({
    this.id,
    required this.size,
  });

  @override
  List<Object?> get props => [
        id,
        size,
      ];

// Snapshot de la Base de datos, obtener datos
  static SizeProduct fromSnapshot(DocumentSnapshot snap) {
    SizeProduct sizeProduct = SizeProduct(
      id: snap.id,
      size: snap['size'],
    );
    return sizeProduct;
  }

  Map<String, dynamic> toMap() {
    return {
      'size': size,
    };
  }

  SizeProduct copyWith({
    String? id,
    String? size,
  }) {
    return SizeProduct(
      id: id ?? this.id,
      size: size ?? this.size,
    );
  }
}
