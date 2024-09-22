import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tablets/generated/l10n.dart';
import 'package:tablets/src/utils/utils.dart' as utils;

/// this widget shows an image and a button to upload image
/// it takes its image from the pickedImageNotifierProvider
class GeneralImagePicker extends ConsumerWidget {
  final String imageUrl;
  const GeneralImagePicker({required this.imageUrl, super.key});

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
              : NetworkImage(imageUrl),
        ),
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

// I needed two constructors for this class because I have two different ways to create objects
// (1) Using image picker: when user choose a photo to upload in the forms
// (2) using url: when an update form is opened, and shows an exisiting photo or when using deafult image
class UserPickedImage {
  File? pickedImage;
  UserPickedImage({this.pickedImage});
}

class PickedImageNotifier extends StateNotifier<UserPickedImage> {
  PickedImageNotifier(super.state);
  Future<void> updatePickedImage({imageSource = 'gallery'}) async {
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
      state = UserPickedImage(pickedImage: File(pickedImage.path));
    } catch (e) {
      utils.CustomDebug.print(
          message: 'error while importing images',
          stackTrace: StackTrace.current);
    }
  }

  // file is null
  void reset() {
    state = UserPickedImage();
  }
}

/// provide File if user used ImagePicker to select an image from the galary or camera
/// otherwise it is null
final pickedImageNotifierProvider =
    StateNotifierProvider<PickedImageNotifier, UserPickedImage>((ref) {
  return PickedImageNotifier(UserPickedImage());
});
