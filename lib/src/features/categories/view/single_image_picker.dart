import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tablets/src/common_functions/utils.dart' as utils;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

/// this widget shows an image and a button to upload image
/// it takes its image from the pickedImageNotifierProvider
class SingleImagePicker extends ConsumerWidget {
  final String imageUrl;
  const SingleImagePicker({required this.imageUrl, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pickedImageProvider = ref.watch(pickedImageNotifierProvider);
    return InkWell(
      child: CircleAvatar(
        radius: 70,
        backgroundColor: Colors.white,
        foregroundImage: pickedImageProvider != null
            ? FileImage(pickedImageProvider)
            : CachedNetworkImageProvider(imageUrl),
      ),
      onTap: () => ref.read(pickedImageNotifierProvider.notifier).updatePickedImage(),
    );
  }
}

class PickedImageNotifier extends StateNotifier<File?> {
  PickedImageNotifier(super.state);
  Future<void> updatePickedImage({imageSource = 'gallery'}) async {
    try {
      final pickedImage = await ImagePicker().pickImage(
          source: imageSource == 'camera' ? ImageSource.camera : ImageSource.gallery,
          imageQuality: 50,
          maxWidth: 150); // can use ImageSource.gallery

      // if camera is closed without taking a photo, we just return and do nothing
      if (pickedImage != null) {
        state = File(pickedImage.path);
      }
    } catch (e) {
      utils.errorDebugPrint(
          message: 'error while importing images', stackTrace: StackTrace.current);
    }
  }

  // file is null
  void reset() {
    state = null;
  }
}

/// provide File if user used ImagePicker to select an image from the galary or camera
/// otherwise it is null
final pickedImageNotifierProvider = StateNotifierProvider<PickedImageNotifier, File?>((ref) {
  return PickedImageNotifier(null);
});
