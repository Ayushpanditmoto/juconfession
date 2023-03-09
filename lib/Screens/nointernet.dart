import 'package:flutter/material.dart';

class NoInternet extends StatelessWidget {
  const NoInternet({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('No Internet'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text('No Internet'),
      ),
    );
  }
}
