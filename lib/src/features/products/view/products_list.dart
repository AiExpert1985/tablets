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
        value: productsListValue, data: (products) => DataTable2SimpleDemo(products)
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

/// Example without a datasource
class DataTable2SimpleDemo extends StatelessWidget {
  const DataTable2SimpleDemo(this.productList, {super.key});
  final List<Map<String, dynamic>> productList;

  @override
  Widget build(BuildContext context) {
    List<DataRow2> rows = productList.map((map) {
      return DataRow2(
        cells: [
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
          DataColumn(
            label: Text(S.of(context).product_name),
          ),
          // DataColumn(
          //   label: Text(S.of(context).product_sell_retail_price),
          // ),
          // DataColumn(
          //   label: Text(S.of(context).product_sell_whole_price),
          // ),
        ],
        rows: rows,
      ),
    );
  }
}

class PlotoTable extends StatelessWidget {
  const PlotoTable({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(30),
      child: PlutoGrid(
          columns: columns,
          rows: rows,
          onChanged: (PlutoGridOnChangedEvent event) {
            print(event);
          },
          onLoaded: (PlutoGridOnLoadedEvent event) {
            print(event);
          }),
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

List<PlutoColumn> columns = [
  /// Text Column definition
  PlutoColumn(
    title: 'text column',
    field: 'text_field',
    type: PlutoColumnType.text(),
  ),

  /// Number Column definition
  PlutoColumn(
    title: 'number column',
    field: 'number_field',
    type: PlutoColumnType.number(),
  ),

  /// Select Column definition
  PlutoColumn(
    title: 'select column',
    field: 'select_field',
    type: PlutoColumnType.select(['item1', 'item2', 'item3']),
  ),

  /// Datetime Column definition
  PlutoColumn(
    title: 'date column',
    field: 'date_field',
    type: PlutoColumnType.date(),
  ),

  /// Time Column definition
  PlutoColumn(
    title: 'time column',
    field: 'time_field',
    type: PlutoColumnType.time(),
  ),
];

List<PlutoRow> rows = [
  PlutoRow(
    cells: {
      'text_field': PlutoCell(value: 'Text cell value1'),
      'number_field': PlutoCell(value: 2020),
      'select_field': PlutoCell(value: 'item1'),
      'date_field': PlutoCell(value: '2020-08-06'),
      'time_field': PlutoCell(value: '12:30'),
    },
  ),
  PlutoRow(
    cells: {
      'text_field': PlutoCell(value: 'Text cell value2'),
      'number_field': PlutoCell(value: 2021),
      'select_field': PlutoCell(value: 'item2'),
      'date_field': PlutoCell(value: '2020-08-07'),
      'time_field': PlutoCell(value: '18:45'),
    },
  ),
  PlutoRow(
    cells: {
      'text_field': PlutoCell(value: 'Text cell value3'),
      'number_field': PlutoCell(value: 2022),
      'select_field': PlutoCell(value: 'item3'),
      'date_field': PlutoCell(value: '2020-08-08'),
      'time_field': PlutoCell(value: '23:59'),
    },
  ),
];
