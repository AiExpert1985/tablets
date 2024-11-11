import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tablets/src/common/widgets/main_frame.dart';
import 'package:tablets/src/features/products/view/product_floating_buttons.dart';
import 'package:tablets/src/features/products/view/product_list.dart';

class ProductsScreen extends ConsumerWidget {
  const ProductsScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AppScreenFrame(
      screenBody: Stack(
        children: [
          buildProductsList(context, ref),
          const Positioned(
            bottom: 0,
            left: 0,
            child: ProductFloatingButtons(),
          )
        ],
      ),
    );
  }
}
