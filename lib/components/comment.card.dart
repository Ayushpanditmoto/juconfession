import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../provider/theme_provider.dart';

class CommentCard extends StatefulWidget {
  final Map<String, dynamic> snaps;
  const CommentCard({super.key, required this.snaps});

  @override
  State<CommentCard> createState() => _CommentCardState();
}

class _CommentCardState extends State<CommentCard> {
  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeProvider>(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: theme.themeMode == ThemeMode.dark
                  ? const Color.fromARGB(255, 28, 28, 28)
                  : Colors.grey.withOpacity(0.3),
              blurRadius: 0,
              spreadRadius: 1,
              offset: const Offset(0, 1),
            ),
          ],
          borderRadius: const BorderRadius.all(Radius.circular(8)),
        ),
        child: Column(
          children: [
            Row(
              children: [
                CachedNetworkImage(
                  imageUrl:
                      "https://res.cloudinary.com/dlsybyzom/image/upload/v1678386168/ProfileImages/mr6hpqbiwhjbsaklno0h.jpg",
                  imageBuilder: (context, imageProvider) => Container(
                    width: 36.0,
                    height: 36.0,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                          image: imageProvider, fit: BoxFit.cover),
                    ),
                  ),
                  placeholder: (context, url) =>
                      const CircularProgressIndicator(),
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: RichText(
                    text: TextSpan(
                      text: widget.snaps['name'],
                      style: TextStyle(
                        color: theme.themeMode == ThemeMode.dark
                            ? Colors.white
                            : Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                      children: [
                        TextSpan(
                          text: " ${widget.snaps['text']}",
                          style: TextStyle(
                            color: theme.themeMode == ThemeMode.dark
                                ? Colors.white
                                : Colors.black,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const Icon(
                  Icons.favorite,
                  color: Colors.grey,
                  size: 18,
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: theme.themeMode == ThemeMode.dark
                        ? const Color.fromARGB(255, 48, 48, 48)
                        : Colors.grey.withOpacity(0.3),
                    borderRadius: const BorderRadius.all(Radius.circular(8)),
                  ),
                  child: Text(
                    DateFormat('dd MMMM yyyy hh:mm')
                        .format(widget.snaps['datePublished'].toDate()),
                  ),
                ),
                const Spacer(),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
