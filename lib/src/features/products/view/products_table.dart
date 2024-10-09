import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tablets/generated/l10n.dart';
import 'package:tablets/src/common_widgets/various/async_value_widget.dart';
import 'package:tablets/src/features/products/controller/product_form_controller.dart';
import 'package:tablets/src/features/products/controller/product_list_filter_controller.dart';
import 'package:tablets/src/features/products/model/product.dart';
import 'package:tablets/src/features/products/repository/product_repository_provider.dart';
import 'package:data_table_2/data_table_2.dart';

class ProductsTable extends ConsumerWidget {
  const ProductsTable({super.key});

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
                DataCell(Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.center_focus_strong),
                      onPressed: () => formController.showEditProductForm(
                          context: context, product: Product.fromMap(map)),
                    ),
                    const SizedBox(width: 20),
                    Text(map['code'].toString()),
                  ],
                )),
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
                  label: Row(
                    children: [
                      const SizedBox(width: 60),
                      Text(S.of(context).product_code),
                    ],
                  ),
                  size: ColumnSize.S,
                ),
                DataColumn2(
                  label: Text(S.of(context).product_name),
                  size: ColumnSize.S,
                ),
              ],
              rows: rows,
            ),
          );
        });
  }
}
