import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:juconfession/services/storage.firebase.dart';
import '../model/user.model.dart';

class AuthMethod {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final StorageMethods _storageMethods = StorageMethods();

  Future<UserModel> getUserDetails() async {
    User? currentUser = _auth.currentUser;
    DocumentSnapshot documentSnapshot =
        await _firestore.collection('users').doc(currentUser!.uid).get();
    return UserModel.fromSnap(documentSnapshot);
  }

  Future<bool> authenticateUser(User user) async {
    QuerySnapshot result = await _firestore
        .collection('users')
        .where('email', isEqualTo: user.email)
        .get();
    final List<DocumentSnapshot> docs = result.docs;
    return docs.isEmpty ? true : false;
  }

  Future<String> signUpUser({
    required String email,
    required String password,
    required String name,
    required String department,
    required Uint8List image,
  }) async {
    String res = "Some Error Occured";
    try {
      if (email.isEmpty ||
          password.isEmpty ||
          name.isEmpty ||
          department.isEmpty ||
          image.isEmpty) {
        res = "Please fill all the fields";
      } else {
        UserCredential userCredential =
            await _auth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );

        String imageUrl = await _storageMethods.uploadImageToStorage(
          'ProfileImages',
          image,
          false,
        );

        User? user = userCredential.user;
        if (user != null) {
          UserModel users = UserModel(
            username: name,
            uid: user.uid,
            email: email,
            photoUrl: imageUrl,
            bio: '',
            followers: [],
            following: [],
            isVerified: false,
            isBanned: false,
          );

          await _firestore
              .collection('users')
              .doc(user.uid)
              .set(users.toJson());
          res = "Signed Up Successfully";
        }
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'invalid-email') {
        res = "The email address is badly formatted.";
      } else if (e.code == 'weak-password') {
        res = "The password provided is too weak.";
      } else if (e.code == 'email-already-in-use') {
        res = "The account already exists for that email.";
      }
    } catch (e) {
      res = e.toString();
      debugPrint(e.toString());
    }
    return res;
  }

  Future<String> loginUser({
    required String email,
    required String password,
  }) async {
    String res = "Some Error Occured";
    try {
      if (email.isEmpty || password.isEmpty) {
        res = "Please fill all the fields";
      } else {
        UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: email,
          password: password,
        );

        User? user = userCredential.user;
        if (user != null) {
          res = "Logged In Successfully";
        }
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'invalid-email') {
        res = "The email address is badly formatted.";
      } else if (e.code == 'user-not-found') {
        res = "No user found for that email.";
      } else if (e.code == 'wrong-password') {
        res = "Wrong password provided for that user.";
      }
    } catch (e) {
      res = e.toString();
      debugPrint(e.toString());
    }
    return res;
  }

  //logout
  Future<void> logout() async {
    await _auth.signOut();
  }
}
