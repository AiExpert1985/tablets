import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tablets/src/features/products/controller/product_form_provider.dart';
import 'package:tablets/src/features/products/controller/products_list_controller.dart';
import 'package:tablets/src/features/products/view/product_item.dart';

class ProductList extends ConsumerWidget {
  const ProductList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productsState = ref.watch(productSearchNotifierProvider);
    final formController = ref.watch(productsFormControllerProvider);
    final productList = productsState.productList;
    return ListView.builder(
      itemCount: productList.length,
      itemBuilder: (ctx, index) {
        final product = productList[index];
        return InkWell(
          hoverColor: const Color.fromARGB(255, 173, 170, 170),
          onTap: () => formController.showEditProductForm(context: ctx, product: product),
          child: ProductItem(product),
        );
      },
    );
  }
}
