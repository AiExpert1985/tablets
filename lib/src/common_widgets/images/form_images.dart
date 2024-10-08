import 'package:cached_network_image/cached_network_image.dart' as caching;
import 'package:flutter/material.dart';

class FormImage extends StatelessWidget {
  const FormImage({required this.url, required this.deletingMethod, super.key});
  final String url;
  final void Function(String) deletingMethod;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        caching.CachedNetworkImage(
          fit: BoxFit.cover,
          height: MediaQuery.of(context).size.height,
          imageUrl: url,
          progressIndicatorBuilder: (context, url, downloadProgress) =>
              CircularProgressIndicator(value: downloadProgress.progress),
          errorWidget: (context, url, error) => const Icon(Icons.error),
        ),
        Positioned(
          top: -7,
          left: -16,
          child: TextButton(
            onPressed: () => deletingMethod(url),
            child: Container(
              padding: const EdgeInsets.all(2),
              color: const Color.fromARGB(31, 172, 171, 171),
              child: const Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.delete,
                    color: Colors.red,
                  ),
                  // Text(S.of(context).delete)
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
