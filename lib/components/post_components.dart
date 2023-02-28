import 'package:flutter/material.dart';
import 'package:flutter_face_pile/flutter_face_pile.dart';
import 'package:juconfession/utils/route.dart';

class Post extends StatelessWidget {
  const Post({super.key});

  @override
  Widget build(BuildContext context) {
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
                        'https://images.unsplash.com/photo-1494790108377-be9c29b29330?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=387&q=80'),
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
                'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nullam auctor, nunc vel ultricies lacinia, nunc nisl aliquam nunc, vel aliquam nunc nisl eu nunc. Nullam auctor, nunc vel ultricies lacinia, nunc nisl aliquam nunc, vel aliquam nunc nisl eu nunc.',
                style: TextStyle(
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 10),
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: const Image(
                  height: 300,
                  image: NetworkImage(
                    'https://images.unsplash.com/photo-1494790108377-be9c29b29330?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=387&q=80',
                  ),
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
              const Divider(
                color: Colors.grey,
              ),
              const SizedBox(height: 5),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: const [
                      SizedBox(width: 10),
                      Icon(
                        Icons.thumb_up,
                        color: Colors.blue,
                      ),
                    ],
                  ),
                  Row(
                    children: const [
                      Icon(
                        Icons.comment,
                        color: Colors.grey,
                      ),
                      SizedBox(width: 5),
                      Text(
                        '20 Comment',
                        style: TextStyle(
                          fontSize: 14,
                        ),
                      ),
                    ],
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
