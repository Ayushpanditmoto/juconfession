import 'package:flutter/material.dart';
import 'package:flutter_face_pile/flutter_face_pile.dart';
import 'package:juconfession/utils/route.dart';
import 'package:provider/provider.dart';

import '../provider/theme_provider.dart';

class Post extends StatelessWidget {
  const Post({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeProvider>(context);
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, RoutePath.singlePost);
      },
      child: Card(
        key: key,
        elevation: 2,
        child: Container(
          padding: const EdgeInsets.all(10),
          width: MediaQuery.of(context).size.width,
          child: Column(
            children: [
              Row(
                children: [
                  const CircleAvatar(
                    radius: 20,
                    backgroundImage: NetworkImage(
                        // 'https://images.unsplash.com/photo-1494790108377-be9c29b29330?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=387&q=80'),

                        'https://tdqmcwfqgmcuhnhupuja.supabase.co/storage/v1/object/public/example/IMG_20230307_123459_297.jpg'),
                  ),
                  const SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: const [
                          Text(
                            'JU Confession',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          SizedBox(width: 5),
                          Icon(
                            Icons.verified,
                            color: Colors.blue,
                            size: 16,
                          ),
                        ],
                      ),
                      const Text(
                        '2 hours ago',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  Container(
                    width: 50,
                    padding: const EdgeInsets.all(5),
                    constraints: const BoxConstraints(
                      minWidth: 30,
                      minHeight: 30,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: theme.themeMode == ThemeMode.light
                          ? Colors.grey[300]
                          : Colors.grey[800],
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.poll_sharp,
                          size: 12,
                          color: theme.themeMode == ThemeMode.light
                              ? Colors.black
                              : Colors.white,
                        ),
                        const SizedBox(width: 5),
                        Text(
                          "#1",
                          style: TextStyle(
                            fontSize: 12,
                            color: theme.themeMode == ThemeMode.light
                                ? Colors.black
                                : Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: () {
                      showMenu(
                        context: context,
                        position: RelativeRect.fromLTRB(
                          MediaQuery.of(context).size.width,
                          0,
                          0,
                          0,
                        ),
                        items: [
                          const PopupMenuItem(
                            value: 'report',
                            child: Text('Report'),
                          ),
                          const PopupMenuItem(
                            value: 'share',
                            child: Text('Share'),
                          ),
                        ],
                      );
                    },
                    icon: const Icon(Icons.more_vert),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              const Text(
                'Rashumi UG1 , Your beauty makes me fall in love with you a million times,Do you remember our first eye contact? That was the moment when our eyes locked, hearts connected, and I fell for you!,I will go for you if I have to choose between you and the world’s treasures. It is because of my endless love for you in my heart.',
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.normal),
              ),
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: theme.themeMode == ThemeMode.light
                      ? Colors.grey[200]
                      : Colors.grey[800],
                ),
                child: Column(
                  children: [
                    Row(
                      children: const [
                        Text(
                          'Gender: ',
                          style: TextStyle(
                            fontSize: 13,
                          ),
                        ),
                        Text(
                          'Male',
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.blue,
                          ),
                        )
                      ],
                    ),
                    Row(
                      children: const [
                        Text(
                          'Faculty: ',
                          style: TextStyle(
                            fontSize: 13,
                          ),
                        ),
                        Text(
                          'Engineering',
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.blue,
                          ),
                        )
                      ],
                    ),
                    Row(
                      children: const [
                        Text(
                          'Department: ',
                          style: TextStyle(
                            fontSize: 13,
                          ),
                        ),
                        Text(
                          'MME',
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.blue,
                          ),
                        )
                      ],
                    ),
                    Row(
                      children: const [
                        Text(
                          'Year: ',
                          style: TextStyle(
                            fontSize: 13,
                          ),
                        ),
                        Text(
                          '2nd',
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.blue,
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: const Image(
                  height: 300,
                  image: NetworkImage(
                      // 'https://images.unsplash.com/photo-1494790108377-be9c29b29330?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=387&q=80',
                      'https://tdqmcwfqgmcuhnhupuja.supabase.co/storage/v1/object/public/example/IMG_20230307_123459_297.jpg'),
                ),
              ),
              const SizedBox(height: 10),
              Container(
                width: MediaQuery.of(context).size.width,
                alignment: Alignment.centerLeft,
                child: SizedBox(
                  width: 100,
                  child: FacePile(
                    faces: [
                      FaceHolder(
                        id: '1',
                        name: 'user 1',
                        avatar: const NetworkImage(
                          'https://i.pravatar.cc/300?img=1',
                        ),
                      ),
                      FaceHolder(
                        id: '2',
                        name: 'user 2',
                        avatar: const NetworkImage(
                            'https://i.pravatar.cc/300?img=2'),
                      ),
                      FaceHolder(
                        id: '3',
                        name: 'user 3',
                        avatar: const NetworkImage(
                            'https://i.pravatar.cc/300?img=3'),
                      ),
                    ],
                    faceSize: 30,
                    facePercentOverlap: .3,
                    borderColor: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 5),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Icon(
                    Icons.favorite,
                    color: Colors.red,
                    size: 24,
                  ),
                  SizedBox(width: 5),
                  Text(
                    '1.2k',
                    style: TextStyle(
                      fontSize: 12,
                    ),
                  ),
                  Spacer(),
                  Icon(
                    Icons.comment,
                    color: Colors.grey,
                    size: 25,
                  ),
                  SizedBox(width: 5),
                  Text(
                    '1.2k Comment',
                    style: TextStyle(
                      fontSize: 12,
                    ),
                  ),
                  Spacer(),
                  Icon(
                    Icons.share,
                    color: Colors.grey,
                    size: 25,
                  ),
                  SizedBox(width: 5),
                  Text(
                    '1.2k',
                    style: TextStyle(
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 5,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
