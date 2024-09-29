import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tablets/src/common_widgets/main_layout/app_screen_frame.dart';
import 'package:tablets/src/features/products/controller/products_controller.dart';
import 'package:tablets/src/features/products/view/products_grid.dart';

class ProductsScreen extends ConsumerWidget {
  const ProductsScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productController = ref.watch(productsControllerProvider);
    return AppScreenFrame(
      addMethod: productController.showProductCreateForm,
      screenBody: const ProductsGrid(),
    );
  }
}
