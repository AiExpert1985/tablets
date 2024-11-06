import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tablets/src/common/widgets/main_frame.dart';
import 'package:tablets/src/features/regions/view/region_floating_buttons.dart';
import 'package:tablets/src/features/regions/view/region_items_grid.dart';

class RegionsScreen extends ConsumerWidget {
  const RegionsScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return const AppScreenFrame(
      screenBody: Stack(
        children: [
          RegionsGrid(),
          Positioned(
            bottom: 0,
            left: 0,
            child: RegionFloatingButtons(),
          )
        ],
      ),
    );
  }
}
