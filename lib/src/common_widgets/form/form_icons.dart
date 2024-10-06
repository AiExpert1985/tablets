import 'package:flutter/material.dart';
import 'package:tablets/generated/l10n.dart';
import 'package:tablets/src/constants/constants.dart' as constants;

class ApproveIcon extends StatelessWidget {
  const ApproveIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      const Icon(Icons.check, color: Colors.green),
      constants.IconToTextGap.vertical,
      Text(S.of(context).save)
    ]);
  }
}

class CancelIcon extends StatelessWidget {
  const CancelIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      const Icon(Icons.close),
      constants.IconToTextGap.vertical,
      Text(S.of(context).cancel),
    ]);
  }
}

class DeleteIcon extends StatelessWidget {
  const DeleteIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Icon(Icons.delete, color: Colors.red),
        constants.IconToTextGap.vertical,
        Text(S.of(context).delete),
      ],
    );
  }
}
