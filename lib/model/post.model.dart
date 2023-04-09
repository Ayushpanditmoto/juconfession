import 'package:cloud_firestore/cloud_firestore.dart';

class PostModel {
  final String confession;
  final List likes;
  final String postId;
  final DateTime datePublished;
  final String postUrl;
  final String photoUrl;
  final bool isApproved;
  final String gender;
  final String faculty;
  final String department;
  final String year;

  const PostModel({
    required this.confession,
    required this.likes,
    required this.postId,
    required this.datePublished,
    required this.postUrl,
    this.photoUrl = '',
    this.isApproved = false,
    this.gender = '',
    this.faculty = '',
    this.department = '',
    this.year = '',
  });

  static PostModel fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return PostModel(
      confession: snapshot["confession"],
      likes: snapshot["likes"],
      postId: snapshot["postId"],
      datePublished: snapshot["datePublished"],
      postUrl: snapshot['postUrl'],
      photoUrl: snapshot['photoUrl'],
      isApproved: snapshot['isApproved'],
      gender: snapshot['gender'],
      faculty: snapshot['faculty'],
      department: snapshot['department'],
      year: snapshot['year'],
    );
  }

  Map<String, dynamic> toJson() => {
        "confession": confession,
        "likes": likes,
        "postId": postId,
        "datePublished": datePublished,
        'postUrl': postUrl,
        'photoUrl': photoUrl,
        'isApproved': isApproved,
        'gender': gender,
        'faculty': faculty,
        'department': department,
        'year': year,
      };
}
