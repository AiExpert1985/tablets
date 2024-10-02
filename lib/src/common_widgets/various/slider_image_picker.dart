import 'package:cached_network_image/cached_network_image.dart' as caching;
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tablets/src/common_providers/image_picker_provider.dart';
import 'package:tablets/src/utils/utils.dart';

/// this widget shows an image and a button to upload image
/// it takes its image from the pickedImageNotifierProvider
class SliderImagePicker extends ConsumerWidget {
  const SliderImagePicker({super.key, required this.imageUrls, this.showArrows = false});
  final List<String> imageUrls;
  final bool showArrows;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(pickedImageNotifierProvider);
    CustomDebug.tempPrint(' inside slider ${imageUrls.length}');
    CarouselSliderController buttonCarouselController = CarouselSliderController();
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
              height: MediaQuery.of(context).size.height * 0.2, // Adjust the height as needed
              aspectRatio: 16 / 9,
              autoPlay: false,
              autoPlayInterval: const Duration(seconds: 3),
              autoPlayAnimationDuration: const Duration(milliseconds: 800),
              viewportFraction: 0.8,
              initialPage: -1 // go to last added url
              ),
        ),
        if (showArrows)
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                onPressed: () => buttonCarouselController.nextPage(
                    duration: const Duration(milliseconds: 300), curve: Curves.linear),
                icon: const Icon(Icons.arrow_back_ios),
              ),
              IconButton(
                onPressed: () => buttonCarouselController.previousPage(
                    duration: const Duration(milliseconds: 300), curve: Curves.linear),
                icon: const Icon(Icons.arrow_forward_ios),
              ),
            ],
          ),
      ],
    );
  }
}
