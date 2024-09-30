import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tablets/generated/l10n.dart';
import 'package:tablets/src/common_widgets/various/delete_confirmation_dialog.dart';
import 'package:tablets/src/constants/constants.dart' as constants;

// note that <T> is important to allow the use of T as a generic class name
class FromDeleteButton<T> extends ConsumerWidget {
  const FromDeleteButton(
      {super.key,
      required this.deleteMethod,
      required this.itemToBeDeleted,
      required this.message});

  final void Function(BuildContext, T) deleteMethod;
  final T itemToBeDeleted;
  final String message;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return TextButton(
      onPressed: () async {
        bool? confiramtion = await showDeleteConfirmationDialog(
            context: context, message: message);
        if (confiramtion != null && context.mounted) {
          deleteMethod(context, itemToBeDeleted);
        }
      },
      child: Column(
        children: [
          const Icon(Icons.delete, color: Colors.red),
          constants.IconToTextGap.vertical,
          Text(S.of(context).delete),
        ],
      ),
    );
  }
}
