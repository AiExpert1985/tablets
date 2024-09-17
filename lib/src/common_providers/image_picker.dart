import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tablets/generated/l10n.dart';
import 'package:tablets/src/utils/utils.dart';

///
class GeneralImagePicker extends ConsumerWidget {
  final String imageSourse;
  final String shape;
  const GeneralImagePicker(
      {super.key, this.imageSourse = 'camera', this.shape = 'rectangular'});

  void _pickImage(WidgetRef ref, imageSourse, ctx) async {
    try {
      final pickedImage = await ImagePicker().pickImage(
          source: imageSourse == 'camera'
              ? ImageSource.camera
              : ImageSource.gallery,
          imageQuality: 50,
          maxWidth: 150); // can use ImageSource.gallery

      // if camera is closed without taking a photo, we just return and do nothing
      if (pickedImage == null) {
        return;
      }
      ref.read(pickedImageFileProvider.notifier).update(
            (state) => File(pickedImage.path),
          );
    } catch (e) {
      UserMessages.failure(
          context: ctx, message: 'error while uploading image');
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pickedImageFile = ref.watch(pickedImageFileProvider);
    return Column(
      children: [
        if (shape != 'circular')
          CircleAvatar(
            radius: 40,
            backgroundColor: Colors.grey,
            foregroundImage:
                pickedImageFile != null ? FileImage(pickedImageFile) : null,
          ),
        TextButton.icon(
          onPressed: () => _pickImage(ref, imageSourse, context),
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

final pickedImageFileProvider = StateProvider<File?>((ref) {
  return null;
});
