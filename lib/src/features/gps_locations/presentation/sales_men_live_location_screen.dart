import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tablets/src/common/widgets/main_frame.dart';

class SalesmenLiveLocationScreen extends ConsumerWidget {
  const SalesmenLiveLocationScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return const AppScreenFrame(
      screenBody: Center(
        child: Text('Salesmen Bills'),
      ),
    );
  }
}
