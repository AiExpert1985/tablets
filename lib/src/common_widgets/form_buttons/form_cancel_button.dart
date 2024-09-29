import 'package:flutter/material.dart';
import 'package:tablets/generated/l10n.dart';
import 'package:tablets/src/constants/constants.dart' as constants;

class FormCancelButton extends StatelessWidget {
  const FormCancelButton({super.key});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () => Navigator.of(context).pop(),
      child: Column(
        children: [
          const Icon(Icons.close),
          constants.IconToTextGap.vertical,
          Text(S.of(context).cancel),
        ],
      ),
    );
  }
}
