import 'package:flutter/material.dart';
import 'package:transparent_image/transparent_image.dart';

class CategoryImage extends StatelessWidget {
  const CategoryImage({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
      elevation: 2,
      child: Stack(
        clipBehavior: Clip.hardEdge,
        children: [
          FadeInImage(
            placeholder: MemoryImage(kTransparentImage),
            image: const NetworkImage(
                'https://firebasestorage.googleapis.com/v0/b/tablets-519a0.appspot.com/o/user_iamges%2Fcategories%2Ftablets.png?alt=media&token=acba659a-384d-4f35-864d-cd1397efa73a'),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
                color: Colors.black54,
                padding: const EdgeInsets.all(30),
                child: const Text(
                  'منضفات منزلية',
                  maxLines: 2,
                  textAlign: TextAlign.center,
                  softWrap: true,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                )),
          ),
          // Replace with your image
          Positioned(
            top: 10,
            right: 10,
            child: Row(
              children: [
                IconButton(
                  onPressed: () {
                    // Edit image logic here
                  },
                  icon: const Icon(
                    Icons.edit,
                    size: 40,
                    color: Color.fromARGB(255, 14, 1, 51),
                  ),
                ),
                const SizedBox(width: 10),
                IconButton(
                  onPressed: () {
                    // Delete image logic here
                  },
                  icon: const Icon(
                    Icons.delete,
                    size: 40,
                    color: Colors.red,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
