// ignore_for_file: use_build_context_synchronously

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_face_pile/flutter_face_pile.dart';
import 'package:juconfession/components/like.animation.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import '../Screens/comments.Screen.dart';
import '../Screens/full.screen.image.dart';
import '../provider/theme_provider.dart';
import 'package:intl/intl.dart';

import '../services/firestore.methods.dart';

class Post extends StatelessWidget {
  final Map<String, dynamic> snaps;
  final int index;
  const Post({super.key, required this.snaps, required this.index});
  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeProvider>(context);
    final user = FirebaseAuth.instance.currentUser;
    return Card(
      key: key,
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(3),
      ),
      child: Container(
        padding: const EdgeInsets.all(10),
        width: MediaQuery.of(context).size.width,
        child: Column(
          children: [
            Row(
              children: [
                CachedNetworkImage(
                  imageUrl: snaps['photoUrl'] != ''
                      ? snaps['photoUrl']
                      : 'https://res.cloudinary.com/dlsybyzom/image/upload/v1678386168/ProfileImages/mr6hpqbiwhjbsaklno0h.jpg',
                  width: 40,
                  height: 40,
                  fit: BoxFit.cover,
                  imageBuilder: (context, imageProvider) => Container(
                    width: 40.0,
                    height: 40.0,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                          image: imageProvider, fit: BoxFit.cover),
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
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: const [
                        Text(
                          'JU Confession',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        SizedBox(width: 5),
                        Icon(
                          Icons.verified,
                          color: Colors.blue,
                          size: 16,
                        ),
                      ],
                    ),
                    Text(
                      DateFormat('dd MMMM yyyy hh:mm')
                          .format(snaps['datePublished'].toDate()),
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                Container(
                  width: 50,
                  padding: const EdgeInsets.all(5),
                  constraints: const BoxConstraints(
                    minWidth: 30,
                    minHeight: 30,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: theme.themeMode == ThemeMode.light
                        ? Colors.grey[300]
                        : Colors.grey[800],
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.poll_sharp,
                        size: 12,
                        color: theme.themeMode == ThemeMode.light
                            ? Colors.black
                            : Colors.white,
                      ),
                      const SizedBox(width: 5),
                      Text(
                        "#${index + 1}",
                        style: TextStyle(
                          fontSize: 12,
                          color: theme.themeMode == ThemeMode.light
                              ? Colors.black
                              : Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                IconButton(
                  onPressed: () {
                    showModalBottomSheet(
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(10),
                        ),
                      ),
                      context: context,
                      builder: (context) {
                        return SizedBox(
                          height: 200,
                          child: Column(
                            children: [
                              ListTile(
                                onTap: () {
                                  showDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        title: const Text('Report Confession'),
                                        content: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            const TextField(
                                              decoration: InputDecoration(
                                                hintText: 'Reason',
                                              ),
                                            ),
                                            const SizedBox(height: 10),
                                            Row(
                                              children: [
                                                const Spacer(),
                                                ElevatedButton(
                                                  onPressed: () {},
                                                  child: const Text('Report'),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  );
                                },
                                leading: const Icon(Icons.report),
                                title: const Text('Report Confession'),
                              ),
                              ListTile(
                                onTap: () async {
                                  Navigator.pop(context);

                                  await FirestoreMethods()
                                      .deletePost(snaps['postId']);
                                },
                                leading: const Icon(Icons.delete),
                                title: const Text('Delete Post (Admin Only)'),
                              ),
                              ListTile(
                                onTap: () {
                                  showDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        title:
                                            const Text('Reply to Confession'),
                                        content: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            const TextField(
                                              decoration: InputDecoration(
                                                hintText: 'Reply',
                                              ),
                                            ),
                                            const SizedBox(height: 10),
                                            Row(
                                              children: [
                                                const Spacer(),
                                                ElevatedButton(
                                                  onPressed: () {},
                                                  child: const Text('Reply'),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  );
                                },
                                leading: const Icon(Icons.reply),
                                title: const Text(
                                    'Reply to Confession Anonymously'),
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                  icon: const Icon(Icons.more_vert),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              snaps['confession'],
              style:
                  const TextStyle(fontSize: 13, fontWeight: FontWeight.normal),
            ),
            const SizedBox(height: 10),
            if (snaps['photoUrl'] != "")
              InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => FullScreenImage(
                        imageUrl: snaps['photoUrl'],
                      ),
                    ),
                  );
                },
                child: CachedNetworkImage(
                  height: 150,
                  imageUrl: snaps['photoUrl'],
                  placeholder: (context, url) => SizedBox(
                    height: 100,
                    child: Shimmer.fromColors(
                      baseColor: Colors.grey[300]!,
                      highlightColor: Colors.grey[100]!,
                      child: Container(
                        width: 150,
                        height: 100,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                ),
              ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: theme.themeMode == ThemeMode.light
                    ? Colors.grey[200]
                    : Colors.grey[800],
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      const Text(
                        'Gender: ',
                        style: TextStyle(
                          fontSize: 13,
                        ),
                      ),
                      Text(
                        snaps['gender'],
                        style: const TextStyle(
                          fontSize: 13,
                          color: Colors.blue,
                        ),
                      )
                    ],
                  ),
                  Row(
                    children: [
                      const Text(
                        'Faculty: ',
                        style: TextStyle(
                          fontSize: 13,
                        ),
                      ),
                      Text(
                        snaps['faculty'],
                        style: const TextStyle(
                          fontSize: 13,
                          color: Colors.blue,
                        ),
                      )
                    ],
                  ),
                  Row(
                    children: [
                      const Text(
                        'Department: ',
                        style: TextStyle(
                          fontSize: 13,
                        ),
                      ),
                      Text(
                        snaps['department'],
                        style: const TextStyle(
                          fontSize: 13,
                          color: Colors.blue,
                        ),
                      )
                    ],
                  ),
                  Row(
                    children: [
                      const Text(
                        'Year: ',
                        style: TextStyle(
                          fontSize: 13,
                        ),
                      ),
                      Text(
                        snaps['year'],
                        style: const TextStyle(
                          fontSize: 13,
                          color: Colors.blue,
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 5),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const SizedBox(width: 10),
                LikeAnimation(
                  isAnimating: snaps['likes']
                      .contains(FirebaseAuth.instance.currentUser!.uid),
                  smallLike: true,
                  child: IconButton(
                    onPressed: () {
                      FirestoreMethods().likePost(
                        snaps['postId'],
                        user.uid,
                        snaps['likes'],
                      );
                    },
                    icon: Icon(
                      Icons.favorite,
                      color: snaps['likes'].contains(user!.uid)
                          ? Colors.red
                          : Colors.grey,
                      size: 24,
                    ),
                  ),
                ),
                const SizedBox(width: 20),
                IconButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Comments(
                            snaps: snaps,
                          ),
                        ),
                      );
                    },
                    icon: const Icon(
                      Icons.comment,
                      color: Colors.grey,
                      size: 25,
                    )),
                const SizedBox(width: 5),
                const Spacer(),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.share,
                    color: Colors.grey,
                    size: 25,
                  ),
                ),
                const SizedBox(width: 5),
                const Text(
                  '1.2k',
                  style: TextStyle(
                    fontSize: 12,
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 5,
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              padding: const EdgeInsets.symmetric(horizontal: 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      SizedBox(
                        width: 100,
                        child: FacePile(
                          faces: [
                            FaceHolder(
                              id: '1',
                              name: 'user 1',
                              avatar: const NetworkImage(
                                'https://i.pravatar.cc/300?img=1',
                              ),
                            ),
                            FaceHolder(
                              id: '2',
                              name: 'user 2',
                              avatar: const NetworkImage(
                                  'https://i.pravatar.cc/300?img=2'),
                            ),
                            FaceHolder(
                              id: '3',
                              name: 'user 3',
                              avatar: const NetworkImage(
                                  'https://i.pravatar.cc/300?img=3'),
                            ),
                          ],
                          faceSize: 30,
                          facePercentOverlap: .3,
                          borderColor: Colors.white,
                        ),
                      ),
                      DefaultTextStyle(
                        style: TextStyle(
                          fontSize: 12,
                          color: theme.themeMode == ThemeMode.light
                              ? Colors.black
                              : Colors.white,
                        ),
                        child: Text('${snaps['likes'].length} Likes'),
                      ),
                    ],
                  )
                ],
              ),
            ),
            const SizedBox(height: 10),
            Container(
              width: MediaQuery.of(context).size.width,
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: 'Vikas ',
                      style: TextStyle(
                        fontSize: 12,
                        color: theme.themeMode == ThemeMode.light
                            ? Colors.black
                            : Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextSpan(
                      text: 'Rashumi meri hai Lawde, Aur mera chota hai',
                      style: TextStyle(
                        fontSize: 12,
                        color: theme.themeMode == ThemeMode.light
                            ? Colors.black
                            : Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 10),
            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Comments(
                      snaps: snaps,
                    ),
                  ),
                );
              },
              child: StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('confession')
                      .doc(snaps['postId'])
                      .collection('comments')
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return const SizedBox();
                    }

                    return Container(
                      width: MediaQuery.of(context).size.width,
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      child: Text(
                        'View all ${snapshot.data!.docs.length} comments',
                        style: const TextStyle(
                          fontSize: 12,
                        ),
                      ),
                    );
                  }),
            ),
          ],
        ),
      ),
    );
  }
}
