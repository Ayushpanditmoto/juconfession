// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
// import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:juconfession/provider/theme_provider.dart';
import 'package:juconfession/services/cloudinary.service.dart';
import 'package:juconfession/utils/utils.dart';
import 'package:provider/provider.dart';

import 'edit.profile.dart';
import 'full.screen.image.dart';

class ProfileScreen extends StatefulWidget {
  final String uid;
  const ProfileScreen({super.key, required this.uid});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final User? user = FirebaseAuth.instance.currentUser;
  bool isUploading = false;

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeProvider>(context);
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(widget.uid)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.data == null) {
            return const Center(
              child: Text('No User Found'),
            );
          }
          return Scaffold(
            appBar: AppBar(
              title: Text(
                snapshot.data!['name'],
                style: const TextStyle(
                  fontSize: 17,
                ),
              ),
            ),
            body: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => FullScreenImage(
                                        imageUrl: snapshot.data!['photoUrl'],
                                      )));
                        },
                        child: CachedNetworkImage(
                          imageUrl: snapshot.data!['photoUrl'],
                          imageBuilder: (context, imageProvider) => Container(
                            width: 100,
                            height: 100,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                image: imageProvider,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          placeholder: (context, url) => const Center(
                            child: CircularProgressIndicator(),
                          ),
                          errorWidget: (context, url, error) => const Icon(
                            Icons.error,
                            color: Colors.red,
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 5,
                        ),
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: theme.themeMode == ThemeMode.dark
                                  ? const Color.fromARGB(255, 45, 45, 45)
                                  : Colors.grey.withOpacity(0.3),
                              blurRadius: 0.6,
                              spreadRadius: 0.7,
                              offset: const Offset(0, 1),
                            ),
                          ],
                          color: theme.themeMode == ThemeMode.light
                              ? Colors.white
                              : Colors.black,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Column(
                          children: [
                            Text(
                              snapshot.data!['followers'].length.toString(),
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: theme.themeMode == ThemeMode.light
                                    ? Colors.black
                                    : Colors.white,
                              ),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            const Text(
                              'Followers',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 5,
                        ),
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: theme.themeMode == ThemeMode.dark
                                  ? const Color.fromARGB(255, 45, 45, 45)
                                  : Colors.grey.withOpacity(0.3),
                              blurRadius: 0.6,
                              spreadRadius: 0.7,
                              offset: const Offset(0, 1),
                            ),
                          ],
                          color: theme.themeMode == ThemeMode.light
                              ? Colors.white
                              : Colors.black,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Column(
                          children: [
                            Text(
                              snapshot.data!['following'].length.toString(),
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: theme.themeMode == ThemeMode.light
                                    ? Colors.black
                                    : Colors.white,
                              ),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            const Text(
                              'Following',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 30,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              children: [
                                Text(
                                  snapshot.data!['name'],
                                  style: const TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            //verify icon

                            const Spacer(),

                            ///follow
                            if (user!.uid != widget.uid)
                              snapshot.data!['followers'].contains(user!.uid)
                                  ? TextButton(
                                      onPressed: () {
                                        FirebaseFirestore.instance
                                            .collection('users')
                                            .doc(widget.uid)
                                            .update({
                                          'followers': FieldValue.arrayRemove(
                                              [user!.uid])
                                        });
                                        FirebaseFirestore.instance
                                            .collection('users')
                                            .doc(user!.uid)
                                            .update({
                                          'following': FieldValue.arrayRemove(
                                              [widget.uid])
                                        });
                                      },
                                      style: ButtonStyle(
                                        backgroundColor:
                                            MaterialStateProperty.all(
                                                Colors.red),
                                      ),
                                      child: const Text(
                                        'Unfollow',
                                        style: TextStyle(
                                          color: Colors.white,
                                        ),
                                      ),
                                    )
                                  : TextButton(
                                      onPressed: () {
                                        FirebaseFirestore.instance
                                            .collection('users')
                                            .doc(widget.uid)
                                            .update({
                                          'followers':
                                              FieldValue.arrayUnion([user!.uid])
                                        });
                                        FirebaseFirestore.instance
                                            .collection('users')
                                            .doc(user!.uid)
                                            .update({
                                          'following': FieldValue.arrayUnion(
                                              [widget.uid])
                                        });
                                      },
                                      style: ButtonStyle(
                                        backgroundColor:
                                            MaterialStateProperty.all(
                                                Colors.blue),
                                      ),
                                      child: const Text(
                                        'Follow',
                                        style: TextStyle(
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),

                            ///

                            if (user!.uid != widget.uid)
                              const SizedBox(
                                width: 10,
                              ),
                            if (user!.uid != widget.uid)
                              TextButton(
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        title: const Text('Message'),
                                        content: const Text(
                                            'This feature is not available yet.'),
                                        actions: [
                                          TextButton(
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                            child: const Text('OK'),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                },
                                style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all(
                                      Colors.blueAccent),
                                ),
                                child: const Icon(
                                  Icons.message,
                                  color: Colors.white,
                                ),
                              ),
                            if (user!.uid == widget.uid)

                              //edit profile button
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) => EditProfile(
                                        uid: user!.uid,
                                      ),
                                    ),
                                  );
                                },
                                style: ButtonStyle(
                                  padding: MaterialStateProperty.all(
                                    const EdgeInsets.symmetric(
                                      horizontal: 20,
                                      vertical: 10,
                                    ),
                                  ),
                                  backgroundColor:
                                      MaterialStateProperty.all(Colors.blue),
                                ),
                                child: const Text(
                                  'Edit Profile',
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                          ],
                        ),
                        Text(
                          snapshot.data!['faculty'],
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          snapshot.data!['department'],
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 5,
                          ),
                          decoration: BoxDecoration(
                            color: theme.themeMode == ThemeMode.light
                                ? Colors.grey.withOpacity(0.3)
                                : Colors.grey.withOpacity(0.5),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Text(
                            snapshot.data!['batch'],
                            style: const TextStyle(
                              fontSize: 15,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  //bio data
                  if (snapshot.data!['bio'] != '' &&
                      snapshot.data!['bio'] != null)
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 30,
                        vertical: 10,
                      ),
                      child: Text(
                        snapshot.data!['bio'],
                        style: const TextStyle(
                          fontSize: 15,
                        ),
                      ),
                    ),
                  if (snapshot.data!['bio'] == "" && user!.uid == widget.uid)
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 30,
                        vertical: 10,
                      ),
                      child: const Text(
                        'Make your Profile more attractive by adding a bio',
                        style: TextStyle(
                          fontSize: 15,
                        ),
                      ),
                    ),
                  //upload photos button
                  if (user!.uid == widget.uid)
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 30,
                        vertical: 10,
                      ),
                      child: TextButton(
                        onPressed: () async {
                          final picker = ImagePicker();
                          XFile? pickedFile = await picker.pickImage(
                              source: ImageSource.gallery);
                          if (pickedFile != null) {
                            setState(() {
                              isUploading = true;
                            });
                            String? imageLink =
                                await Cloud.uploadImageToStorage(
                                    File(pickedFile.path).readAsBytesSync(),
                                    'collectionPhotos',
                                    user!.uid);
                            FirebaseFirestore.instance
                                .collection('users')
                                .doc(user!.uid)
                                .update({
                              'collectionPhotos':
                                  FieldValue.arrayUnion([imageLink])
                            });
                            showSnackBar("Photo Uploaded", context);
                            setState(() {
                              isUploading = false;
                            });
                          }
                        },
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(Colors.blue),
                        ),
                        child: isUploading == true
                            ? const CircularProgressIndicator(
                                color: Colors.white,
                              )
                            : const Text(
                                'Upload Photos',
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                      ),
                    ),
                  //photos
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 30,
                      vertical: 10,
                    ),
                    child: StreamBuilder(
                      stream: FirebaseFirestore.instance
                          .collection('users')
                          .doc(widget.uid)
                          .snapshots(),
                      builder: (context, AsyncSnapshot snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        } else if (snapshot.data!['collectionPhotos'].length ==
                            0) {
                          return const Center(
                            child: Text('No Photos Uploaded'),
                          );
                        }
                        return GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: snapshot.data!['collectionPhotos'].length,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            crossAxisSpacing: 5,
                            mainAxisSpacing: 5,
                          ),
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => FullScreenImage(
                                      imageUrl: snapshot
                                          .data!['collectionPhotos'][index],
                                      delete: user!.uid == widget.uid,
                                    ),
                                  ),
                                );
                              },
                              child: CachedNetworkImage(
                                imageUrl: snapshot.data!['collectionPhotos']
                                    [index],
                                fit: BoxFit.cover,
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }
}
