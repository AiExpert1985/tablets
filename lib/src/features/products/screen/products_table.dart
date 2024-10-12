import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tablets/generated/l10n.dart';
import 'package:tablets/src/common_widgets/various/async_value_widget.dart';
import 'package:tablets/src/constants/constants.dart';
import 'package:tablets/src/features/products/controller/form_provider.dart';
import 'package:tablets/src/features/products/controller/list_filter_controller.dart';
import 'package:tablets/src/features/products/model/product.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:tablets/src/features/products/repository/product_stream_provider.dart';

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
            Product product = Product.fromMap(map);
            return DataRow2(
              cells: [
                DataCell(Row(
                  children: [
                    InkWell(
                      child: CircleAvatar(
                        radius: 15,
                        foregroundImage: CachedNetworkImageProvider(DefaultImage.url),
                      ),
                      onTap: () =>
                          formController.showEditProductForm(context: context, product: product),
                    ),
                    const SizedBox(width: 20),
                    Text(product.code.toString()),
                  ],
                )),
                DataCell(Text(product.name)),
                DataCell(Text(product.sellRetailPrice.toString())),
                DataCell(Text(product.sellWholePrice.toString())),
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
                      const SizedBox(width: 50),
                      ColumnTitleText(S.of(context).product_code),
                    ],
                  ),
                  size: ColumnSize.S,
                ),
                DataColumn2(
                  label: ColumnTitleText(S.of(context).product_name),
                  size: ColumnSize.S,
                ),
                DataColumn2(
                  label: ColumnTitleText(S.of(context).product_sell_retail_price),
                  size: ColumnSize.S,
                ),
                DataColumn2(
                  label: ColumnTitleText(S.of(context).product_sell_whole_price),
                  size: ColumnSize.S,
                ),
              ],
              rows: rows,
            ),
          );
        });
  }
}

class ColumnTitleText extends StatelessWidget {
  const ColumnTitleText(this.title, {super.key});
  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}
