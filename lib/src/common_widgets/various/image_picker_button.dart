import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tablets/src/utils/utils.dart' as utils;
import 'package:flutter/material.dart';
import 'package:tablets/generated/l10n.dart';

class ImagePickerButton extends ConsumerWidget {
  const ImagePickerButton({super.key, required this.uploadingMethod});
  final void Function(File?) uploadingMethod;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return TextButton.icon(
      onPressed: () {
        ref
            .read(pickedImageNotifierProvider.notifier)
            .updatePickedImage(uploadingMethod: uploadingMethod);
      },
      icon: const Icon(Icons.image),
      label: Text(
        S.of(context).add_image,
        style: TextStyle(color: Theme.of(context).colorScheme.primary),
      ),
    );
  }
}

class PickedImageNotifier extends StateNotifier<File?> {
  PickedImageNotifier(super.state);
  Future<void> updatePickedImage({uploadingMethod, imageSource = 'gallery'}) async {
    try {
      final pickedImage = await ImagePicker().pickImage(
          source: imageSource == 'camera' ? ImageSource.camera : ImageSource.gallery,
          imageQuality: 50,
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
final pickedImageNotifierProvider = StateNotifierProvider<PickedImageNotifier, File?>((ref) {
  return PickedImageNotifier(null);
});
