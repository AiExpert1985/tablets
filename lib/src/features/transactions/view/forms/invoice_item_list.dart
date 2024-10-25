import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tablets/generated/l10n.dart';
import 'package:tablets/src/common/values/constants.dart';
import 'package:tablets/src/common/widgets/form_field_drop_down_with_search_for_sublist.dart';
import 'package:tablets/src/features/products/controllers/product_form_controller.dart';
import 'package:tablets/src/features/products/repository/product_repository_provider.dart';

class InvoiceItemList extends StatelessWidget {
  const InvoiceItemList({super.key});

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> itemMap = {
      'price': 'price',
      'soldQuantity': 'soldQuantity',
      'giftQuantity': 'giftQuantity',
      'totalPrice': 'totalPrice'
    };
    return Container(
      height: 300,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black38, width: 1.0),
        borderRadius: BorderRadius.circular(8.0),
      ),
      padding: const EdgeInsets.all(12),
      child: Column(
        children: [
          const CustomerInvoiceItemListTitles(),
          Expanded(
            child: ListView(
              children: [
                const CustomerInvoiceItemListTitles(),
                CustomerInvoiceItemListData(
                  sequence: 1,
                  itemMap: itemMap,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class CustomerInvoiceItemListData extends ConsumerWidget {
  const CustomerInvoiceItemListData({required this.sequence, required this.itemMap, super.key});
  final int sequence;
  // itemMap.keys must contain {'name',price', 'soldQuantity', 'giftQuantity', 'totalPrice'}
  final Map<String, dynamic> itemMap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formController = ref.watch(productFormDataProvider.notifier);
    final repository = ref.watch(productRepositoryProvider);
    return Row(
      children: [
        InvoiceItemListCell(
            isTitle: true, isFirst: true, width: sequenceWidth, cell: Text(sequence.toString())),
        InvoiceItemListCell(
            isTitle: true,
            width: nameWidth,
            cell: Expanded(
              child: DropDownWithSearchFormFieldForSubList(
                  formDataPropertyName: 'items',
                  dbItemFetchFn: repository.fetchItemAsMap,
                  dbListFetchFn: repository.fetchItemListAsMaps,
                  onChangedFn: formController.updateSubProperty,
                  formData: formController.data,
                  selectedItemPropertyName: 'name'),
            )),
        InvoiceItemListCell(isTitle: true, width: priceWidth, cell: Text(itemMap['price']!)),
        InvoiceItemListCell(
            isTitle: true, width: soldQuantityWidth, cell: Text(itemMap['soldQuantity']!)),
        InvoiceItemListCell(
            isTitle: true, width: giftQantityWidth, cell: Text(itemMap['giftQuantity']!)),
        InvoiceItemListCell(
            isTitle: true,
            isLast: true,
            width: soldTotalPriceWidth,
            cell: Text(itemMap['totalPrice']!)),
      ],
    );
  }
}

class InvoiceItemListCell extends StatelessWidget {
  const InvoiceItemListCell(
      {required this.width,
      required this.cell,
      this.height = itemHeight,
      this.isTitle = false,
      this.isFirst = false,
      this.isLast = false,
      super.key});
  final bool isTitle; // title is diffent in having lower border line
  final bool isFirst; // first doesn't have right border (in arabic locale)
  final bool isLast; // doesn't have left border (in arabic locale)
  final double width;
  final double height;
  final Widget cell;

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
          border: Border(
            left: !isLast
                ? const BorderSide(color: Color.fromARGB(31, 133, 132, 132), width: 1.0)
                : BorderSide.none,
            right: !isFirst
                ? const BorderSide(color: Color.fromARGB(31, 133, 132, 132), width: 1.0)
                : BorderSide.none,
            bottom: isTitle
                ? const BorderSide(color: Color.fromARGB(31, 133, 132, 132), width: 1.0)
                : BorderSide.none,
          ),
        ),
        width: width,
        height: itemHeight,
        child: Center(child: cell));
  }
}

class CustomerInvoiceItemListTitles extends StatelessWidget {
  const CustomerInvoiceItemListTitles({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        InvoiceItemListCell(
            isTitle: true,
            isFirst: true,
            width: sequenceWidth,
            cell: Text(S.of(context).item_sequence)),
        InvoiceItemListCell(isTitle: true, width: nameWidth, cell: Text(S.of(context).item_name)),
        InvoiceItemListCell(isTitle: true, width: priceWidth, cell: Text(S.of(context).item_price)),
        InvoiceItemListCell(
            isTitle: true, width: soldQuantityWidth, cell: Text(S.of(context).item_sold_quantity)),
        InvoiceItemListCell(
            isTitle: true, width: giftQantityWidth, cell: Text(S.of(context).item_gifts_quantity)),
        InvoiceItemListCell(
            isTitle: true,
            isLast: true,
            width: soldTotalPriceWidth,
            cell: Text(S.of(context).item_total_price)),
      ],
    );
  }
}

// I made a design decision to make the width variable based on the size of the container
const double itemHeight = customerInvoiceFormHeight * 0.05;
const double sequenceWidth = customerInvoiceFormWidth * 0.1;
const double nameWidth = customerInvoiceFormWidth * 0.34;
const double priceWidth = customerInvoiceFormWidth * 0.12;
const double soldQuantityWidth = customerInvoiceFormWidth * 0.12;
const double giftQantityWidth = customerInvoiceFormWidth * 0.12;
const double soldTotalPriceWidth = customerInvoiceFormWidth * 0.13;
