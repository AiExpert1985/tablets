import 'package:flutter/material.dart';
import 'package:tablets/generated/l10n.dart';

/// show a dialog to ask user to confirm the deletion
/// return true or false base on user decision
bool showDeleteConfirmationDialog(
    {required BuildContext context, required String itemName}) {
  bool decision = false;
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        // title: const Text('Confirm Deletion'),
        content: Text('${S.of(context).alert_before_delete} $itemName ؟'),
        actions: [
          TextButton(
            child: Text(S.of(context).cancel),
            onPressed: () => Navigator.pop(context),
          ),
          TextButton(
              child: Text(S.of(context).delete),
              onPressed: () {
                decision = true;
                Navigator.pop(context);
              }),
        ],
      );
    },
  );

  return decision;
}
