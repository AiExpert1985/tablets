import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tablets/generated/l10n.dart';
import 'package:tablets/src/common/widgets/async_value_widget.dart';
import 'package:tablets/src/features/products/controllers/product_filtered_list_provider.dart';
import 'package:tablets/src/features/products/controllers/product_filter_controller_provider.dart';
import 'package:tablets/src/features/products/model/product.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:tablets/src/common/constants/constants.dart' as constants;
import 'package:tablets/src/features/products/repository/product_repository_provider.dart';
import 'package:tablets/src/features/products/view/product_form.dart';

class ProductsTable extends ConsumerWidget {
  const ProductsTable({super.key});

  void showEditProductForm(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext ctx) => const ProductForm(isEditMode: true),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productStream = ref.watch(productStreamProvider);
    final filterIsOn = ref.watch(productFilterSwitchProvider);
    final productsListValue =
        filterIsOn ? ref.read(productFilteredListProvider).getFilteredList() : productStream;
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
                      child: const CircleAvatar(
                        radius: 15,
                        foregroundImage: CachedNetworkImageProvider(constants.defaultImageUrl),
                      ),
                      onTap: () => showEditProductForm(context),
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
