import 'package:flutter/material.dart';

class AllUsers extends StatelessWidget {
  const AllUsers({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('All Verified Users'),
        ),
        body: Column(
          children: const [
            ListTile(
              leading: Icon(Icons.person),
              title: Text('User 1'),
              subtitle: Text('User 1 Email'),
              trailing: Icon(
                Icons.verified,
                color: Colors.blue,
              ),
            ),
            ListTile(
              leading: Icon(Icons.person),
              title: Text('User 1'),
              subtitle: Text('User 1 Email'),
              trailing: Icon(
                Icons.verified,
                color: Colors.blue,
              ),
            ),
            ListTile(
              leading: Icon(Icons.person),
              title: Text('User 1'),
              subtitle: Text('User 1 Email'),
              trailing: Icon(
                Icons.verified,
                color: Colors.blue,
              ),
            ),
          ],
        ));
  }
}
