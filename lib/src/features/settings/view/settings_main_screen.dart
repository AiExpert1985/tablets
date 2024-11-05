import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tablets/src/common/widgets/main_frame.dart';
import 'package:tablets/src/features/settings/view/settings_parameters.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return const AppScreenFrame(
      screenBody: Stack(
        children: [
          SettingsParameters(),
        ],
      ),
    );
  }
}
