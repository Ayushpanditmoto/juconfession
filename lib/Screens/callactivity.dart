import 'package:flutter/material.dart';

class CallActivity extends StatelessWidget {
  final String username;
  final String incoming;
  final String createdBy;
  final bool isAvailable;

  const CallActivity(
      {super.key,
      required this.username,
      required this.incoming,
      required this.createdBy,
      required this.isAvailable});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Text(username),
          Text(incoming),
          Text(createdBy),
          Text(isAvailable.toString()),
        ],
      ),
    );
  }
}
