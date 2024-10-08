import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tablets/src/common_widgets/various/async_value_widget.dart';
import 'package:tablets/src/features/products/controller/product_form_controller.dart';
import 'package:tablets/src/features/products/controller/product_list_filter_controller.dart';
import 'package:tablets/src/features/products/model/product.dart';
import 'package:tablets/src/features/products/repository/product_repository_provider.dart';

class ProductList extends ConsumerWidget {
  const ProductList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productStream = ref.watch(productsStreamProvider);
    final formController = ref.watch(productsFormControllerProvider);
    final productsFilter = ref.watch(productListFilterNotifierProvider);
    AsyncValue<List<Map<String, dynamic>>> productsListValue =
        productsFilter.isSearchOn ? productsFilter.filteredList : productStream;
    return AsyncValueWidget<List<Map<String, dynamic>>>(
        value: productsListValue,
        data: (products) => ListView.builder(
              itemCount: products.length,
              itemBuilder: (ctx, index) {
                final product = Product.fromMap(products[index]);
                return InkWell(
                  hoverColor: const Color.fromARGB(255, 173, 170, 170),
                  onTap: () => formController.showEditProductForm(context: ctx, product: product),
                  child: ProductItem(product),
                );
              },
            ));
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
