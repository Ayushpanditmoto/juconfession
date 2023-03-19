import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String name;
  final String email;
  final String uid;
  final String photoUrl;
  final String username;
  final String bio;
  final String batch;
  final List followers;
  final List following;
  final bool isVerified;
  final bool isBanned;
  final String faculty;
  final String gender;
  final String department;
  final List<dynamic> collectionPhotos;
  final DateTime dateofjoin;

  const UserModel({
    required this.name,
    this.username = '',
    required this.uid,
    required this.photoUrl,
    required this.email,
    required this.bio,
    required this.batch,
    required this.followers,
    required this.following,
    this.isVerified = false,
    this.isBanned = false,
    required this.faculty,
    required this.department,
    required this.gender,
    required this.collectionPhotos,
    required this.dateofjoin,
  });

  static UserModel fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return UserModel(
      name: snapshot["name"],
      username: snapshot["username"],
      uid: snapshot["uid"],
      email: snapshot["email"],
      photoUrl: snapshot["photoUrl"],
      bio: snapshot["bio"],
      batch: snapshot["batch"],
      followers: snapshot["followers"],
      following: snapshot["following"],
      isVerified: snapshot["isVerified"],
      isBanned: snapshot["isBanned"],
      faculty: snapshot["faculty"],
      department: snapshot["department"],
      gender: snapshot["gender"],
      collectionPhotos: snapshot["collectionPhotos"],
      dateofjoin: snapshot["dateofjoin"] ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() => {
        "name": name,
        "username": username,
        "uid": uid,
        "email": email,
        "photoUrl": photoUrl,
        "bio": bio,
        "batch": batch,
        "followers": followers,
        "following": following,
        "isVerified": isVerified,
        "isBanned": isBanned,
        "faculty": faculty,
        "department": department,
        "gender": gender,
        "collectionPhotos": collectionPhotos,
        "dateofjoin": dateofjoin,
      };
}
