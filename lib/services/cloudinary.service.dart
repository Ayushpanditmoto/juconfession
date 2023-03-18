import 'dart:typed_data';

import 'package:cloudinary/cloudinary.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';

class Cloud {
  static const String apiKey = '986189848758268';
  static const String apiSecret = 'MAom7ogzFfQuloRUKAjcnnYCUXY';
  static const String cloudName = 'dlsybyzom';

  static Cloudinary cloudinary = Cloudinary.signedConfig(
    apiKey: apiKey,
    apiSecret: apiSecret,
    cloudName: cloudName,
  );

  static Future<String> uploadImageToStorage(
      Uint8List image, String folder, String uid) async {
    try {
      var compressedImage = await FlutterImageCompress.compressWithList(
        image,
        minWidth: 500,
        minHeight: 500,
        quality: 90,
      );
      var res = await cloudinary.upload(
        fileBytes: compressedImage,
        folder: "$folder/$uid",
        resourceType: CloudinaryResourceType.image,
        progressCallback: (count, total) {
          debugPrint('Progress: $count/$total');
        },
      );
      return res.secureUrl ?? "";
    } catch (e) {
      debugPrint(e.toString());
      return "";
    }
  }
}
