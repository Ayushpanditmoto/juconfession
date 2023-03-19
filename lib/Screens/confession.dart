import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:juconfession/components/post_components.dart';
import 'package:provider/provider.dart';

import '../provider/theme_provider.dart';

class ConfessionPage extends StatefulWidget {
  const ConfessionPage({super.key});

  @override
  State<ConfessionPage> createState() => _ConfessionPageState();
}

class _ConfessionPageState extends State<ConfessionPage> {
  bool isAdminCheck = false;
  @override
  void initState() {
    super.initState();
    isAdmin();
  }

  void isAdmin() async {
    try {
      final DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .get();

      //check if isAdmin is available or not
      if (documentSnapshot.data() as dynamic == null) {
        isAdminCheck = false;
        return;
      }
      isAdminCheck = (documentSnapshot.data() as dynamic)['isAdmin'] ?? false;
    } catch (e) {
      rethrow;
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    // final user = Provider.of<UserProvider>(context).getCurrentUser();

    return Scaffold(
      appBar: AppBar(
        title: const Text('JU Confession'),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              if (themeProvider.themeMode == ThemeMode.light) {
                themeProvider.setThemeMode(ThemeMode.dark);
              } else {
                themeProvider.setThemeMode(ThemeMode.light);
              }
            },
            icon: themeProvider.themeMode == ThemeMode.light
                ? const Icon(Icons.dark_mode)
                : const Icon(Icons.light_mode),
          ),
          //notification
          IconButton(
            onPressed: () {
              //development stage dialog
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: const Text('Notification'),
                    content: const Text('This feature is under development'),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text('Ok'),
                      ),
                    ],
                  );
                },
              );
            },
            icon: const Icon(Icons.notifications),
          ),
        ],
      ),
      drawer: Drawer(
        child: SafeArea(
          child: Stack(
            children: [
              Column(
                children: [
                  Container(
                    width: double.infinity,
                    height: 170,
                    padding: const EdgeInsets.only(top: 15.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          margin: const EdgeInsets.only(bottom: 10),
                          height: 10,
                        ),
                        Text(
                          "JU Confession",
                          style: TextStyle(
                            color: themeProvider.themeMode == ThemeMode.light
                                ? Colors.black
                                : Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 35,
                          ),
                        ),
                        Text(
                          "Confess your heart ❤",
                          style: TextStyle(
                            color: themeProvider.themeMode == ThemeMode.light
                                ? Colors.black
                                : Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                        ),
                        //show email
                      ],
                    ),
                  ),
                  Text(
                    FirebaseAuth.instance.currentUser!.email!,
                    style: TextStyle(
                      color: themeProvider.themeMode == ThemeMode.light
                          ? Colors.black
                          : Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  // Rate Us
                  TextButton(
                    onPressed: () {
                      //development stage dialog
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: const Text('Rate Us'),
                            content:
                                const Text('This feature is under development'),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: const Text('Ok'),
                              ),
                            ],
                          );
                        },
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: themeProvider.themeMode == ThemeMode.light
                            ? Colors.white
                            : Colors.black,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Text(
                        'Rate Us',
                        style: TextStyle(
                          color: Colors.teal,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  //Logout
                  TextButton(
                    onPressed: () {
                      FirebaseAuth.instance.signOut();
                    },
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: themeProvider.themeMode == ThemeMode.light
                            ? Colors.white
                            : Colors.black,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Text(
                        'Logout',
                        style: TextStyle(
                          color: Colors.teal,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              // App Creator
              Positioned(
                bottom: MediaQuery.of(context).size.height * 0.03,
                left: MediaQuery.of(context).size.width * 0.05,
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.7,
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    // color: const Color.fromARGB(255, 2, 177, 119),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    // mainAxisAlignment: MainAxisAlignment.center,
                    // crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'Made with ❤ ',
                        style: TextStyle(
                          color: themeProvider.themeMode == ThemeMode.light
                              ? Colors.black
                              : Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Ayush Pandit',
                        style: TextStyle(
                          color: themeProvider.themeMode == ThemeMode.light
                              ? Colors.black
                              : Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'JU MME 2021-2025',
                        style: TextStyle(
                          color: themeProvider.themeMode == ThemeMode.light
                              ? Colors.black
                              : Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await Future.delayed(const Duration(seconds: 1));
        },
        child: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('confession')
                .orderBy('datePublished', descending: true)
                .snapshots(),
            builder: (context,
                AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else if (snapshot.hasError) {
                return const Center(
                  child: Text('Something went wrong'),
                );
              } else if (snapshot.data!.docs.isEmpty) {
                return const Center(
                  child: Text('No Confession'),
                );
              }

              return Column(
                children: [
                  //message to admin
                  // if (isAdminCheck = false)
                  //   const Padding(
                  //     padding: EdgeInsets.all(8.0),
                  //     child: Text(
                  //       'You are an admin. You can delete any post',
                  //       style: TextStyle(
                  //         color: Colors.red,
                  //         fontWeight: FontWeight.bold,
                  //       ),
                  //     ),
                  //   ),
                  //list of posts
                  StreamBuilder(
                      stream: FirebaseFirestore.instance
                          .collection('users')
                          .doc('W1W8Jtr5JcT7Loww1kUjqpDO6yh2')
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        if (snapshot.data!.data()!['adminNote'] == null ||
                            snapshot.data!.data()!['adminNote'] == '') {
                          return const SizedBox();
                        }

                        return Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Admin Note',
                                  style: TextStyle(
                                    color: Colors.red,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(snapshot.data!.data()!['adminNote']),
                              ],
                            ),
                          ),
                        );
                      }),
                  Expanded(
                    child: ListView.builder(
                      physics: const BouncingScrollPhysics(),
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Post(
                            isAdminCheck: isAdminCheck,
                            snaps: snapshot.data!.docs[index].data(),
                            index: snapshot.data!.docs.length - index - 1,
                          ),
                        );
                      },
                    ),
                  ),
                ],
              );
            }),
      ),
    );
  }
}
