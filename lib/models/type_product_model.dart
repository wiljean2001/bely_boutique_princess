import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class TypeProduct extends Equatable {
  final String? id; // identificador - PK
  final String title; // titulo o nombre del tipo de producto

  // Constructor
  const TypeProduct({
    this.id,
    required this.title,
  });

  @override
  List<Object?> get props => [
        id,
        title,
      ];

// Snapshot de la Base de datos, obtener datos
  static TypeProduct fromSnapshot(DocumentSnapshot snap) {
    TypeProduct typeProduct = TypeProduct(
      id: snap.id,
      title: snap['title'],
    );
    return typeProduct;
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
    };
  }

  TypeProduct copyWith({
    String? id,
    String? title,
  }) {
    return TypeProduct(
      id: id ?? this.id,
      title: title ?? this.title,
    );
  }
}
