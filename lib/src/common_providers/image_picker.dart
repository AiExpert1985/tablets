import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

import 'package:tablets/generated/l10n.dart';
import 'package:tablets/src/constants/constants.dart' as constants;
import 'package:tablets/src/utils/utils.dart' as utils;

/// this widget shows an imge and a button to upload image
/// it takes its image from the pickedImageNotifierProvider
/// in case pickedImageNotifierProvider is null, it shows a default image
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
          foregroundImage: pickedImageProvider.pickedImage == null
              ? NetworkImage(pickedImageProvider.placeHolderImageUrl)
              : FileImage(pickedImageProvider.pickedImage!),
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
  UserPickedImage(
      {this.pickedImage,
      this.placeHolderImageUrl = constants.DefaultImageUrl.defaultImageUrl});
  File? pickedImage;
  String placeHolderImageUrl;

  UserPickedImage copyWith({
    File? pickedImage,
    String? placeHolderImageUrl,
  }) {
    return UserPickedImage(
      pickedImage: pickedImage ?? this.pickedImage,
      placeHolderImageUrl: placeHolderImageUrl ?? this.placeHolderImageUrl,
    );
  }
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
      state = state.copyWith(pickedImage: File(pickedImage.path));
    } catch (e) {
      utils.CustomDebug.print(
          message: 'error while importing images',
          callerName: 'PickedImageNotifier.updateUserPickedImage()');
    }
  }

  void updatePlaceHolderImageUrl(url) {
    state = state.copyWith(placeHolderImageUrl: url);
  }

  // url is the default image
  // file is null
  void reset() {
    state = UserPickedImage();
  }
}

final pickedImageNotifierProvider =
    StateNotifierProvider<PickedImageNotifier, UserPickedImage>(
  (ref) => PickedImageNotifier(UserPickedImage()),
);
