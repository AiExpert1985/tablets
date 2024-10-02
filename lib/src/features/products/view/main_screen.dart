import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tablets/src/common_widgets/main_layout/app_screen_frame.dart';
import 'package:tablets/src/features/products/controller/product_form_provider.dart';
import 'package:tablets/src/features/products/view/products_grid.dart';

class ProductsScreen extends ConsumerWidget {
  const ProductsScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formController = ref.watch(productsFormControllerProvider);
    return AppScreenFrame(
      addMethod: formController.showAddProductForm,
      screenBody: const ProductsGrid(),
    );
  }
}
