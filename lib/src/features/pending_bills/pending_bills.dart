import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tablets/src/common_widgets/main_layout/main_screen_frame.dart';

class PendingBillsScreen extends ConsumerWidget {
  const PendingBillsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return const AppScreenFrame(
      screenBody: Center(
        child: Text('Pending Bills'),
      ),
    );
  }
}
