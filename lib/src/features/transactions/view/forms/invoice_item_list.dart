import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tablets/generated/l10n.dart';
import 'package:tablets/src/common/functions/debug_print.dart';
import 'package:tablets/src/common/values/constants.dart' as constants;
import 'package:tablets/src/common/widgets/form_fields/drop_down_with_search.dart';
import 'package:tablets/src/features/products/repository/product_repository_provider.dart';
import 'package:tablets/src/common/values/form_dimenssions.dart';
import 'package:tablets/src/features/transactions/controllers/transaction_form_controller.dart';
import 'package:tablets/src/features/transactions/view/forms/transaction_form_field.dart';

class InvoiceItemList extends ConsumerWidget {
  const InvoiceItemList({super.key});

  List<Widget> createDataRows(formController, repository) {
    List<Widget> rows = [];
    int numItems = formController.data['items']?.length ?? 0;
    for (var i = 0; i < numItems; i++) {
      dynamic price = formController.data['items'][i]['price'] ?? 0;
      TextEditingController controller = TextEditingController(text: price.toString());
      tempPrint(controller);
      rows.add(CustomerInvoiceItemListData(
          priceTextController: controller,
          sequence: i,
          dbListFetchFn: repository.fetchItemListAsMaps,
          formData: formController.data,
          onChangedFn: formController.update));
    }
    return rows;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(transactionFormDataProvider);
    final formController = ref.read(transactionFormDataProvider.notifier);
    final repository = ref.read(productRepositoryProvider);
    return Container(
      height: 350,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black38, width: 1.0),
        borderRadius: BorderRadius.circular(8.0),
      ),
      padding: const EdgeInsets.all(12),
      child: Column(
        children: [
          const CustomerInvoiceItemListTitles(),
          ...createDataRows(formController, repository),
        ],
      ),
    );
  }
}

class CustomerInvoiceItemListData extends ConsumerWidget {
  const CustomerInvoiceItemListData(
      {required this.sequence,
      required this.dbListFetchFn,
      required this.onChangedFn,
      required this.formData,
      required this.priceTextController,
      super.key});
  final int sequence;
  final Map<String, dynamic> formData;
  final void Function(Map<String, dynamic>) onChangedFn;
  final Future<List<Map<String, dynamic>>> Function({String? filterKey, String? filterValue})
      dbListFetchFn;
  final TextEditingController priceTextController;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        InvoiceItemListCell(
            isFirst: true, width: sequenceWidth, cell: Text((sequence + 1).toString())),
        InvoiceItemListCell(
            width: nameWidth,
            cell: DropDownWithSearchFormField(
              formData: formData,
              property: 'items',
              subProperty: 'name',
              subPropertyIndex: sequence,
              relatedSubProperties: const {'price': 'sellWholePrice', 'weight': 'packageWeight'},
              dbListFetchFn: dbListFetchFn,
              onChangedFn: onChangedFn,
              hideBorders: true,
            )),
        InvoiceItemListCell(
          width: priceWidth,
          cell: TransactionFormInputField(
            controller: priceTextController,
            isRequired: false,
            subProperty: 'price',
            subPropertyIndex: sequence,
            hideBorders: true,
            dataType: constants.FieldDataTypes.double,
            property: 'items',
          ),
        ),
        const InvoiceItemListCell(width: soldQuantityWidth, cell: Text('TempText')),
        const InvoiceItemListCell(width: giftQantityWidth, cell: Text('tempText')),
        const InvoiceItemListCell(isLast: true, width: soldTotalPriceWidth, cell: Text('tempText')),
      ],
    );
  }
}

class InvoiceItemListCell extends ConsumerWidget {
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
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
        decoration: BoxDecoration(
          border: Border(
              left: !isLast
                  ? const BorderSide(color: Color.fromARGB(31, 133, 132, 132), width: 1.0)
                  : BorderSide.none,
              right: !isFirst
                  ? const BorderSide(color: Color.fromARGB(31, 133, 132, 132), width: 1.0)
                  : BorderSide.none,
              bottom: const BorderSide(color: Color.fromARGB(31, 133, 132, 132), width: 1.0)),
        ),
        width: width,
        height: height,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            cell,
          ],
        ));
  }
}

class CustomerInvoiceItemListTitles extends ConsumerWidget {
  const CustomerInvoiceItemListTitles({super.key});
  void addNewEmptyRow(formController) {
    Map<String, dynamic> formData = formController.data;
    Map<String, dynamic> emptyMap = {};
    // final emptyValues = {
    //   'price': null,
    //   'soldQuantity': null,
    //   'giftQuantity': null,
    //   'totalPrice': null
    // };
    if (formData['items'] != null) {
      formData['items'].add(emptyMap);
    } else {
      formData['items'] = [emptyMap];
    }
    formController.update(formData);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formController = ref.read(transactionFormDataProvider.notifier);
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        InvoiceItemListCell(
          isTitle: true,
          isFirst: true,
          width: sequenceWidth,
          height: titleHeight,
          cell: IconButton(
            // alignment: Alignment.topCenter,
            onPressed: () {
              addNewEmptyRow(formController);
            },
            icon: const Icon(Icons.add, color: Colors.green),
          ),
        ),
        InvoiceItemListCell(
            isTitle: true,
            height: titleHeight,
            width: nameWidth,
            cell: Text(S.of(context).item_name)),
        InvoiceItemListCell(
            isTitle: true,
            height: titleHeight,
            width: priceWidth,
            cell: Text(S.of(context).item_price)),
        InvoiceItemListCell(
            isTitle: true,
            height: titleHeight,
            width: soldQuantityWidth,
            cell: Text(S.of(context).item_sold_quantity)),
        InvoiceItemListCell(
            isTitle: true,
            height: titleHeight,
            width: giftQantityWidth,
            cell: Text(S.of(context).item_gifts_quantity)),
        InvoiceItemListCell(
            isTitle: true,
            isLast: true,
            height: titleHeight,
            width: soldTotalPriceWidth,
            cell: Text(S.of(context).item_total_price)),
      ],
    );
  }
}

// I made a design decision to make the width variable based on the size of the container
const double titleHeight = customerInvoiceFormHeight * 0.065;
const double itemHeight = customerInvoiceFormHeight * 0.05;
const double sequenceWidth = customerInvoiceFormWidth * 0.055;
const double nameWidth = customerInvoiceFormWidth * 0.345;
const double priceWidth = customerInvoiceFormWidth * 0.16;
const double soldQuantityWidth = customerInvoiceFormWidth * 0.1;
const double giftQantityWidth = customerInvoiceFormWidth * 0.1;
const double soldTotalPriceWidth = customerInvoiceFormWidth * 0.17;
