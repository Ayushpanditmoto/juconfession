import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:juconfession/Screens/all_user.dart';
import 'package:juconfession/Screens/confession.dart';
import 'package:juconfession/Screens/profile.screen.dart';
import 'package:juconfession/Screens/trending.dart';
import 'package:juconfession/Screens/video_chat.dart';

import 'addconfess.screen.dart';

class Confession extends StatefulWidget {
  const Confession({super.key});

  @override
  State<Confession> createState() => _ConfessionState();
}

class _ConfessionState extends State<Confession> {
  String name = '';
  int _page = 0;
  late PageController _pageController;

  @override
  void initState() {
    super.initState();

    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void navigationTapped(int page) {
    _pageController.jumpToPage(page);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomAppBar(
        height: 60,
        elevation: 5,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              highlightColor: Colors.transparent,
              splashColor: Colors.transparent,
              onPressed: () {
                setState(() {
                  _page = 0;
                  navigationTapped(_page);
                });
              },
              icon: Icon(
                Icons.home,
                color: _page == 0 ? Colors.blue : Colors.grey,
              ),
            ),
            IconButton(
              highlightColor: Colors.transparent,
              splashColor: Colors.transparent,
              onPressed: () {
                setState(() {
                  _page = 1;
                  navigationTapped(_page);
                });
              },
              icon: Icon(
                Icons.trending_up_sharp,
                color: _page == 1 ? Colors.blue : Colors.grey,
              ),
            ),
            IconButton(
              highlightColor: Colors.transparent,
              splashColor: Colors.transparent,
              onPressed: () {
                setState(() {
                  _page = 2;
                  navigationTapped(_page);
                });
              },
              icon: Icon(
                Icons.photo_camera_front_sharp,
                color: _page == 2 ? Colors.blue : Colors.grey,
              ),
            ),
            IconButton(
              highlightColor: Colors.transparent,
              splashColor: Colors.transparent,
              onPressed: () {
                setState(() {
                  _page = 3;
                  navigationTapped(_page);
                });
              },
              icon: Icon(
                Icons.add,
                color: _page == 3 ? Colors.blue : Colors.grey,
              ),
            ),
            IconButton(
              highlightColor: Colors.transparent,
              splashColor: Colors.transparent,
              onPressed: () {
                setState(() {
                  // _page = 3;
                  // navigationTapped(_page);

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const VideoChat(),
                    ),
                  );
                });
              },
              icon: Icon(
                Icons.video_chat_outlined,
                color: _page == 5 ? Colors.blue : Colors.grey,
              ),
            ),
            IconButton(
              highlightColor: Colors.transparent,
              splashColor: Colors.transparent,
              onPressed: () {
                setState(() {
                  _page = 6;
                  navigationTapped(_page);
                });
              },
              icon: Icon(
                Icons.person,
                color: _page == 6 ? Colors.blue : Colors.grey,
              ),
            ),
          ],
        ),
      ),
      body: PageView(
        physics: const NeverScrollableScrollPhysics(),
        controller: _pageController,
        onPageChanged: navigationTapped,
        children: [
          const ConfessionPage(),
          const TrendingPage(),
          const AllUsers(),
          const AddConfession(),
          const VideoChat(),
          ProfileScreen(
            uid: FirebaseAuth.instance.currentUser!.uid,
          ),
        ],
      ),
    );
  }
}
