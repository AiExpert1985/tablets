import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tablets/src/common_providers/storage_repository.dart';
import 'package:tablets/src/constants/constants.dart' as constants;
import 'package:tablets/src/utils/utils.dart' as utils;
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart' as caching;
import 'package:carousel_slider/carousel_slider.dart';
import 'package:tablets/src/common_widgets/icons/custom_icons.dart';

class SliderImagePicker extends ConsumerWidget {
  const SliderImagePicker(this.imageUrls, {super.key});
  final List<String> imageUrls;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    int displayedUrlIndex = imageUrls.length - 1;
    final updatedImageUrls = ref.watch(sliderPickedImageNotifierProvider);
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CarouselSlider(
          items: updatedImageUrls
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
            onPageChanged: (index, reason) => displayedUrlIndex = index,
            height: 150,
            autoPlay: false,
            initialPage: -1, // initially display last image
          ),
        ),
        constants.FormImageToButtonGap.vertical,
        Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          IconButton(
            onPressed: () => ref.read(sliderPickedImageNotifierProvider.notifier).addUrl(),
            icon: const AddImageIcon(),
          ),
          IconButton(
            onPressed: () =>
                ref.read(sliderPickedImageNotifierProvider.notifier).removeUrl(displayedUrlIndex),
            icon: const DeleteIcon(),
          )
        ])
      ],
    );
  }
}

class CustomImagePicker {
  static Future<File?> selectImage({uploadingMethod, imageSource = 'gallery'}) async {
    try {
      final selectedImage = await ImagePicker().pickImage(
          source: imageSource == 'camera' ? ImageSource.camera : ImageSource.gallery,
          imageQuality: 100,
          maxWidth: 150); // can use ImageSource.gallery
      if (selectedImage != null) {
        return File(selectedImage.path);
      }
    } catch (e) {
      utils.CustomDebug.print(
          message: 'error while using image picker', stackTrace: StackTrace.current);
      return null;
    }
    return null;
  }
}

class SliderImageNotifier extends StateNotifier<List<String>> {
  SliderImageNotifier(this._imageStorage, super.state);
  final StorageRepository _imageStorage;
  List<String> addedUrls = [];
  List<String> removedUrls = [];

  void initializeUrls(List<String> urls) {
    state = urls;
  }

  void addUrl() async {
    String? newUrl;
    String imageName = utils.StringOperations.generateRandomString();
    File? imageFile = await CustomImagePicker.selectImage();
    if (imageFile != null) {
      newUrl = await _imageStorage.uploadImage(fileName: imageName, file: imageFile);
    }
    if (newUrl != null) {
      state = [...state, newUrl];
      return;
    }
    utils.CustomDebug.print(message: 'error while picking an image');
  }

  void uploadImage() {}

  void removeUrl(int urlIndex) {}

  void deleteImage() {}

  void save() {}
  void exit() {}
}

final sliderPickedImageNotifierProvider =
    StateNotifierProvider<SliderImageNotifier, List<String>>((ref) {
  String defaultImageUrl = constants.DefaultImage.url;
  final imageStorage = ref.read(imageStorageProvider);
  return SliderImageNotifier(imageStorage, [defaultImageUrl]);
});
