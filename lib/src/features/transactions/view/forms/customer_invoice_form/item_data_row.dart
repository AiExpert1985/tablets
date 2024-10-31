import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tablets/src/common/classes/item_form_data.dart';
import 'package:tablets/src/common/functions/debug_print.dart';
import 'package:tablets/src/common/providers/text_editing_controllers_provider.dart';
import 'package:tablets/src/common/values/form_dimenssions.dart';
import 'package:tablets/src/common/widgets/form_fields/drop_down_with_search.dart';
import 'package:tablets/src/common/widgets/form_fields/edit_box.dart';
import 'package:tablets/src/features/products/repository/product_repository_provider.dart';
import 'package:tablets/src/features/transactions/controllers/transaction_form_controller.dart';
import 'package:tablets/src/features/transactions/view/forms/item_cell.dart';
import 'package:tablets/src/common/values/constants.dart' as constants;

class CustomerInvoiceItemDataRow extends ConsumerWidget {
  const CustomerInvoiceItemDataRow({required this.index, super.key});
  final int index;

  void updateTotalWeight(ItemFormData formDataNotifier) {
    double totalWeight = 0;
    if (!formDataNotifier.data.containsKey('items') || formDataNotifier.data['items'] is! List<Map<String, dynamic>>) {
      errorPrint(message: 'formData does not contains the key (items) or items is not a List<Map<String, dynamic>>');
      return;
    }
    for (var item in formDataNotifier.data['items']) {
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
    formDataNotifier.updateProperties({'totalWeight': totalWeight});
  }

  void updateTotalAmount(ItemFormData formDataNotifier) {
    double totalAmount = 0;
    if (!formDataNotifier.data.containsKey('items') || formDataNotifier.data['items'] is! List<Map<String, dynamic>>) {
      errorPrint(message: 'formData does not contains the key (items) or items is not a List<Map<String, dynamic>>');
      return;
    }
    for (var item in formDataNotifier.data['items']) {
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
    formDataNotifier.updateProperties({'totalAmount': totalAmount});
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formDataNotifier = ref.read(transactionFormDataProvider.notifier);
    final textEditingController = ref.read(textFieldsControllerProvider.notifier);
    final repository = ref.read(productRepositoryProvider);
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        ItemDataCell(isFirst: true, width: sequenceWidth, cell: Text((index + 1).toString())),
        ItemDataCell(
            width: nameWidth,
            cell: DropDownWithSearchFormField(
              initialValue: formDataNotifier.getSubProperty(property: 'items', index: index, subProperty: 'name'),
              hideBorders: true,
              dbRepository: repository,
              onChangedFn: (item) {
                // updates related fields using the item selected (of type Map<String, dynamic>)
                // (1) updates the price of current item
                // (2) updates the weight of current item,
                // (2) update the totalWeight of the form based on all items weight
                // note: totalPrice isn't updated here because it is updated by the price field
                //       which is triggered by the change of field.
                formDataNotifier.updateSubProperties(property: 'items', index: index, subProperties: {
                  'price': item['sellWholePrice'],
                  'weight': item['packageWeight'],
                });
                if (!textEditingController.isValidSubController(fieldName: 'items', subControllerIndex: index)) return;
                textEditingController.data['items'][index].text =
                    formDataNotifier.data['items'][index]['price'].toString();
                updateTotalWeight(formDataNotifier);
                if (!formDataNotifier.isValidProperty(property: 'totalWeight')) {
                  errorPrint(message: 'formData[totalWeight] is not valid');
                  return;
                }
                textEditingController.data['totalWeight'].text = formDataNotifier.data['totalWeight'].toString();
              },
            )),
        ItemDataCell(
          width: priceWidth,
          cell: FormInputField(
            controller: textEditingController.data['items'][index],
            isRequired: false,
            hideBorders: true,
            dataType: constants.FieldDataTypes.double,
            name: 'price',
            onChangedFn: (value) {
              // this method is executed throught two ways, first when the field is updated by the user
              // and the second is automatic when user selects and item through adjacent product selection dropdown
              formDataNotifier.updateSubProperties(property: 'items', index: index, subProperties: {'price': value});
              updateTotalAmount(formDataNotifier);
              if (!formDataNotifier.isValidProperty(property: 'totalAmount')) {
                errorPrint(message: 'formData[totalAmount] is not valid');
                return;
              }
              textEditingController.data['totalAmount'].text = formDataNotifier.data['totalAmount'].toString();
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
