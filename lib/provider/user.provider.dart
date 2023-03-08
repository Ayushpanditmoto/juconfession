import 'package:flutter/material.dart';
import '../services/auth.firebase.dart';
import '../model/user.model.dart';

class UserProvider with ChangeNotifier {
  UserModel? _user;
  final AuthMethod _authMethods = AuthMethod();

  UserModel get getUser => _user!;

  Future<void> refreshUser() async {
    UserModel user = await _authMethods.getUserDetails();
    _user = user;
    notifyListeners();
  }
}
