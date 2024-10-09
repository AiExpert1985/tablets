import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pluto_grid/pluto_grid.dart';
import 'package:tablets/generated/l10n.dart';
import 'package:tablets/src/common_widgets/various/async_value_widget.dart';
import 'package:tablets/src/features/products/controller/product_form_controller.dart';
import 'package:tablets/src/features/products/controller/product_list_filter_controller.dart';
import 'package:tablets/src/features/products/model/product.dart';
import 'package:tablets/src/features/products/repository/product_repository_provider.dart';
import 'package:data_table_2/data_table_2.dart';

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
        data: (products) {
          List<DataRow2> rows = products.map((map) {
            return DataRow2(
              cells: [
                DataCell(
                  IconButton(
                    icon: const Icon(Icons.preview),
                    onPressed: () =>
                        formController.showEditProductForm(context: context, product: Product.fromMap(map)),
                  ),
                ),
                DataCell(Text(map['code'].toString())),
                DataCell(Text(map['name'])),
              ],
            );
          }).toList();
          return Padding(
            padding: const EdgeInsets.all(16),
            child: DataTable2(
              columnSpacing: 12,
              horizontalMargin: 12,
              minWidth: 400,
              columns: [
                DataColumn2(
                  label: Text(S.of(context).product_code),
                  size: ColumnSize.L,
                ),
                DataColumn2(
                  label: Text(S.of(context).product_code),
                  size: ColumnSize.L,
                ),
                DataColumn2(
                  label: Text(S.of(context).product_name),
                ),
              ],
              rows: rows,
            ),
          );
        }
        // ListView.builder(
        //       itemCount: products.length,
        //       itemBuilder: (ctx, index) {
        //         final product = Product.fromMap(products[index]);
        //         return InkWell(
        //           hoverColor: const Color.fromARGB(255, 173, 170, 170),
        //           onTap: () => formController.showEditProductForm(context: ctx, product: product),
        //           child: ProductItem(product),
        //         );
        //       },
        //     ),
        );
  }
}

// /// Example without a datasource
// class DataTable2SimpleDemo extends StatelessWidget {
//   const DataTable2SimpleDemo(this.productList, {super.key});
//   final List<Map<String, dynamic>> productList;

//   @override
//   Widget build(BuildContext context) {
//     List<DataRow2> rows = productList.map((map) {
//       return DataRow2(
//         cells: [
//           DataCell(IconButton(icon: ,onPressed:  () => formController.showEditProductForm(context: ctx, product: product),,)),
//           DataCell(Text(map['code'].toString())),
//           DataCell(Text(map['name'])),
//         ],
//       );
//     }).toList();
//     return Padding(
//       padding: const EdgeInsets.all(16),
//       child: DataTable2(
//         columnSpacing: 12,
//         horizontalMargin: 12,
//         minWidth: 400,
//         columns: [
//           DataColumn2(
//             label: Text(S.of(context).product_code),
//             size: ColumnSize.L,
//           ),
//           DataColumn(
//             label: Text(S.of(context).product_name),
//           ),
//         ],
//         rows: rows,
//       ),
//     );
//   }
// }

class ProductItem extends StatelessWidget {
  const ProductItem(this.product, {super.key});
  final Product product;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ListTitleText(product.code.toString()),
        const SizedBox(width: 20),
        ListTitleText(product.name),
        const SizedBox(width: 20),
        ListTitleText(product.sellRetailPrice.toString()),
        const SizedBox(width: 20),
        ListTitleText(product.sellWholePrice.toString()),
      ],
    );
  }
}

class ProductListTitles extends StatelessWidget {
  const ProductListTitles({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ListTitleText(S.of(context).product_code),
        const SizedBox(width: 20),
        ListTitleText(S.of(context).product_name),
        const SizedBox(width: 20),
        ListTitleText(S.of(context).product_sell_retail_price),
        const SizedBox(width: 20),
        ListTitleText(S.of(context).product_sell_whole_price),
      ],
    );
  }
}

class ListTitleText extends StatelessWidget {
  const ListTitleText(this.title, {super.key});
  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(fontSize: 20),
    );
  }
}
