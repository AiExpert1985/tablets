import 'package:cached_network_image/cached_network_image.dart' as caching;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tablets/generated/l10n.dart';
import 'package:tablets/src/common_providers/image_picker.dart';

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
          radius: 70,
          backgroundColor: Colors.grey,
          foregroundImage: pickedImageProvider != null
              ? FileImage(pickedImageProvider)
              : caching.CachedNetworkImageProvider(imageUrl),
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
