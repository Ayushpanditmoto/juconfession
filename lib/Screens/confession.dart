// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:juconfession/components/post_components.dart';
import 'package:juconfession/constant.dart';
import 'package:juconfession/services/auth.firebase.dart';
import 'package:juconfession/utils/route.dart';
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

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  FirebaseAuth auth = FirebaseAuth.instance;

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

    return Scaffold(
      appBar: AppBar(
        title: Text(appName),
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
                          appName,
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
                    FirebaseAuth.instance.currentUser!.email ??
                        FirebaseAuth.instance.currentUser!.uid,
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
                      AuthMethod().logout();
                      Navigator.pushReplacementNamed(context, RoutePath.login);
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
