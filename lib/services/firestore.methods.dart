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

  Future<String> likePost(String postId, String uid, List likes) async {
    String res = "Some error occurred";
    try {
      if (likes.contains(uid)) {
        // if the likes list contains the user uid, we need to remove it
        _firestore.collection('confession').doc(postId).update({
          'likes': FieldValue.arrayRemove([uid])
        });
      } else {
        // else we need to add uid to the likes array
        _firestore.collection('confession').doc(postId).update({
          'likes': FieldValue.arrayUnion([uid])
        });
      }
      res = 'success';
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  // Post comment
  Future<String> postComment(String postId, String text, String uid,
      String? name, String? profilePic) async {
    String res = "Some error occurred";
    try {
      if (text.isNotEmpty) {
        // if the likes list contains the user uid, we need to remove it
        String commentId = const Uuid().v1();
        _firestore
            .collection('confession')
            .doc(postId)
            .collection('comments')
            .doc(commentId)
            .set({
          'profilePic': profilePic,
          'name': name,
          'uid': uid,
          'text': text,
          'commentId': commentId,
          'datePublished': DateTime.now(),
        });
        res = 'success';
      } else {
        res = "Please enter text";
      }
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  // Delete Post
  Future<String> deletePost(String postId) async {
    String res = "Some error occurred";
    try {
      await _firestore.collection('confession').doc(postId).delete();
      res = 'success';
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  Future<void> followUser(String uid, String followId) async {
    try {
      DocumentSnapshot snap =
          await _firestore.collection('users').doc(uid).get();
      List following = (snap.data()! as dynamic)['following'];

      if (following.contains(followId)) {
        await _firestore.collection('users').doc(followId).update({
          'followers': FieldValue.arrayRemove([uid])
        });

        await _firestore.collection('users').doc(uid).update({
          'following': FieldValue.arrayRemove([followId])
        });
      } else {
        await _firestore.collection('users').doc(followId).update({
          'followers': FieldValue.arrayUnion([uid])
        });

        await _firestore.collection('users').doc(uid).update({
          'following': FieldValue.arrayUnion([followId])
        });
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }
}
