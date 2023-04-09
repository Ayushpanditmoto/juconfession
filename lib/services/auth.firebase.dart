import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:juconfession/services/firestore.methods.dart';
import '../model/user.model.dart';
import '../utils/save.localdata.dart';
import 'cloudinary.service.dart';

class AuthMethod {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  //getter
  FirebaseAuth get auth => _auth;

  final FirebaseFirestore _firestore = FirestoreMethods().firestore;

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

        //sent verification email
        // User? user = userCredential.user;
        // if (user != null && !user.emailVerified) {
        //   await user.sendEmailVerification();

        //cloudinary
        String? imageLink =
            await Cloud.uploadImageToStorage(image, 'ProfileImages', email);

        User? user = userCredential.user;
        if (user != null && !user.emailVerified) {
          // await user.sendEmailVerification();
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
            isVerified: user.emailVerified ? true : false,
            isBanned: false,
            faculty: faculty,
            department: department,
            gender: gender,
            collectionPhotos: [],
            dateofjoin: DateTime.now(),
          );

          await _firestore
              .collection('users')
              .doc(user.uid)
              .set(users.toJson());
          res = "Verification Email Sent";
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

  //Login Anonymously
  Future<String> loginAnonymously() async {
    String res = "Some Error Occured";
    try {
      UserCredential userCredential = await _auth.signInAnonymously();
      User? user = userCredential.user;
      if (user != null) {
        await SaveLocalData.reload();
        SaveLocalData.saveDataBool('isAnonymous', true);
        res = "Logged In Successfully";
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'operation-not-allowed') {
        res = "Anonymous Sign In Failed";
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
          if (user.emailVerified && await isVerified() == true) {
            res = "Logged In Successfully";
          } else {
            res = "Email not verified";
          }
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

  //check user verified or not from database
  Future<bool> isVerified() async {
    try {
      final DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .get();

      //check if isVerified is available or not
      if (documentSnapshot.data() as dynamic == null) {
        return false;
      }
      return (documentSnapshot.data() as dynamic)['isVerified'] ?? false;
    } catch (e) {
      rethrow;
    }
  }

  //logout
  Future<void> logout() async {
    await SaveLocalData.clearData();
    await SaveLocalData.reload();
    await _auth.signOut();
  }

  //get user data from his uid
  Future<UserModel> getUserData(String uid) async {
    DocumentSnapshot documentSnapshot =
        await _firestore.collection('users').doc(uid).get();
    return UserModel.fromSnap(documentSnapshot);
  }

  Future<bool> isAdmin() async {
    try {
      final DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .get();

      //check if isAdmin is available or not
      if (documentSnapshot.data() as dynamic == null) {
        return false;
      }
      return (documentSnapshot.data() as dynamic)['isAdmin'] ?? false;
    } catch (e) {
      rethrow;
    }
  }

  //isLove
  Future<bool> isLove(String uid) async {
    try {
      final DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .get();

      //check if isLove is available or not
      if (documentSnapshot.data() as dynamic == null) {
        return false;
      }
      return (documentSnapshot.data() as dynamic)['isLove'] ?? false;
    } catch (e) {
      rethrow;
    }
  }

  //adminNote
  Future<String> adminNote() async {
    try {
      final DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .get();

      //check if adminNote is available or not
      if (documentSnapshot.data() as dynamic == null) {
        return '';
      }
      return (documentSnapshot.data() as dynamic)['adminNote'] ?? '';
    } catch (e) {
      rethrow;
    }
  }

  //ban a user
  Future<void> banUser(String uid) async {
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .update({'isBanned': true});
    } catch (e) {
      rethrow;
    }
  }

  //unban a user
  Future<void> unbanUser(String uid) async {
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .update({'isBanned': false});
    } catch (e) {
      rethrow;
    }
  }

  //check if user is banned or not
  Future<bool> isBanned() async {
    try {
      final DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .get();

      //check if isBanned is available or not
      if (documentSnapshot.data() as dynamic == null) {
        return false;
      }
      return (documentSnapshot.data() as dynamic)['isBanned'] ?? false;
    } catch (e) {
      rethrow;
    }
  }
}
