import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tablets/src/common/widgets/main_frame.dart';
import 'package:tablets/src/features/vendors/view/vendor_floating_buttons.dart';
import 'package:tablets/src/features/vendors/view/vendor_items_grid.dart';

class VendorScreen extends ConsumerWidget {
  const VendorScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return const AppScreenFrame(
      screenBody: Stack(
        children: [
          VendorGrid(),
          Positioned(
            bottom: 0,
            left: 0,
            child: VendorFloatingButtons(),
          )
        ],
      ),
    );
  }
}
