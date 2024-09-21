import 'package:flutter/material.dart';
import 'package:tablets/src/features/settings/categories/model/product_category.dart';
import 'package:transparent_image/transparent_image.dart';

class CategoryItem extends StatelessWidget {
  const CategoryItem(this.category, {super.key});
  final ProductCategory category;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(15),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
      elevation: 2,
      child: Stack(
        clipBehavior: Clip.hardEdge,
        children: [
          FadeInImage(
            // fit: BoxFit.cover,
            placeholder: MemoryImage(kTransparentImage),
            image: NetworkImage(category.imageUrl!),
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
                  category.name,
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
          // Positioned(
          //   top: 10,
          //   right: 10,
          //   child: Row(
          //     children: [
          //       IconButton(
          //         onPressed: () {
          //           // Edit image logic here
          //         },
          //         icon: const Icon(
          //           Icons.edit,
          //           size: 40,
          //           color: Color.fromARGB(255, 14, 1, 51),
          //         ),
          //       ),
          //       const SizedBox(width: 10),
          //       IconButton(
          //         onPressed: () {
          //           // Delete image logic here
          //         },
          //         icon: const Icon(
          //           Icons.delete,
          //           size: 40,
          //           color: Colors.red,
          //         ),
          //       ),
          //     ],
          //   ),
          // ),
        ],
      ),
    );
  }
}
