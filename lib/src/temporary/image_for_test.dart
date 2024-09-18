import 'package:flutter/material.dart';
import 'package:transparent_image/transparent_image.dart';

class CategoryItem extends StatelessWidget {
  const CategoryItem({super.key, required this.imageUrl, required this.title});
  final String imageUrl;
  final String title;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      hoverColor: const Color.fromARGB(255, 173, 170, 170),
      child: Card(
        margin: const EdgeInsets.all(15),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
        elevation: 2,
        child: Stack(
          clipBehavior: Clip.hardEdge,
          children: [
            FadeInImage(
              // fit: BoxFit.cover,
              placeholder: MemoryImage(kTransparentImage),
              image: NetworkImage(imageUrl),
              fit: BoxFit.cover,
              height: 150,
              width: double.infinity,
            ),

            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                  height: MediaQuery.of(context).size.height * 0.07,
                  color: Colors.black54,
                  padding: const EdgeInsets.all(5),
                  child: Text(
                    title,
                    maxLines: 2,
                    textAlign: TextAlign.center,
                    softWrap: true,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
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
      ),
    );
  }
}
