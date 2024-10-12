import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tablets/src/constants/constants.dart' as constants;
import 'package:tablets/src/utils/utils.dart' as utils;
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart' as caching;
import 'package:carousel_slider/carousel_slider.dart';
import 'package:tablets/src/common_widgets/icons/custom_icons.dart';

/// this widget shows an image and a button to upload image
/// it takes its image from the pickedImageNotifierProvider
class SliderImagePicker extends ConsumerWidget {
  const SliderImagePicker(
      {super.key,
      required this.imageUrls,
      required this.deletingMethod,
      required this.uploadMethod});
  final List<String> imageUrls;
  final void Function(String) deletingMethod;
  final void Function(File?) uploadMethod;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    int currentUrlIndex = imageUrls.length - 1;
    utils.CustomDebug.tempPrint('current index = $currentUrlIndex');
    ref.watch(sliderPickedImageNotifierProvider);
    return Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      CarouselSlider(
        items: imageUrls
            .map(
              (url) => caching.CachedNetworkImage(
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
          onPageChanged: (index, reason) {
            utils.CustomDebug.tempPrint('onpage changed index = $index');
            currentUrlIndex = index;
          },
          height: 150,
          autoPlay: false,
          initialPage: -1, // initially display last image
        ),
      ),
      constants.FormImageToButtonGap.vertical,
      Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        IconButton(
          onPressed: () => ref
              .read(sliderPickedImageNotifierProvider.notifier)
              .updatePickedImage(uploadingMethod: uploadMethod),
          icon: const AddImageIcon(),
        ),
        IconButton(
          onPressed: () => deletingMethod(imageUrls[currentUrlIndex]),
          icon: const DeleteIcon(),
        )
      ])
    ]);
  }
}

class PickedImageNotifier extends StateNotifier<File?> {
  PickedImageNotifier(super.state);
  Future<void> updatePickedImage({uploadingMethod, imageSource = 'gallery'}) async {
    try {
      final pickedImage = await ImagePicker().pickImage(
          source: imageSource == 'camera' ? ImageSource.camera : ImageSource.gallery,
          imageQuality: 100,
          maxWidth: 150); // can use ImageSource.gallery

      // if camera is closed without taking a photo, we just return and do nothing
      if (pickedImage != null) {
        state = File(pickedImage.path);
        uploadingMethod(state);
        state = null;
      }
    } catch (e) {
      utils.CustomDebug.print(
          message: 'error while importing images', stackTrace: StackTrace.current);
    }
  }
}

/// provide File if user used ImagePicker to select an image from the galary or camera
/// otherwise it is null
final sliderPickedImageNotifierProvider = StateNotifierProvider<PickedImageNotifier, File?>((ref) {
  return PickedImageNotifier(null);
});
