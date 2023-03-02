import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class UserProvider with ChangeNotifier {
  User? _user;

  User? get getUser => _user;

  Future<void> refreshUser() async {
    _user = FirebaseAuth.instance.currentUser;
    notifyListeners();
  }
}
