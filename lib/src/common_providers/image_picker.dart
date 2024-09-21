import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tablets/generated/l10n.dart';
import 'package:tablets/src/constants/constants.dart' as constants;
import 'package:tablets/src/utils/utils.dart' as utils;

/// this widget shows an image and a button to upload image
/// it takes its image from the pickedImageNotifierProvider
class GeneralImagePicker extends ConsumerWidget {
  const GeneralImagePicker({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pickedImageProvider = ref.watch(pickedImageNotifierProvider);
    return Column(
      children: [
        CircleAvatar(
          radius: 60,
          backgroundColor: Colors.grey,
          foregroundImage: pickedImageProvider.pickedImage != null
              ? FileImage(pickedImageProvider.pickedImage!)
              : null,
        ),
        TextButton.icon(
          onPressed: () => ref
              .read(pickedImageNotifierProvider.notifier)
              .updateUserPickedImage(),
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

class UserPickedImage {
  File? pickedImage;
  UserPickedImage(this.pickedImage);
}

class PickedImageNotifier extends StateNotifier<UserPickedImage> {
  PickedImageNotifier(super.state);
  Future<void> updateUserPickedImage({imageSource = 'gallery'}) async {
    try {
      final pickedImage = await ImagePicker().pickImage(
          source: imageSource == 'camera'
              ? ImageSource.camera
              : ImageSource.gallery,
          imageQuality: 50,
          maxWidth: 150); // can use ImageSource.gallery

      // if camera is closed without taking a photo, we just return and do nothing
      if (pickedImage == null) {
        return;
      }
      state = UserPickedImage(File(pickedImage.path));
    } catch (e) {
      utils.CustomDebug.print('error while importing images',
          callerMethod: 'PickedImageNotifier.updateUserPickedImage()');
    }
  }

  // url is the default image
  // file is null
  void reset() {
    state = UserPickedImage(constants.DefaultImage.imageFile);
  }
}

final pickedImageNotifierProvider =
    StateNotifierProvider<PickedImageNotifier, UserPickedImage>((ref) {
  // I didn't find any way to initialize class variable except below outside call
  constants.DefaultImage.initializDefaultImageFile();
  return PickedImageNotifier(UserPickedImage(constants.DefaultImage.imageFile));
});
