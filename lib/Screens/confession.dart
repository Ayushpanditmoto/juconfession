import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:juconfession/components/post_components.dart';
import 'package:provider/provider.dart';

import '../provider/theme_provider.dart';
import '../services/auth.firebase.dart';

class ConfessionPage extends StatelessWidget {
  const ConfessionPage({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
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
        body: ListView.builder(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.all(8),
          itemCount: 10,
          itemBuilder: (context, index) {
            return const Post();
          },
        ));
  }
}
