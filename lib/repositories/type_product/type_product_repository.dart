import 'package:bely_boutique_princess/models/type_product_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'base_type_product_repository.dart';

class TypeProductRepository extends BaseTypeProductRepository {
  final FirebaseFirestore _firebaseFirestore;

  TypeProductRepository({FirebaseFirestore? firebaseFirestore})
      : _firebaseFirestore = firebaseFirestore ?? FirebaseFirestore.instance;
  @override
  Stream<List<TypeProduct>> getAllTypeProducts() {
    return _firebaseFirestore
        .collection('typeProducts')
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) => TypeProduct.fromSnapshot(doc)).toList();
    });
  }

  @override
  Stream<TypeProduct> getTypeProduct(String typeProductId) {
    return _firebaseFirestore
        .collection('typeProducts')
        .doc(typeProductId)
        .snapshots()
        .map(
          (snap) => TypeProduct.fromSnapshot(snap),
        );
  }

  @override
  Future<void> createTypeProduct(TypeProduct typeProduct) async {
    return await _firebaseFirestore.collection('typeProducts').doc().set(
          typeProduct.toMap(),
        );
  }

  @override
  Future<void> updateTypeProduct(TypeProduct typeProduct) async {
    await _firebaseFirestore
        .collection('typeProduct')
        .doc(typeProduct.id)
        .update(
          typeProduct.toMap(),
        );
  }

  @override
  Future<void> deleteTypeProduct(TypeProduct typeProduct) async {
    await _firebaseFirestore
        .collection('typeProduct')
        .doc(typeProduct.id)
        .delete();
  }
}
