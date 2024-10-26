import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tablets/generated/l10n.dart';
import 'package:tablets/src/common/functions/debug_print.dart';
import 'package:tablets/src/common/widgets/form_fields/drop_down_with_search.dart';
import 'package:tablets/src/features/products/repository/product_repository_provider.dart';
import 'package:tablets/src/common/values/form_dimenssions.dart';
import 'package:tablets/src/features/transactions/controllers/transaction_form_controller.dart';

class InvoiceItemList extends ConsumerWidget {
  const InvoiceItemList({super.key});
  // final String formFieldName;
  // Map<String, dynamic> addNewEmptyRow(formData, fieldName) {
  //   // final emptyValues = {
  //   //   'price': null,
  //   //   'soldQuantity': null,
  //   //   'giftQuantity': null,
  //   //   'totalPrice': null
  //   // };
  //   if (formData[fieldName] != null) {
  //     (formData[fieldName] as List<dynamic>?)
  //         ?.map((item) => item as Map<String, dynamic>)
  //         .toList()
  //         .add({});
  //   } else {
  //     formData[fieldName] = [{}];
  //   }
  //   return formData;
  // }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(transactionFormDataProvider);
    final formController = ref.watch(transactionFormDataProvider.notifier);
    final repository = ref.watch(productRepositoryProvider);
    final formData = formController.data;
    // final updatedFormData = addNewEmptyRow(initialFormData, formFieldName);
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
          Expanded(
            child: ListView.builder(
              itemCount: formData['items']?.length ?? 0,
              itemBuilder: (context, index) {
                return ListTile(
                  title: CustomerInvoiceItemListData(
                      sequence: index,
                      dbListFetchFn: repository.fetchItemListAsMaps,
                      formData: formController.data,
                      onChangedFn: formController.update),
                );
              },
            ),
          ),
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
      super.key});
  final int sequence;
  final Map<String, dynamic> formData;
  final void Function(Map<String, dynamic>) onChangedFn;
  final Future<List<Map<String, dynamic>>> Function({String? filterKey, String? filterValue})
      dbListFetchFn;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Row(
      children: [
        InvoiceItemListCell(
            isTitle: true, isFirst: true, width: sequenceWidth, cell: Text(sequence.toString())),
        InvoiceItemListCell(
            isTitle: true,
            width: nameWidth,
            cell: DropDownWithSearchFormField(
              subItemSequence: sequence,
              hideBorders: true,
              fieldName: 'items',
              dbListFetchFn: dbListFetchFn,
              onChangedFn: onChangedFn,
              formData: formData,
            )),
        const InvoiceItemListCell(isTitle: true, width: priceWidth, cell: Text('tempText')),
        const InvoiceItemListCell(isTitle: true, width: soldQuantityWidth, cell: Text('TempText')),
        const InvoiceItemListCell(isTitle: true, width: giftQantityWidth, cell: Text('tempText')),
        const InvoiceItemListCell(
            isTitle: true, isLast: true, width: soldTotalPriceWidth, cell: Text('tempText')),
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
        child: Column(
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
    final formController = ref.watch(transactionFormDataProvider.notifier);
    return Row(
      children: [
        InvoiceItemListCell(
          isTitle: true,
          isFirst: true,
          width: sequenceWidth,
          cell: IconButton(
            alignment: Alignment.topCenter,
            onPressed: () {
              tempPrint(formController.data);
              addNewEmptyRow(formController);
              tempPrint(formController.data);
            },
            icon: const Icon(Icons.add, color: Colors.green),
          ),
        ),
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
const double itemHeight = customerInvoiceFormHeight * 0.045;
const double sequenceWidth = customerInvoiceFormWidth * 0.07;
const double nameWidth = customerInvoiceFormWidth * 0.3;
const double priceWidth = customerInvoiceFormWidth * 0.12;
const double soldQuantityWidth = customerInvoiceFormWidth * 0.12;
const double giftQantityWidth = customerInvoiceFormWidth * 0.12;
const double soldTotalPriceWidth = customerInvoiceFormWidth * 0.13;
