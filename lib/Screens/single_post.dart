import 'package:flutter/material.dart';

class SinglePost extends StatelessWidget {
  const SinglePost({
    super.key,
  });

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
          children: [
            Padding(
              padding: const EdgeInsets.all(10),
              child: Card(
                key: key,
                child: Column(
                  children: const [
                    ListTile(
                      leading: Icon(Icons.person),
                      title: Text('John Doe'),
                      subtitle: Text('Posted on 12/12/2020'),
                    ),
                    Padding(
                      padding: EdgeInsets.all(10),
                      child: Text(
                          'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed euismod, nunc vel tincidunt lacinia, nunc nisl aliquam'
                          ' massa, nec lacinia nunc nisl euismod nisl. Sed euismod, nunc vel tincidunt lacinia, nunc nisl aliquam massa, nec lacinia nunc nisl euismod nisl.'),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'Comments',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            //DUmmmy comment
          ],
        ),
      ),
    );
  }
}
