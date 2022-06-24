import '/models/models.dart';

abstract class BaseSizeProductRepository {
  Stream<List<SizeProduct>> getAllSizeProducts();
  Stream<List<SizeProduct>> getSizeProducts(String typeProductId);
  Stream<SizeProduct> getSizeProduct(String sizeProductId);
  Future<void> createSizeProduct(SizeProduct sizeProduct);
  Future<void> updateSizeProduct(SizeProduct sizeProduct, String docId);
}
