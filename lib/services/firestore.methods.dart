import 'dart:typed_data';
import 'package:uuid/uuid.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:juconfession/model/post.model.dart';
import 'package:juconfession/services/storage.firebase.dart';

class FirestoreMethods {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String> uploadConfess({
    required String confession,
    Uint8List? image,
    required String gender,
    required String faculty,
    required String department,
    required String year,
    required String uid,
  }) async {
    String retVal = 'error';

    try {
      String photoUrl = await StorageMethods().uploadImageToStorage(
        'confession',
        image!,
        true,
      );

      String postId = const Uuid().v4();

      Post post = Post(
        confession: confession,
        uid: uid,
        likes: [],
        postId: postId,
        datePublished: DateTime.now(),
        postUrl: '',
        photoUrl: photoUrl.isEmpty ? '' : photoUrl,
        gender: gender,
        faculty: faculty,
        department: department,
        year: year,
        isApproved: false,
      );

      await _firestore.collection('confession').doc(postId).set(
            post.toJson(),
          );

      retVal = 'success';
    } catch (e) {
      debugPrint(e.toString());
    }

    return retVal;
  }
}
