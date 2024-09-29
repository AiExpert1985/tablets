import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tablets/generated/l10n.dart';
import 'package:tablets/src/constants/constants.dart' as constants;

class FormCreateButton extends ConsumerWidget {
  const FormCreateButton({super.key, required this.createMethod});

  final void Function(BuildContext) createMethod;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return TextButton(
      onPressed: () => createMethod(context),
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
