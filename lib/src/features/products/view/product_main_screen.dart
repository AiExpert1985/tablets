import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tablets/src/common_widgets/main_layout/app_screen_frame.dart';
import 'package:tablets/src/features/products/controller/product_drawer_provider.dart';
import 'package:tablets/src/features/products/controller/product_form_provider.dart';
import 'package:tablets/src/features/products/controller/products_list_controller.dart';
import 'package:tablets/src/features/products/view/products_list.dart';

class ProductsScreen extends ConsumerWidget {
  const ProductsScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formController = ref.watch(productsFormControllerProvider);
    final drawerController = ref.watch(productsDrawerProvider);
    ref.watch(productSearchNotifierProvider);
    return AppScreenFrame(
      screenBody: Stack(
        children: [
          const ProductList(),
          Positioned(
            bottom: 0,
            left: 0,
            child: Column(
              children: [
                FloatingActionButton(
                  onPressed: () => drawerController.showSearchForm(context),
                  child: Icon(
                    Icons.filter_alt_outlined,
                    size: 30,
                    color: Colors.blue[900],
                  ),
                ),
                const SizedBox(height: 20),
                FloatingActionButton(
                  onPressed: () => drawerController.showReports(context),
                  child: Icon(
                    Icons.filter,
                    size: 25,
                    color: Colors.blue[900],
                  ),
                ),
                const SizedBox(height: 20),
                FloatingActionButton(
                  onPressed: () => formController.showAddProductForm(context),
                  child: const Icon(Icons.add),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
