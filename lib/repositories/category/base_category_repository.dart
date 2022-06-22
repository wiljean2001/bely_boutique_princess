import '/models/models.dart';

abstract class BaseCategoryRepository {
  Stream<List<Category>> getAllCategories();
  Future<String> createCategory(Category category);
  Future<void> updateCategory(Category category, String docId);
  Future<void> updateCategoryPicture(String imageName, String categoryId);
}
