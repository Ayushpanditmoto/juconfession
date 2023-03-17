import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class UserComponent extends StatelessWidget {
  final String name;
  final String branch;
  final String year;
  final String imageUrl;
  final bool isAdmin;
  final VoidCallback tap;

  const UserComponent({
    super.key,
    required this.name,
    required this.branch,
    required this.year,
    required this.imageUrl,
    required this.isAdmin,
    required this.tap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: tap,
      child: Card(
        borderOnForeground: true,
        semanticContainer: true,
        child: SizedBox(
          child: Column(
            children: [
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10),
                    ),
                    child: CachedNetworkImage(
                      imageUrl: imageUrl,
                      fit: BoxFit.cover,
                      height: 160,
                      width: double.infinity,
                    ),
                  ),
                  Positioned(
                    top: 0,
                    right: 0,
                    child: Icon(
                      Icons.verified,
                      color: isAdmin ? Colors.yellow : Colors.blue,
                      shadows: const [
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
              Text(
                name,
              ),
              Text(
                branch,
              ),
              Text(
                year,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
