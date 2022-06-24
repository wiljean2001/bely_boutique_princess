
import 'package:firebase_auth/firebase_auth.dart' as auth;

import '../../models/user_model.dart';

abstract class BaseDatabaseRepository {
  Stream<User> getUser(String userId);
  Stream<List<User>> getUsers(String role); //String userId, 
  Future<void> createUser(User user);
  Future<void> updateUser(User user);
  Future<void> updateUserPictures(User user, String imageName);
}