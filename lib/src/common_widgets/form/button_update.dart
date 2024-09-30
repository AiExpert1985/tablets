import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tablets/generated/l10n.dart';
import 'package:tablets/src/constants/constants.dart' as constants;

// note that <T> is important to allow the use of T as a generic class name
class FromUpdateButton<T> extends ConsumerWidget {
  const FromUpdateButton(
      {super.key, required this.updateMethod, required this.itemToBeUpdated});

  final void Function(BuildContext, T) updateMethod;
  final T itemToBeUpdated;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return TextButton(
      onPressed: () => updateMethod(context, itemToBeUpdated),
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
