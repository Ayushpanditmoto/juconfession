import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:juconfession/components/comment.card.dart';
import 'package:juconfession/services/firestore.methods.dart';
import 'package:shimmer/shimmer.dart';

class Comments extends StatefulWidget {
  final Map<String, dynamic> snaps;
  const Comments({super.key, required this.snaps});

  @override
  State<Comments> createState() => _CommentsState();
}

class _CommentsState extends State<Comments> {
  final TextEditingController commentEditingController =
      TextEditingController();

  User? user = FirebaseAuth.instance.currentUser;

  @override
  void dispose() {
    commentEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Comments'),
        centerTitle: true,
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('confession')
            .doc(widget.snaps['postId'])
            .collection('comments')
            .orderBy('datePublished', descending: true)
            .snapshots(),
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.data.docs.length == 0) {
            return const Center(
              child: Text('No Comments Yet'),
            );
          }

          return ListView.builder(
            reverse: true,
            itemCount: snapshot.data.docs.length,
            itemBuilder: (context, index) {
              return CommentCard(
                snaps: snapshot.data.docs[index].data(),
              );
            },
          );
        },
      ),
      bottomNavigationBar: SafeArea(
        child: Container(
          height: 50,
          margin:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          padding: const EdgeInsets.only(left: 16, right: 8),
          child: Row(
            children: [
              CachedNetworkImage(
                imageUrl: user!.photoURL!,
                imageBuilder: (context, imageProvider) => Container(
                  width: 36.0,
                  height: 36.0,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      image: imageProvider,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                placeholder: (context, url) => ClipRRect(
                  borderRadius: const BorderRadius.all(Radius.circular(40)),
                  child: Shimmer.fromColors(
                    baseColor: Colors.grey[300]!,
                    highlightColor: Colors.grey[100]!,
                    child: Container(
                      width: 40,
                      height: 40,
                      color: Colors.white,
                    ),
                  ),
                ),
                errorWidget: (context, url, error) => const Icon(Icons.error),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 16, right: 8),
                  child: TextField(
                    controller: commentEditingController,
                    decoration: InputDecoration(
                      hintText:
                          'Comment as ${FirebaseAuth.instance.currentUser!.displayName}',
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ),
              InkWell(
                onTap: () async {
                  if (commentEditingController.text.isNotEmpty) {
                    // add comment to database
                    await FirestoreMethods().postComment(
                      widget.snaps['postId'],
                      commentEditingController.text,
                      widget.snaps['uid'],
                      user!.displayName,
                      user!.photoURL,
                    );

                    commentEditingController.clear();
                  }
                },
                child: Container(
                    padding:
                        const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                    child: const Icon(Icons.send)),
              )
            ],
          ),
        ),
      ),
    );
  }
}
