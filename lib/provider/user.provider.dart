import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:juconfession/model/user.model.dart';

class UserProvider with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  // final FirebaseAuth _auth = FirebaseAuth.instance;

  User? _user;

  User? get getUser => _user;

  void setUser(User? user) {
    _user = user;
    notifyListeners();
  }

  Future<UserModel> getUserDetails(String uid) async {
    try {
      final DocumentSnapshot documentSnapshot =
          await _firestore.collection('users').doc(uid).get();

      return UserModel.fromSnap(documentSnapshot);
    } catch (e) {
      rethrow;
    }
  }

  //check user is admin or not
  Future<bool> isAdmin(String uid) async {
    try {
      final DocumentSnapshot documentSnapshot =
          await _firestore.collection('users').doc(uid).get();

      return (documentSnapshot.data() as dynamic)['isAdmin'];
    } catch (e) {
      rethrow;
    }
  }

  //like a confession
  Future<String> likePost(String postId, String uid, List likes) async {
    String res = "Some error occurred";
    try {
      if (likes.contains(uid)) {
        // if the likes list contains the user uid, we need to remove it
        _firestore.collection('confession').doc(postId).update({
          'likes': FieldValue.arrayRemove([uid])
        });
        notifyListeners();
      } else {
        // else we need to add uid to the likes array
        _firestore.collection('confession').doc(postId).update({
          'likes': FieldValue.arrayUnion([uid])
        });
        notifyListeners();
      }

      res = 'success';
      notifyListeners();
    } catch (err) {
      res = err.toString();
      notifyListeners();
    }
    return res;
  }
}
