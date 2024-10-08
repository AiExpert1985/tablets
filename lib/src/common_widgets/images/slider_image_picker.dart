import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tablets/src/common_providers/image_picker_provider.dart';
import 'package:tablets/src/common_widgets/images/form_images.dart';

/// this widget shows an image and a button to upload image
/// it takes its image from the pickedImageNotifierProvider
class SliderImagePicker extends ConsumerWidget {
  const SliderImagePicker({super.key, required this.imageUrls, required this.deletingMethod});
  final List<String> imageUrls;
  final void Function(String) deletingMethod;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(pickedImageNotifierProvider);
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CarouselSlider(
          items: imageUrls
              .map((url) => FormImage(
                    url: url,
                    deletingMethod: deletingMethod,
                  ))
              .toList(),
          options: CarouselOptions(
              height: MediaQuery.of(context).size.height * 0.2, autoPlay: false, initialPage: -1 // go to last added url
              ),
        ),
      ],
    );
  }
}
