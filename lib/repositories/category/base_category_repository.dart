import '/models/models.dart';

abstract class BaseCategoryRepository {
  Stream<List<Category>> getAllCategories();
  Stream<List<Category>> getCategories(String typeProductId);
  Future<String> createCategory(Category category);
  Future<void> updateCategory(Category category);
  Future<void> deleteCategory(Category category);
  Future<void> updateCategoryPicture(String imageName, String categoryId);
}
