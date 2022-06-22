import 'package:image_picker/image_picker.dart';

import '/models/models.dart';

abstract class BaseProductRepository {
  Stream<List<Product>> getAllProducts();
  Stream<Product> getProduct(String productId);
  Future<String> createProduct(Product product);
  Future<void> updateProduct(Product product, String docId);
  Future<void> updateProductPictures(String imageName, String productId);
}
