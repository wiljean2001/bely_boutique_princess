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
  Future<String> createCategory(Category category) async {
    String id = _firebaseFirestore.collection('categories').doc().id;
    await _firebaseFirestore.collection('categories').doc(id).set(
          category.toMap(),
        );
    return id;
  }

  @override
  Future<void> updateCategory(Category category, String docId) async {
    _firebaseFirestore
        .collection('categories')
        .doc(docId)
        .update(category.toMap())
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
