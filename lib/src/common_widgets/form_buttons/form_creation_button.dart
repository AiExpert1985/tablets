import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tablets/generated/l10n.dart';
import 'package:tablets/src/constants/constants.dart' as constants;

class FormCreateButton extends ConsumerWidget {
  const FormCreateButton({super.key, required this.creationMethod});

  final void Function(BuildContext) creationMethod;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return TextButton(
      onPressed: () => creationMethod(context),
      child: Column(
        children: [
          const Icon(Icons.check, color: Colors.green),
          constants.IconToTextGap.vertical,
          Text(S.of(context).save),
        ],
      ),
    );
  }
}
