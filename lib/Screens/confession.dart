import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:juconfession/components/post_components.dart';
import 'package:provider/provider.dart';

import '../provider/theme_provider.dart';
import '../services/auth.firebase.dart';

class ConfessionPage extends StatefulWidget {
  const ConfessionPage({super.key});

  @override
  State<ConfessionPage> createState() => _ConfessionPageState();
}

class _ConfessionPageState extends State<ConfessionPage> {
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
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(FirebaseAuth.instance.currentUser!.email!),
              ElevatedButton(
                onPressed: () {
                  AuthMethod().logout();
                },
                child: const Text('Sign Out'),
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

              return FutureBuilder(
                  future: AuthMethod().isAdmin(),
                  builder: (context, isAdminCheck) {
                    if (isAdminCheck.connectionState ==
                        ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }

                    return ListView.builder(
                      physics: const BouncingScrollPhysics(),
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Post(
                            isAdminCheck: isAdminCheck.data!,
                            snaps: snapshot.data!.docs[index].data(),
                            index: snapshot.data!.docs.length - index - 1,
                          ),
                        );
                      },
                    );
                  });
            }),
      ),
    );
  }
}
