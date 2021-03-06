import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import '../storage/storage_repository.dart';
import '/models/product_model.dart';
import '/repositories/product/base_product_repository.dart';

class ProductRepository extends BaseProductRepository {
  final FirebaseFirestore _firebaseFirestore;

  ProductRepository({FirebaseFirestore? firebaseFirestore})
      : _firebaseFirestore = firebaseFirestore ?? FirebaseFirestore.instance;

  @override
  Stream<List<Product>> getAllProducts() {
    return _firebaseFirestore
        .collection('products')
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) => Product.fromSnapshot(doc)).toList();
    });
  }

  @override
  Stream<Product> getProduct(String productId) {
    print('Getting products from DB');
    return _firebaseFirestore
        .collection('products')
        .doc(productId)
        .snapshots()
        .map((snap) => Product.fromSnapshot(snap));
  }


  @override
  Future<String> createProduct(Product product) async {
    String id = _firebaseFirestore.collection('products').doc().id;
    await _firebaseFirestore.collection('products').doc(id).set(
          product.toMap(),
        );
    return id;
  }

  @override
  Future<void> updateProduct(Product product) async {
    await _firebaseFirestore.collection('products').doc(product.id).update(
          product.toMap(),
        );
  }

  @override
  Future<void> deleteProduct(Product product) async {
    await _firebaseFirestore.collection('products').doc(product.id).delete();
  }

  @override
  Future<void> updateProductPictures(
    String imageName,
    String productId,
  ) async {
    String downloadUrl =
        await StorageRepository().getDownloadURLProduct(imageName, productId);

    return _firebaseFirestore.collection('products').doc(productId).update({
      'imageUrls': FieldValue.arrayUnion([downloadUrl])
      // 'imageUrls': downloadUrl
    });
  }

  Future<void> updateProductPicturesOnlyUpdate(
    List<String> imageNames,
    String productId,
  ) async {
    return _firebaseFirestore.collection('products').doc(productId).update({
      'imageUrls': imageNames,
      // 'imageUrls': downloadUrl
    });
  }
}
