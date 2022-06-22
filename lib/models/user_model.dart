import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class User extends Equatable {
  final String? id;
  final String name;
  final Timestamp? dateOfBirth;
  // final String gender;
  final String role;
  final String image;
  final List<dynamic> interests;
  final String location;

  // final String bio;
  // final String jobTitle;

  const User({
    this.id,
    required this.name,
    required this.dateOfBirth,
    // required this.gender,
    required this.role,
    required this.image,
    required this.interests,
    required this.location,
    // required this.bio,
    // required this.jobTitle,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        dateOfBirth,
        // gender,
        role,
        image,
        interests,
        location,
        // bio,
        // jobTitle,
      ];

// Base de datos
  static User fromSnapshot(DocumentSnapshot snap) {
    User user = User(
      id: snap.id,
      name: snap['name'],
      dateOfBirth: snap['date_of_birth'],
      // // gender: snap['gender'],
      role: snap['role'],
      image: snap['image'],
      interests: snap['interests'],
      location: snap['location'],
      // bio: snap['bio'],
      // jobTitle: snap['jobTitle'],
    );
    return user;
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'date_of_birth': dateOfBirth,
      // // 'gender': gender,
      'role': role,
      'image': image,
      'interests': interests,
      'location': location,
      // 'bio': bio,
      // 'jobTitle': jobTitle,
    };
  }

  User copyWith({
    String? id,
    String? name,
    Timestamp? dateOfBirth,
    // String? gender,
    String? role,
    String? image,
    List<dynamic>? interests,
    String? location,
    // String? bio,
    // String? jobTitle,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      // // // gender: gender ?? this.gender,
      role: role ?? this.role,
      image: image ?? this.image,
      interests: interests ?? this.interests,
      location: location ?? this.location,
      // bio: bio ?? this.bio,
      // jobTitle: jobTitle ?? this.jobTitle,
    );
  }
}
