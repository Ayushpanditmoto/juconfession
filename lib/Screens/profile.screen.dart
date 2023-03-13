import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:juconfession/provider/theme_provider.dart';
import 'package:provider/provider.dart';

import 'full.screen.image.dart';

class ProfileScreen extends StatefulWidget {
  final String uid;
  const ProfileScreen({super.key, required this.uid});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool isFollowing = false;

  final User? user = FirebaseAuth.instance.currentUser;

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
                snapshot.data!['username'],
                style: const TextStyle(
                  fontSize: 17,
                ),
              ),
            ),
            body: Column(
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
                            'Followers',
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
                                snapshot.data!['username'],
                                style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          //verify icon

                          const Spacer(),
                          if (user!.uid != widget.uid)
                            isFollowing
                                ? TextButton(
                                    onPressed: () {
                                      setState(() {
                                        isFollowing = false;
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
                                  )
                                : TextButton(
                                    onPressed: () {
                                      setState(() {
                                        isFollowing = true;
                                      });
                                    },
                                    style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateProperty.all(
                                              Colors.blue),
                                    ),
                                    child: const Icon(
                                      Icons.check,
                                      color: Colors.white,
                                    ),
                                  ),
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
                                // Navigator.of(context).push(
                                //   MaterialPageRoute(
                                //     builder: (context) =>
                                //         const EditProfile(),
                                //   ),
                                // );
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
                      const Text(
                        'B.E MME 2nd Year',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                //bio data
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 30,
                    vertical: 10,
                  ),
                  child: const Text(
                    'I am a Full Stack MERN and Flutter Developer. I am also a Competitive Programmer. I am a 2nd year student of B.E Mechanical Engineering at NIT Hamirpur. I am a self taught developer. I am also a content creator on YouTube. I am also a part of the team of the college magazine. I am also a part of the team of the college website. I am also a part of the team of the college app. I am',
                    style: TextStyle(
                      fontSize: 15,
                    ),
                  ),
                ),
                //upload photos button
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 30,
                    vertical: 10,
                  ),
                  child: TextButton(
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
                      backgroundColor: MaterialStateProperty.all(Colors.blue),
                    ),
                    child: const Text(
                      'Upload Photos',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        });
  }
}
