import 'package:cached_network_image/cached_network_image.dart' as caching;
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tablets/generated/l10n.dart';
import 'package:tablets/src/common_providers/image_picker_provider.dart';
import 'package:tablets/src/features/products/controller/products_controller.dart';

/// this widget shows an image and a button to upload image
/// it takes its image from the pickedImageNotifierProvider
class SliderImagePicker extends ConsumerWidget {
  const SliderImagePicker({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ProductsController productController =
        ref.watch(productsControllerProvider);
    List<String> imageUrls = productController.tempProduct.iamgesUrl;
    CarouselSliderController buttonCarouselController =
        CarouselSliderController();
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CarouselSlider(
          items: imageUrls
              .map((url) => SizedBox(
                    child: Image(
                      image: caching.CachedNetworkImageProvider(url),
                      fit: BoxFit.cover,
                    ),
                    // Add any styling or customization here
                  ))
              .toList(),
          carouselController: buttonCarouselController,
          options: CarouselOptions(
            height: MediaQuery.of(context).size.height *
                0.2, // Adjust the height as needed
            aspectRatio: 16 / 9,
            autoPlay: false,
            autoPlayInterval: const Duration(seconds: 3),
            autoPlayAnimationDuration: const Duration(milliseconds: 800),
            viewportFraction: 0.8,

            // Add more options as needed
          ),
        ),
        // Row(
        //   mainAxisAlignment: MainAxisAlignment.center,
        //   children: [
        //     IconButton(
        //       onPressed: () => buttonCarouselController.nextPage(
        //           duration: const Duration(milliseconds: 300),
        //           curve: Curves.linear),
        //       icon: const Icon(Icons.arrow_back_ios),
        //     ),
        //     IconButton(
        //       onPressed: () => buttonCarouselController.previousPage(
        //           duration: const Duration(milliseconds: 300),
        //           curve: Curves.linear),
        //       icon: const Icon(Icons.arrow_forward_ios),
        //     ),
        //   ],
        // ),
        TextButton.icon(
          onPressed: () => ref
              .read(pickedImageNotifierProvider.notifier)
              .updatePickedImage(),
          icon: const Icon(Icons.image),
          label: Text(
            S.of(context).add_image,
            style: TextStyle(color: Theme.of(context).colorScheme.primary),
          ),
        )
      ],
    );
  }
}
