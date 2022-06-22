import 'package:image_picker/image_picker.dart';
import '/models/models.dart';

abstract class BaseStorageRepository {
  // users
  Future<void> uploadImage(User user, XFile image);
  Future<String> getDownloadURL(User user, String imageName);
  // products
  Future<void> uploadImageProduct(List<XFile> image, String productid);
  Future<String> getDownloadURLProduct(String imageName, String productid);
  // categories
  Future<void> uploadImageCategory(XFile image, String categoryId);
  Future<String> getDownloadURLCategory(String imageName, String categoryId);
}
