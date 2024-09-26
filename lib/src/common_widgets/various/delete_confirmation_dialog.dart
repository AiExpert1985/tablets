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
        content: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                S.of(context).alert_before_delete,
                style: const TextStyle(fontSize: 20),
                textAlign: TextAlign.center,
              ),
              Text(
                '$itemName ؟',
                style: const TextStyle(fontSize: 20),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
        actions: <Widget>[
          OverflowBar(
            alignment: MainAxisAlignment.center,
            children: [
              TextButton(
                child: Column(
                  children: [
                    const Icon(Icons.check, color: Colors.red),
                    const Gap(6),
                    Text(S.of(context).delete),
                  ],
                ),
                onPressed: () => Navigator.pop(context, true),
              ),
              TextButton(
                child: Column(
                  children: [
                    const Icon(Icons.close),
                    const Gap(6),
                    Text(S.of(context).cancel),
                  ],
                ),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
        ],
      );
    },
  );
}
