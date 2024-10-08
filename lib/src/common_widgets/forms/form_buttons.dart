import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tablets/src/common_widgets/icons/custom_icons.dart';
import 'package:tablets/src/common_widgets/various/delete_confirmation_dialog.dart';

class FormAddButton extends ConsumerWidget {
  const FormAddButton({super.key, required this.createMethod});

  final void Function(BuildContext) createMethod;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return TextButton(
      onPressed: () => createMethod(context),
      child: const ApproveIcon(),
    );
  }
}

class FormCancelButton extends StatelessWidget {
  const FormCancelButton({super.key});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () => Navigator.of(context).pop(),
      child: const CancelIcon(),
    );
  }
}

// note that <T> is important to allow the use of T as a generic class name
class FromDeleteButton<T> extends ConsumerWidget {
  const FromDeleteButton({super.key, required this.deleteMethod, required this.itemToBeDeleted, required this.message});

  final void Function(BuildContext, T) deleteMethod;
  final T itemToBeDeleted;
  final String message;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return TextButton(
      onPressed: () async {
        bool? confiramtion = await showDeleteConfirmationDialog(context: context, message: message);
        if (confiramtion != null && context.mounted) {
          deleteMethod(context, itemToBeDeleted);
        }
      },
      child: const DeleteIcon(),
    );
  }
}

// note that <T> is important to allow the use of T as a generic class name
class FromUpdateButton<T> extends ConsumerWidget {
  const FromUpdateButton({super.key, required this.updateMethod, required this.itemToBeUpdated});

  final void Function(BuildContext, T) updateMethod;
  final T itemToBeUpdated;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return TextButton(
      onPressed: () => updateMethod(context, itemToBeUpdated),
      child: const ApproveIcon(),
    );
  }
}
