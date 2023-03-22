import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:juconfession/Screens/profile.screen.dart';
import 'package:juconfession/components/all_user_component.dart';
import 'package:juconfession/provider/theme_provider.dart';
import 'package:provider/provider.dart';

class AllUsers extends StatefulWidget {
  const AllUsers({super.key});

  @override
  State<AllUsers> createState() => _AllUsersState();
}

class _AllUsersState extends State<AllUsers> {
  final TextEditingController searchController = TextEditingController();

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
              controller: searchController,
              onChanged: (value) {
                setState(() {});
              },
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
            child: StreamBuilder(
                stream: searchController.text.isEmpty
                    ? FirebaseFirestore.instance.collection('users').snapshots()
                    : FirebaseFirestore.instance
                        .collection('users')
                        .where('name',
                            isGreaterThanOrEqualTo: searchController.text)
                        .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  return GridView.builder(
                    padding: const EdgeInsets.all(10),
                    physics: const BouncingScrollPhysics(),
                    itemCount: snapshot.data!.docs.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2, childAspectRatio: 0.7),
                    itemBuilder: (context, index) {
                      return UserComponent(
                        name: snapshot.data!.docs[index].data()['name'],
                        branch: snapshot.data!.docs[index].data()['department'],
                        year: snapshot.data!.docs[index].data()['batch'],
                        imageUrl: snapshot.data!.docs[index].data()['photoUrl'],
                        isAdmin: snapshot.data!.docs[index].data()['isAdmin'] ??
                            false,
                        isLove: snapshot.data!.docs[index].data()['isLove'] ??
                            false,
                        isVerified:
                            snapshot.data!.docs[index].data()['isVerified'] ??
                                false,
                        loveMessage:
                            snapshot.data!.docs[index].data()['loveMessage'] ??
                                '',
                        tap: () {
                          //profile locked dialog for isLove users
                          if (snapshot.data!.docs[index].data()['isLove'] ??
                              false) {
                            if (snapshot.data!.docs[index].data()['isAdmin'] !=
                                null) {
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: const Text('Profile Locked'),
                                  content: const Text(
                                      'Profile is locked for this user.'),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: const Text('OK'),
                                    ),
                                  ],
                                ),
                              );
                              return;
                            }
                          }

                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ProfileScreen(
                                uid: snapshot.data!.docs[index].id,
                              ),
                            ),
                          );
                        },
                      );
                    },
                  );
                }),
          ),
        ],
      ),
    );
  }
}
