import 'package:flutter/material.dart';
import 'package:juconfession/provider/theme_provider.dart';
import 'package:provider/provider.dart';

class AllUsers extends StatelessWidget {
  const AllUsers({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('All Verified Users'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(50),
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            padding: const EdgeInsets.symmetric(horizontal: 5),
            decoration: BoxDecoration(
              color: theme.themeMode == ThemeMode.dark
                  ? Colors.grey[900]
                  : Colors.grey[200],
              borderRadius: const BorderRadius.all(
                Radius.circular(10),
              ),
            ),
            child: TextFormField(
              decoration: const InputDecoration(
                border: InputBorder.none,
                hintText: 'Search',
                prefixIcon: Icon(Icons.search),
              ),
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(10),
              physics: const BouncingScrollPhysics(),
              itemCount: 100,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.9,
              ),
              itemBuilder: (context, index) {
                return Card(
                  child: SizedBox(
                    child: Column(
                      children: [
                        Stack(
                          children: const [
                            ClipRRect(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(10),
                                topRight: Radius.circular(10),
                              ),
                              child: Image(
                                image: AssetImage(
                                  'assets/girl.jpg',
                                ),
                                fit: BoxFit.cover,
                              ),
                            ),
                            Positioned(
                              top: 0,
                              right: 0,
                              child: Icon(
                                Icons.verified,
                                color: Colors.blue,
                                shadows: [
                                  Shadow(
                                    color: Colors.black,
                                    blurRadius: 5,
                                    offset: Offset(0, 0),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const Text(
                          'Ayush Kumar Pandit',
                        ),
                        const Text(
                          'Metallurgy',
                        ),
                        const Text(
                          '2nd Year',
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
