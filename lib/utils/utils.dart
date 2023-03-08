import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

pickImage(ImageSource source) async {
  final picker = ImagePicker();
  XFile? pickedFile = await picker.pickImage(source: source);
  if (pickedFile != null) {
    return pickedFile.readAsBytes();
  }
  return null;
}

showSnackBar(String message, BuildContext context) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    content: Text(message),
    duration: const Duration(seconds: 2),
  ));
}
