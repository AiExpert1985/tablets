import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tablets/src/common_widgets/main_layout/app_screen_frame.dart';

class PendingBillsScreen extends ConsumerWidget {
  const PendingBillsScreen({super.key});

  void fakeFunction(context) {}

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AppScreenFrame(
      addMethod: fakeFunction,
      screenBody: const Center(
        child: Text('Pending Bills'),
      ),
    );
  }
}
