import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class FullScreenImage extends StatelessWidget {
  final String imageUrl;
  final bool delete;
  const FullScreenImage(
      {super.key, required this.imageUrl, this.delete = false});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SizedBox(
            width: double.infinity,
            child: CachedNetworkImage(
              imageUrl: imageUrl,
              imageBuilder: (context, imageProvider) => Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: imageProvider,
                    fit: BoxFit.fitWidth,
                  ),
                ),
              ),
              placeholder: (context, url) => const Center(
                child: CircularProgressIndicator(),
              ),
              errorWidget: (context, url, error) => const Icon(Icons.error),
            ),
          ),
          Positioned(
            top: 40,
            left: 20,
            child: IconButton(
              icon: const Icon(Icons.arrow_back_ios),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
          if (delete)
            Positioned(
              top: 40,
              right: 20,
              child: FutureBuilder(
                future: Firebase.initializeApp(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    return IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () async {
                        final user = FirebaseAuth.instance.currentUser;
                        if (user != null) {
                          final ref = FirebaseFirestore.instance
                              .collection('users')
                              .doc(user.uid)
                              .snapshots();
                          ref.listen((event) {
                            final data = event.data();
                            if (data != null) {
                              final List images = data['collectionPhotos'];

                              images.remove(imageUrl);

                              //update database
                              FirebaseFirestore.instance
                                  .collection('users')
                                  .doc(user.uid)
                                  .update({'collectionPhotos': images});

                              //show snackbar
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Image deleted'),
                                ),
                              );
                            }
                          });
                        }
                      },
                    );
                  }
                  return const SizedBox();
                },
              ),
            ),
        ],
      ),
    );
  }
}
