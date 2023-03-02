import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';

class StorageMethods {
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  //add image to firebase storage
  Future<String> uploadImageToStorage(
    String childName,
    Uint8List image,
    bool isPost,
  ) async {
    // String path = isPost ? 'posts/' : 'users/';
    Reference ref = _storage.ref(childName).child(_auth.currentUser!.uid);
    UploadTask uploadtask = ref.putData(image);
    TaskSnapshot taskSnapshot = await uploadtask;

    String downloadUrl = await taskSnapshot.ref.getDownloadURL();
    return downloadUrl;
  }
}
