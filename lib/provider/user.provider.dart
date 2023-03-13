import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:juconfession/model/user.model.dart';

class UserProvider with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

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
}
