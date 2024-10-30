import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tablets/src/common/classes/item_form_data.dart';
import 'package:tablets/src/common/functions/debug_print.dart';
import 'package:tablets/src/common/providers/text_editing_controllers_provider.dart';
import 'package:tablets/src/common/values/form_dimenssions.dart';
import 'package:tablets/src/common/widgets/form_fields/drop_down_with_search.dart';
import 'package:tablets/src/features/products/repository/product_repository_provider.dart';
import 'package:tablets/src/features/transactions/controllers/transaction_form_controller.dart';
import 'package:tablets/src/features/transactions/view/forms/item_cell.dart';
import 'package:tablets/src/features/transactions/view/forms/text_input_field.dart';
import 'package:tablets/src/common/values/constants.dart' as constants;

class CustomerInvoiceItemDataRow extends ConsumerWidget {
  const CustomerInvoiceItemDataRow({required this.sequence, super.key});
  final int sequence;

  void updateTotalWeight(ItemFormData formController) {
    Map<String, dynamic> formData = formController.data;
    double totalWeight = 0;
    if (!formData.containsKey('items') || formData['items'] is! List<Map<String, dynamic>>) {
      errorPrint(message: 'formData does not contains the key (items) or items is not a List<Map<String, dynamic>>');
      return;
    }
    for (var item in formData['items']) {
      if (!item.containsKey('weight')) {
        errorPrint(message: 'form[items] does not contain (weight) key');
        continue;
      }
      final weight = item['weight'];
      if (weight is! double) {
        errorPrint(message: 'formData[items][i][weight] is not of type double');
        continue;
      }
      totalWeight += weight;
    }
    formController.update({'totalWeight': totalWeight});
  }

  void updateTotalAmount(ItemFormData formController) {
    Map<String, dynamic> formData = formController.data;
    double totalAmount = 0;
    if (!formData.containsKey('items') || formData['items'] is! List<Map<String, dynamic>>) {
      errorPrint(message: 'formData does not contains the key (items) or items is not a List<Map<String, dynamic>>');
      return;
    }
    for (var item in formData['items']) {
      if (!item.containsKey('price')) {
        errorPrint(message: 'form[items] does not contain (price) key');
        continue;
      }
      final price = item['price'];
      if (price is! double) {
        errorPrint(message: 'formData[items][i][price] is not of type double');
        continue;
      }
      totalAmount += price;
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
                // here we update the price, and the item, and also the totalWeight
                // we don't update the totalPrice here because it is updated by the price field
                // which is triggered automatically when this field is changed
                if (!formController.data.containsKey('items')) {
                  errorPrint(message: 'formData[items] does not exist');
                  return;
                }
                if (!(formController.data['items'][sequence].containsKey('price')) ||
                    !(formController.data['items'][sequence].containsKey('weight'))) {
                  errorPrint(message: 'formData[items][i][price] or formData[items][i][weight] does not exist');
                  return;
                }
                textEditingController['items'][sequence].text =
                    formController.data['items'][sequence]['price'].toString();
                updateTotalWeight(formController);
                textEditingController['totalWeight'].text = formController.data['totalWeight'].toString();
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
              // this method is executed throught two ways, first when the field is updated by the user
              // and the second is automatic when user selects and item through adjacent product selection dropdown
              updateTotalAmount(formController);
              textEditingController['totalAmount'].text = formController.data['totalAmount'].toString();
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
