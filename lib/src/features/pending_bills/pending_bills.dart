import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tablets/src/common_widgets/various/blank_screen.dart';

class PendingBillsScreen extends ConsumerWidget {
  const PendingBillsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return const EmptyScreen(message: 'Pending Bills');
  }
}
