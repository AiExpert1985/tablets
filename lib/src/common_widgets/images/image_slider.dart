import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tablets/src/common_providers/image_slider_controller.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:tablets/src/common_widgets/icons/custom_icons.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:tablets/src/constants/constants.dart' as constants;

class ImageSlider extends ConsumerWidget {
  const ImageSlider(this.imageUrls, {super.key});
  final List<String> imageUrls;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final updatedImageUrls = ref.watch(imageSliderNotifierProvider);
    int displayedUrlIndex = updatedImageUrls.length - 1;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CarouselSlider(
          items: updatedImageUrls
              .map(
                (url) => CachedNetworkImage(
                  fit: BoxFit.cover,
                  height: MediaQuery.of(context).size.height,
                  imageUrl: url,
                  progressIndicatorBuilder: (context, url, downloadProgress) =>
                      // Image.memory(kTransparentImage),
                      CircularProgressIndicator(value: downloadProgress.progress),
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                ),
              )
              .toList(),
          options: CarouselOptions(
            onPageChanged: (index, reason) => displayedUrlIndex = index,
            height: 150,
            autoPlay: false,
            initialPage: -1, // initially display last image
          ),
        ),
        constants.FormImageToButtonGap.vertical,
        Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          IconButton(
            onPressed: () => ref.read(imageSliderNotifierProvider.notifier).addImage(),
            icon: const AddImageIcon(),
          ),
          IconButton(
            onPressed: () =>
                ref.read(imageSliderNotifierProvider.notifier).removeImage(displayedUrlIndex),
            icon: const DeleteIcon(),
          )
        ])
      ],
    );
  }
}
