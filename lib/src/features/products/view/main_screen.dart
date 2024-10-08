import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tablets/src/common_widgets/main_layout/main_screen_frame.dart';
import 'package:tablets/src/features/products/controller/products_list_controller.dart';
import 'package:tablets/src/features/products/view/floating_buttons.dart';
import 'package:tablets/src/features/products/view/products_list.dart';

class ProductsScreen extends ConsumerWidget {
  const ProductsScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(productSearchNotifierProvider);
    return const AppScreenFrame(
      screenBody: Stack(
        children: [
          ProductList(),
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
