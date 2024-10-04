import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tablets/src/common_widgets/main_layout/app_screen_frame.dart';
import 'package:tablets/src/features/products/controller/product_drawer_controller.dart';
import 'package:tablets/src/features/products/controller/product_form_controller.dart';
import 'package:tablets/src/features/products/view/products_list.dart';

class ProductsScreen extends ConsumerWidget {
  const ProductsScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formController = ref.watch(productsFormControllerProvider);
    final drawerController = ref.watch(productsDrawerProvider);
    return AppScreenFrame(
      addMethod: formController.showAddProductForm,
      screenBody: Stack(
        children: [
          const ProductList(),
          Positioned(
            top: 20,
            left: 0,
            child: IconButton(
              onPressed: () => drawerController.showFilter(context),
              icon: Icon(
                Icons.filter_alt_outlined,
                size: 30,
                color: Colors.blue[900],
              ),
            ),
          ),
          Positioned(
            top: 80,
            left: 0,
            child: IconButton(
              onPressed: () => drawerController.showReports(context),
              icon: Icon(
                Icons.filter,
                size: 25,
                color: Colors.blue[900],
              ),
            ),
          )
        ],
      ),
    );
  }
}
