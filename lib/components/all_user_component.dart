import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';

class UserComponent extends StatelessWidget {
  final String name;
  final String branch;
  final String year;
  final String imageUrl;
  final bool isAdmin;
  final bool isLove;
  final bool isVerified;
  final String loveMessage;
  final VoidCallback tap;

  const UserComponent({
    super.key,
    required this.name,
    required this.branch,
    required this.year,
    required this.imageUrl,
    required this.isAdmin,
    required this.isLove,
    required this.isVerified,
    required this.tap,
    required this.loveMessage,
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
                      height: MediaQuery.of(context).size.height * 0.22,
                      width: double.infinity,
                    ),
                  ),
                  Positioned(
                    top: 0,
                    right: 0,
                    child: Icon(
                      isLove
                          ? Icons.favorite
                          : isVerified
                              ? Icons.verified
                              : Icons.dangerous,
                      color: isAdmin
                          ? Colors.yellow
                          : isVerified
                              ? Colors.blue
                              : isLove
                                  ? Colors.red
                                  : Colors.grey,
                      shadows: const [
                        Shadow(
                          color: Colors.black,
                          blurRadius: 5,
                          offset: Offset(0, 0),
                        ),
                      ],
                    ),
                  ),
                  isLove
                      ? Positioned(
                          bottom: 5,
                          right: 5,
                          child: Container(
                            width: MediaQuery.of(context).size.width * 0.3,
                            height: MediaQuery.of(context).size.height * 0.04,
                            padding: const EdgeInsets.all(5),
                            decoration: const BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.all(
                                Radius.circular(10),
                              ),
                            ),
                            child: Text(
                              loveMessage,
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        )
                      : Container(),
                ],
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    AutoSizeText(
                      name,
                      minFontSize: 8,
                      maxFontSize: 12,
                      maxLines: 1,
                    ),
                    AutoSizeText(
                      branch,
                      minFontSize: 8,
                      maxFontSize: 12,
                      maxLines: 1,
                    ),
                    AutoSizeText(
                      year,
                      minFontSize: 8,
                      maxFontSize: 12,
                      maxLines: 1,
                    ),
                  ],
                ),
              ),

              //   AutoSizeText(
              //     name,
              //     maxLines: 2,
              //   ),
              //   AutoSizeText(
              //     branch,
              //     maxLines: 2,
              //   ),
              //   AutoSizeText(
              //     year,
              //     maxLines: 2,
              //   ),
            ],
          ),
        ),
      ),
    );
  }
}
