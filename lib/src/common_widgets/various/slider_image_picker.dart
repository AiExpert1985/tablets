import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tablets/src/features/products/controller/products_controller.dart';

/// this widget shows an image and a button to upload image
/// it takes its image from the pickedImageNotifierProvider
class SliderImagePicker extends ConsumerWidget {
  const SliderImagePicker({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ProductsController productController = ref.watch(productsControllerProvider);
    List<String> imageUrls = productController.tempProduct.iamgesUrl;
    return CarouselSlider(
      items: imageUrls
          .map((url) => Container(
                child: Image.network(url, fit: BoxFit.cover),
                // Add any styling or customization here
              ))
          .toList(),
      options: CarouselOptions(
        height: 200.0, // Adjust the height as needed
        aspectRatio: 16 / 9,
        autoPlay: true,
        autoPlayInterval: const Duration(seconds: 3),
        autoPlayAnimationDuration: const Duration(milliseconds: 800),
        viewportFraction: 0.8,
        // Add more options as needed
      ),
    );
  }
}
 
 
 
 
 
 
 
 
 
 
 
        // TextButton.icon(
        //   onPressed: () => ref
        //       .read(pickedImageNotifierProvider.notifier)
        //       .updatePickedImage(),
        //   icon: const Icon(Icons.image),
        //   label: Text(
        //     S.of(context).add_image,
        //     style: TextStyle(color: Theme.of(context).colorScheme.primary),
        //   ),
        // )