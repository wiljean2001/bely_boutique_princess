import '/models/models.dart';

abstract class BaseTypeProductRepository {
  Stream<List<TypeProduct>> getAllTypeProducts();
  Stream<TypeProduct> getTypeProduct(String typeProductId);
  Future<void> createTypeProduct(TypeProduct typeProduct);
  Future<void> updateTypeProduct(TypeProduct typeProduct);
  Future<void> deleteTypeProduct(TypeProduct typeProduct);
}
