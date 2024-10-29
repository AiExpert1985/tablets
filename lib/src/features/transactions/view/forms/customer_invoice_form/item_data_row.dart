import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tablets/src/common/classes/item_form_data.dart';
import 'package:tablets/src/common/functions/debug_print.dart';
import 'package:tablets/src/common/providers/text_editing_controllers_provider.dart';
import 'package:tablets/src/common/values/constants.dart' as constants;
import 'package:tablets/src/common/values/form_dimenssions.dart';
import 'package:tablets/src/common/widgets/form_fields/drop_down_with_search.dart';
import 'package:tablets/src/features/products/repository/product_repository_provider.dart';
import 'package:tablets/src/features/transactions/controllers/transaction_form_controller.dart';
import 'package:tablets/src/features/transactions/view/forms/item_cell.dart';
import 'package:tablets/src/features/transactions/view/forms/text_input_field.dart';

class CustomerInvoiceItemDataRow extends ConsumerWidget {
  const CustomerInvoiceItemDataRow({required this.sequence, super.key});
  final int sequence;
  String updateTotalWeight(formData) {
    int totalWeight = 0;
    return totalWeight.toString();
  }

  void updateTotalAmount(ItemFormData formController) {
    final formData = formController.data;
    double totalAmount = 0;
    if (!formData.containsKey('items')) return;
    for (int i = 0; i < formData['items'].length; i++) {
      if (formData['items'][i].containsKey('price')) {
        totalAmount += formData['items'][i]['price'];
      }
    }
    formController.update({'totalAmount': totalAmount});
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formController = ref.read(transactionFormDataProvider.notifier);
    final textEditingController = ref.read(textFieldsControllerProvider);
    final repository = ref.read(productRepositoryProvider);
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        ItemDataCell(isFirst: true, width: sequenceWidth, cell: Text((sequence + 1).toString())),
        ItemDataCell(
            width: nameWidth,
            cell: DropDownWithSearchFormField(
              formData: formController.data,
              property: 'items',
              subProperty: 'name',
              subPropertyIndex: sequence,
              relatedSubProperties: const {'price': 'sellWholePrice', 'weight': 'packageWeight'},
              dbListFetchFn: repository.fetchItemListAsMaps,
              onChangedFn: formController.update,
              hideBorders: true,
              updateReletedFieldsFn: () {
                if (!formController.data.containsKey('items') ||
                    !(formController.data['items'][sequence].containsKey('price'))) {
                  return;
                }
                textEditingController['items'][sequence].text =
                    formController.data['items'][sequence]['price'].toString();
              },
            )),
        ItemDataCell(
          width: priceWidth,
          cell: TransactionFormInputField(
            controller: textEditingController['items'][sequence],
            isRequired: false,
            subProperty: 'price',
            subPropertyIndex: sequence,
            hideBorders: true,
            dataType: constants.FieldDataTypes.double,
            property: 'items',
            updateReletedFieldsFn: () {
              updateTotalAmount(formController);
              tempPrint(formController.data);
              textEditingController['totalAmount'].text =
                  formController.data['totalAmount'].toString();
            },
          ),
        ),
        const ItemDataCell(width: soldQuantityWidth, cell: Text('TempText')),
        const ItemDataCell(width: giftQantityWidth, cell: Text('tempText')),
        const ItemDataCell(isLast: true, width: soldTotalAmountWidth, cell: Text('tempText')),
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
const double soldTotalAmountWidth = customerInvoiceFormWidth * 0.17;
