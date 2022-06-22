import 'dart:io';
import 'package:bely_boutique_princess/repositories/storage/base_storage_repository.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

import '/models/models.dart';
import '/repositories/repositories.dart';

class StorageRepository extends BaseStorageRepository {
  final firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;

  @override
  Future<void> uploadImage(User user, XFile image) async {
    try {
      await storage
          .ref('${user.id}/${image.name}')
          .putFile(
            File(image.path),
          )
          .then(
            (p0) => DatabaseRepository().updateUserPictures(
              user,
              image.name,
            ),
          );
    } catch (err) {
      print(err);
    }
  }

  @override
  Future<String> getDownloadURL(User user, String imageName) async {
    String downloadURL =
        await storage.ref('${user.id}/$imageName').getDownloadURL();
    return downloadURL;
  }

  @override
  Future<void> uploadImageProduct(List<XFile> images, String productid) async {
    try {
      for (var image in images) {
        print("Imagenes - uploadImageProduct:");
        print(image.name);
        print(image.path);
        await storage
            .ref('product/$productid/${image.name}')
            .putFile(File(image.path))
            .then(
              (p0) => ProductRepository().updateProductPictures(
                image.name,
                productid,
              ),
            );
      }
    } catch (err) {
      print(err);
    }
  }

  @override
  Future<String> getDownloadURLProduct(
      String imageName, String productid) async {
    String downloadURL =
        await storage.ref('product/$productid/$imageName').getDownloadURL();
    print('URL Image - getDownloadURLProduct:');
    print(downloadURL);
    return downloadURL;
  }

  @override
  Future<String> getDownloadURLCategory(
      String imageName, String categoryId) async {
    String downloadURL =
        await storage.ref('categories/$categoryId/$imageName').getDownloadURL();
    return downloadURL;
  }

  @override
  Future<void> uploadImageCategory(XFile image, String categoryId) async {
    try {
      await storage
          .ref('categories/$categoryId/${image.name}')
          .putFile(File(image.path))
          .then(
            (p0) => CategoryRepository().updateCategoryPicture(
              image.name,
              categoryId,
            ),
          );
    } catch (err) {
      print(err);
    }
  }
}
