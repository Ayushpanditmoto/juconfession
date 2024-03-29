// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:juconfession/services/cloudinary.service.dart';
import 'package:juconfession/services/firestore.methods.dart';

class EditProfile extends StatefulWidget {
  final String uid;
  const EditProfile({super.key, required this.uid});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  File? _image;
  bool isUpdating = false;
  TextEditingController bioController = TextEditingController();
  FirebaseFirestore firestore = FirestoreMethods().firestore;

  @override
  void initState() {
    super.initState();
    firestore.collection('users').doc(widget.uid).get().then((value) {
      bioController.text = value['bio'];
    });
  }

  void selectImage() async {
    final picker = ImagePicker();
    XFile? pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
      ),
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text('Edit Profile'),
            // Update photo

            Stack(
              children: [
                _image != null
                    ? CircleAvatar(
                        radius: 50,
                        backgroundImage: MemoryImage(_image!.readAsBytesSync()),
                        backgroundColor: Colors.transparent,
                      )
                    : StreamBuilder(
                        stream: firestore
                            .collection('users')
                            .doc(widget.uid)
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                          return ClipRRect(
                            borderRadius: BorderRadius.circular(50),
                            child: CachedNetworkImage(
                              imageUrl: snapshot.data!['photoUrl'],
                              height: 100,
                              width: 100,
                              fit: BoxFit.cover,
                              placeholder: (context, url) => const Center(
                                child: CircularProgressIndicator(),
                              ),
                            ),
                          );
                        }),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: IconButton(
                    onPressed: selectImage,
                    icon: const Icon(Icons.add_a_photo),
                  ),
                )
              ],
            ),
            const Text('Update Photo'),
            // Update Bio
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(10),
              ),
              width: 300,
              height: 200,
              child: TextField(
                minLines: 4,
                maxLines: 10,
                controller: bioController,
                decoration: const InputDecoration(
                  hintText: 'Update Bio',
                  border: InputBorder.none,
                ),
              ),
            ),
            // Update Button
            ElevatedButton(
              onPressed: () async {
                if (bioController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Please enter a bio'),
                    ),
                  );
                  return;
                }

                String? imageUrl = _image != null
                    ? await Cloud.uploadImageToStorage(
                        File(_image!.path).readAsBytesSync(),
                        "ProfileImages",
                        widget.uid)
                    : null;

                if (imageUrl == null) {
                  setState(() {
                    isUpdating = true;
                  });
                  firestore.collection('users').doc(widget.uid).update({
                    'bio': bioController.text,
                  });
                } else {
                  firestore.collection('users').doc(widget.uid).update({
                    'bio': bioController.text,
                    'photoUrl': imageUrl,
                  });
                }

                setState(() {
                  isUpdating = false;
                });

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Profile Updated'),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.blue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: isUpdating
                  ? const CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    )
                  : const Text('Update'),
            ),
          ],
        ),
      ),
    );
  }
}
