import 'package:flutter/material.dart';
import 'package:tablets/generated/l10n.dart';
import 'package:tablets/src/common/values/gaps.dart' as gaps;

/// show a dialog to ask user to confirm the deletion
/// return true if user confirmed the deletion
/// or null if user chooses to cancel or close the dialog by clicking anywhere outside the dialog

Future<bool?> showDeleteConfirmationDialog(
    {required BuildContext context, required String message}) {
  return showDialog<bool>(
    context: context,
    builder: (BuildContext ctx) {
      return AlertDialog(
        // title: const Text('Confirm Deletion'),
        content: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                S.of(ctx).alert_before_delete,
                style: const TextStyle(fontSize: 20),
                textAlign: TextAlign.center,
              ),
              Text(
                '$message ؟',
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
                    gaps.VerticalGap.iconToText,
                    Text(S.of(ctx).delete),
                  ],
                ),
                onPressed: () => Navigator.pop(ctx, true),
              ),
              TextButton(
                child: Column(
                  children: [
                    const Icon(Icons.close),
                    gaps.VerticalGap.iconToText,
                    Text(S.of(ctx).cancel),
                  ],
                ),
                onPressed: () => Navigator.pop(ctx),
              ),
            ],
          ),
        ],
      );
    },
  );
}
