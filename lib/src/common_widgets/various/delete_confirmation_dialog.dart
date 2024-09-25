import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:tablets/generated/l10n.dart';

/// show a dialog to ask user to confirm the deletion
/// return true if user confirmed the deletion
/// or null if user chooses to cancel or close the dialog by clicking anywhere outside the dialog

Future<bool?> showDeleteConfirmationDialog(
    {required BuildContext context, required String itemName}) {
  return showDialog<bool>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        // title: const Text('Confirm Deletion'),
        content: Text('${S.of(context).alert_before_delete} $itemName ؟'),
        actions: <Widget>[
          TextButton(
            child: Column(
              children: [
                const Icon(Icons.check_circle_outline, color: Colors.green),
                const Gap(6),
                Text(S.of(context).delete),
              ],
            ),
            onPressed: () => Navigator.pop(context, true),
          ),
          TextButton(
            child: Column(
              children: [
                const Icon(Icons.cancel_outlined),
                const Gap(6),
                Text(S.of(context).cancel),
              ],
            ),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      );
    },
  );
}
