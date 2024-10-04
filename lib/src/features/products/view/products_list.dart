import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tablets/src/common_widgets/various/async_value_widget.dart';
import 'package:tablets/src/features/products/controller/product_form_controller.dart';
import 'package:tablets/src/features/products/model/product.dart';
import 'package:tablets/src/features/products/repository/product_repository_provider.dart';
import 'package:tablets/src/features/products/view/product_item.dart';

class ProductList extends ConsumerWidget {
  const ProductList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productsListValue = ref.watch(productsStreamProvider);
    final formController = ref.watch(productsFormControllerProvider);
    return AsyncValueWidget<List<Product>>(
      value: productsListValue,
      data: (products) => ListView.builder(
        itemCount: products.length,
        itemBuilder: (ctx, index) {
          final product = products[index];
          return InkWell(
            hoverColor: const Color.fromARGB(255, 173, 170, 170),
            onTap: () => formController.showEditProductForm(context: ctx, product: product),
            child: ProductItem(product),
          );
        },
      ),
    );
  }
}
