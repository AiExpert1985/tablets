import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tablets/src/features/products/controller/product_form_controller.dart';
import 'package:tablets/src/features/products/controller/products_list_controller.dart';
import 'package:tablets/src/features/products/model/product.dart';

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

class ProductItem extends StatelessWidget {
  const ProductItem(this.product, {super.key});
  final Product product;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(product.code.toString()),
        const SizedBox(width: 20),
        Text(product.name),
      ],
    );
  }
}
