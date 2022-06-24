import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class Category extends Equatable {
  final String? id;
  final String name;
  final String typeProductId;
  final String imageUrl;

  const Category({
    this.id,
    required this.name,
    required this.typeProductId,
    required this.imageUrl,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        imageUrl,
      ];

  static Category fromSnapshot(DocumentSnapshot snap) {
    Category category = Category(
      id: snap.id,
      name: snap['name'],
      typeProductId: snap['typeProductId'],
      imageUrl: snap['imageUrl'],
    );
    return category;
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'typeProductId': typeProductId,
      'imageUrl': imageUrl,
    };
  }

  Category copyWith({
    // String? id,
    String? name,
    String? typeProductId,
    String? imageUrl,
  }) {
    return Category(
      // id: id ?? this.id,
      name: name ?? this.name,
      typeProductId: typeProductId ?? this.typeProductId,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }
}
