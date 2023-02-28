import 'package:flutter/material.dart';

import '../components/post_components.dart';

class SinglePost extends StatelessWidget {
  const SinglePost({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Post'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(15),
        child: Column(
          children: const [
            Post(),
            //comment section
          ],
        ),
      ),
    );
  }
}
