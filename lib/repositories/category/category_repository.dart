import 'package:cloud_firestore/cloud_firestore.dart';
import '../storage/storage_repository.dart';
import '/models/category_model.dart';
import '/repositories/category/base_category_repository.dart';

class CategoryRepository extends BaseCategoryRepository {
  final FirebaseFirestore _firebaseFirestore;

  CategoryRepository({
    FirebaseFirestore? firebaseFirestore,
  }) : _firebaseFirestore = firebaseFirestore ?? FirebaseFirestore.instance;

  @override
  Stream<List<Category>> getAllCategories() {
    return _firebaseFirestore
        .collection('categories')
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) => Category.fromSnapshot(doc)).toList();
    });
  }

  @override
  Stream<List<Category>> getCategories(String typeProductId) {
    return _firebaseFirestore
        .collection('categories')
        .where('typeProductId', isEqualTo: typeProductId)
        .snapshots()
        .map((snap) {
      return snap.docs.map((doc) => Category.fromSnapshot(doc)).toList();
    });
  }

  @override
  Future<String> createCategory(Category category) async {
    String id = _firebaseFirestore.collection('categories').doc().id;
    await _firebaseFirestore.collection('categories').doc(id).set(
          category.toMap(),
        );
    return id;
  }

  @override
  Future<void> updateCategory(Category category) async {
    _firebaseFirestore
        .collection('categories')
        .doc(category.id)
        .update(category.toMap())
        .then(
          (value) => print('Category document updated.'),
        );
  }
  @override
  Future<void> deleteCategory(Category category) async {
    _firebaseFirestore
        .collection('categories')
        .doc(category.id)
        .delete()
        .then(
          (value) => print('Category document updated.'),
        );
  }

  @override
  Future<void> updateCategoryPicture(
    String imageName,
    String categoryId,
  ) async {
    String downloadUrl = await StorageRepository().getDownloadURLCategory(
      imageName,
      categoryId,
    );

    return _firebaseFirestore.collection('categories').doc(categoryId).update(
      {'imageUrl': downloadUrl},
    );
  }
}
