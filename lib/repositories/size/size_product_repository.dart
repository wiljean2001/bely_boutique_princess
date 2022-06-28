import 'package:cloud_firestore/cloud_firestore.dart';
import '../../models/size_model.dart';
import 'base_size_product_repository.dart';

class SizeProductRepository extends BaseSizeProductRepository {
  final FirebaseFirestore _firebaseFirestore;

  SizeProductRepository({FirebaseFirestore? firebaseFirestore})
      : _firebaseFirestore = firebaseFirestore ?? FirebaseFirestore.instance;
  @override
  Stream<List<SizeProduct>> getAllSizeProducts() {
    return _firebaseFirestore
        .collection('sizeProducts')
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) => SizeProduct.fromSnapshot(doc)).toList();
    });
  }

  @override
  Stream<List<SizeProduct>> getSizeProducts(String typeProductId) {
    return _firebaseFirestore
        .collection('sizeProducts')
        .where('typeProductId', isEqualTo: typeProductId)
        .snapshots()
        .map((snap) {
      return snap.docs.map((doc) => SizeProduct.fromSnapshot(doc)).toList();
    });
  }

  @override
  Stream<SizeProduct> getSizeProduct(String sizeProductId) {
    return _firebaseFirestore
        .collection('sizeProducts')
        .doc(sizeProductId)
        .snapshots()
        .map(
          (snap) => SizeProduct.fromSnapshot(snap),
        );
  }

  @override
  Future<void> createSizeProduct(SizeProduct sizeProduct) async {
    await _firebaseFirestore.collection('sizeProducts').doc().set(
          sizeProduct.toMap(),
        );
  }

  @override
  Future<void> updateSizeProduct(SizeProduct sizeProduct) async {
    await _firebaseFirestore
        .collection('sizeProducts')
        .doc(sizeProduct.id)
        .update(
          sizeProduct.toMap(),
        );
  }

  @override
  Future<void> deleteSizeProduct(SizeProduct sizeProduct) async {
    await _firebaseFirestore
        .collection('sizeProducts')
        .doc(sizeProduct.id)
        .delete()
        .then(
          (value) => print('SizeProduct document delete.'),
        );
    ;
  }
}
