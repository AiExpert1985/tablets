import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tablets/generated/l10n.dart';

/// a button when pressed fetch data from database, load it to notifier
/// and load screen
class ReLoadScreenButton extends ConsumerWidget {
  const ReLoadScreenButton(this.onPress, {super.key});

  final VoidCallback onPress;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Center(
      child: SizedBox(
        height: 80,
        width: 320,
        child: TextButton.icon(
          onPressed: onPress,
          icon: const Icon(Icons.refresh),
          label: Text(
            S.of(context).reload_page,
            style: const TextStyle(fontSize: 20),
          ),
        ),
      ),
    );
  }
}
