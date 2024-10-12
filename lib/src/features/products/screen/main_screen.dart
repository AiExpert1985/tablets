import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tablets/src/common_widgets/main_layout/main_frame.dart';
import 'package:tablets/src/features/products/screen/floating_buttons.dart';
import 'package:tablets/src/features/products/screen/products_table.dart';

class ProductsScreen extends ConsumerWidget {
  const ProductsScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return const AppScreenFrame(
      screenBody: Stack(
        children: [
          ProductsTable(),
          Positioned(
            bottom: 0,
            left: 0,
            child: ProductFloatingButtons(),
          )
        ],
      ),
    );
  }
}
