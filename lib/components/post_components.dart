import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_face_pile/flutter_face_pile.dart';
import 'package:juconfession/components/comment.card.dart';
import 'package:juconfession/components/like.animation.dart';
import 'package:provider/provider.dart';

import '../Screens/comments.Screen.dart';
import '../provider/theme_provider.dart';
import 'package:intl/intl.dart';

import '../services/firestore.methods.dart';

class Post extends StatelessWidget {
  final Map<String, dynamic> snaps;
  const Post({super.key, required this.snaps});

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeProvider>(context);
    final user = FirebaseAuth.instance.currentUser;
    return Card(
      key: key,
      elevation: 2,
      child: Container(
        padding: const EdgeInsets.all(10),
        width: MediaQuery.of(context).size.width,
        child: Column(
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundImage: NetworkImage(snaps['photoUrl']

                      // 'https://tdqmcwfqgmcuhnhupuja.supabase.co/storage/v1/object/public/example/IMG_20230307_123459_297.jpg',
                      ),
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
                        "#1",
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
                    showMenu(
                      context: context,
                      position: RelativeRect.fromLTRB(
                        MediaQuery.of(context).size.width,
                        0,
                        0,
                        0,
                      ),
                      items: [
                        const PopupMenuItem(
                          value: 'report',
                          child: Text('Report'),
                        ),
                        const PopupMenuItem(
                          value: 'share',
                          child: Text('Share'),
                        ),
                      ],
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
            const SizedBox(height: 10),
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image(
                height: 150,
                image: NetworkImage(snaps['photoUrl']),
              ),
            ),
            const SizedBox(height: 10),
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
              child: Container(
                width: MediaQuery.of(context).size.width,
                padding: const EdgeInsets.symmetric(horizontal: 5),
                child: const Text(
                  'View all 129 comments',
                  style: TextStyle(
                    fontSize: 12,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
