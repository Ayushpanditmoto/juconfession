import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../model/user.model.dart';
import 'cloudinary.service.dart';

class AuthMethod {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

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
    required String gender,
    required String faculty,
    required String startYear,
    required String endYear,
  }) async {
    String res = "Some Error Occured";
    try {
      if (email.isEmpty ||
          password.isEmpty ||
          name.isEmpty ||
          department.isEmpty ||
          image.isEmpty ||
          gender.isEmpty ||
          faculty.isEmpty ||
          startYear.isEmpty ||
          endYear.isEmpty) {
        res = "Please fill all the fields";
      } else {
        UserCredential userCredential =
            await _auth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );

        //cloudinary
        String? imageLink =
            await Cloud.uploadImageToStorage(image, 'ProfileImages');

        //fire base storage
        // String imageUrl = await _storageMethods.uploadImageToStorage(
        //   'ProfileImages',
        //   image,
        //   false,
        // );

        User? user = userCredential.user;
        if (user != null) {
          user.updateDisplayName(name);
          user.updatePhotoURL(imageLink);

          UserModel users = UserModel(
            name: name,
            username: "",
            uid: user.uid,
            email: email,
            batch: "$startYear-$endYear",
            photoUrl: imageLink,
            bio: '',
            followers: [],
            following: [],
            isVerified: false,
            isBanned: false,
            faculty: faculty,
            department: department,
            gender: gender,
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
