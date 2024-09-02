import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tablets/generated/l10n.dart';
import 'package:tablets/src/providers/picked_image_file_provider.dart';

class UserImagePicker extends ConsumerWidget {
  const UserImagePicker({super.key});

  void _pickImage(WidgetRef ref) async {
    final pickedImage = await ImagePicker().pickImage(
        source: ImageSource.camera,
        imageQuality: 50,
        maxWidth: 150); // can use ImageSource.gallery

    // if camera is closed without taking a photo, we just return and do nothing
    if (pickedImage == null) {
      return;
    }
    ref
        .read(pickedImageFileProvider.notifier)
        .update((state) => File(pickedImage.path));
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pickedImageFile = ref.watch(pickedImageFileProvider);
    return Column(
      children: [
        CircleAvatar(
          radius: 40,
          backgroundColor: Colors.grey,
          foregroundImage: pickedImageFile != null? FileImage(pickedImageFile): null,
        ),
        TextButton.icon(
          onPressed: () => _pickImage(ref),
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
