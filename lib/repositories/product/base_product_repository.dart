import '../../models/product_model.dart';

abstract class BaseProductRepository {
  Stream<List<Product>> getAllProducts();
  Stream<Product> getProduct(String productId);
  Future<String> createProduct(Product product);
  Future<void> updateProduct(Product product);
  Future<void> deleteProduct(Product product);
  Future<void> updateProductPictures(String imageName, String productId);
}
