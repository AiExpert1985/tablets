import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tablets/src/common_widgets/blank_screen.dart';

class SalesmenLiveLocationScreen extends ConsumerWidget {
  const SalesmenLiveLocationScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return const EmptyScreen(message: 'Salesmen gps live locations');
  }
}
