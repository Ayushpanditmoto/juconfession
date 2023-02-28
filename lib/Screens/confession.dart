import 'package:flutter/material.dart';
import 'package:juconfession/components/post_components.dart';
import 'package:provider/provider.dart';

import '../provider/theme_provider.dart';

class Confession extends StatelessWidget {
  const Confession({super.key});

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
        drawer: const Drawer(),
        body: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.all(15),
            child: Column(
              children: const [
                Post(),
                Post(),
                Post(),
                Post(),
                Post(),
              ],
            )));
  }
}
