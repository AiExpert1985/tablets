import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tablets/src/common/classes/item_form_data.dart';
import 'package:tablets/src/common/functions/debug_print.dart';
import 'package:tablets/src/common/providers/text_editing_controllers_provider.dart';
import 'package:tablets/src/common/widgets/form_fields/drop_down_with_search.dart';
import 'package:tablets/src/common/widgets/form_fields/edit_box.dart';
import 'package:tablets/src/features/products/repository/product_repository_provider.dart';
import 'package:tablets/src/features/transactions/controllers/transaction_form_controller.dart';
import 'package:tablets/src/features/transactions/view/common/customer_invoice_widths.dart';
import 'package:tablets/src/features/transactions/view/common/item_cell.dart';
import 'package:tablets/src/common/values/constants.dart' as constants;

class CustomerInvoiceItemDataRow extends ConsumerWidget {
  const CustomerInvoiceItemDataRow(this.index, {super.key});

  final int index;

  static const String itemsKey = 'items';
  static const String weightKey = 'weight';
  static const String priceKey = 'price';
  static const String totalWeightKey = 'totalWeight';
  static const String totalAmountKey = 'totalAmount';

  void _updateTotal(ItemFormData formDataNotifier, String key, String valueKey) {
    double total = 0;
    if (!formDataNotifier.data.containsKey(itemsKey) ||
        formDataNotifier.data[itemsKey] is! List<Map<String, dynamic>>) {
      errorPrint(
          'formData does not contain the key ($itemsKey) or items is not a List<Map<String, dynamic>>');
      return;
    }
    for (var item in formDataNotifier.data[itemsKey]) {
      if (!item.containsKey(valueKey)) {
        errorPrint('form[$itemsKey] does not contain ($valueKey) key');
        continue;
      }
      final value = item[valueKey];
      if (value is! double) {
        errorPrint('formData[$itemsKey][i][$valueKey] is not of type double');
        continue;
      }
      total += value;
    }
    formDataNotifier.updateProperties({key: total});
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
        _buildItemDataCell((index + 1).toString(), true, CustomerInvoiceWidths.sequence),
        _buildDropDownWithSearch(formDataNotifier, textEditingController, repository),
        _buildFormInputField(formDataNotifier, textEditingController),
        const ItemDataCell(width: CustomerInvoiceWidths.soldQuantity, cell: Text('TempText')),
        const ItemDataCell(width: CustomerInvoiceWidths.giftQuantity, cell: Text('tempText')),
        const ItemDataCell(
            isLast: true, width: CustomerInvoiceWidths.soldTotalAmount, cell: Text('tempText')),
      ],
    );
  }

  ItemDataCell _buildItemDataCell(String text, bool isFirst, double width) {
    return ItemDataCell(isFirst: isFirst, width: width, cell: Text(text));
  }

  Widget _buildDropDownWithSearch(ItemFormData formDataNotifier,
      TextControllerNotifier textEditingController, dynamic repository) {
    return ItemDataCell(
      width: CustomerInvoiceWidths.name,
      cell: DropDownWithSearchFormField(
        initialValue:
            formDataNotifier.getSubProperty(property: itemsKey, index: index, subProperty: 'name'),
        hideBorders: true,
        dbRepository: repository,
        onChangedFn: (item) {
          // updates related fields using the item selected (of type Map<String, dynamic>)
          // (1) updates the price of current item
          // (2) updates the weight of current item,
          // (3) update the totalWeight of the form based on all items weight
          // note: totalPrice isn't updated here because it is updated by the price field
          //       which is triggered by the change of field.
          formDataNotifier.updateSubProperties(
              itemsKey, {priceKey: item['sellWholePrice'], weightKey: item['packageWeight']},
              index: index);
          if (!textEditingController.isValidSubController(itemsKey, index)) return;
          textEditingController.data[itemsKey][index].text =
              formDataNotifier.data[itemsKey][index][priceKey].toString();
          _updateTotal(formDataNotifier, totalWeightKey, weightKey);
          if (!formDataNotifier.isValidProperty(property: totalWeightKey)) {
            errorPrint('formData[$totalWeightKey] is not valid');
            return;
          }
          textEditingController.data[totalWeightKey].text =
              formDataNotifier.data[totalWeightKey].toString();
        },
      ),
    );
  }

  Widget _buildFormInputField(
      ItemFormData formDataNotifier, TextControllerNotifier textEditingController) {
    return ItemDataCell(
      width: CustomerInvoiceWidths.price,
      cell: FormInputField(
        initialValue: formDataNotifier.getSubProperty(
            property: itemsKey, index: index, subProperty: priceKey),
        controller: textEditingController.data[itemsKey][index],
        isRequired: false,
        hideBorders: true,
        dataType: constants.FieldDataType.num,
        name: priceKey,
        onChangedFn: (value) {
          // this method is executed throught two ways, first when the field is updated by the user
          // and the second is automatic when user selects and item through adjacent product selection dropdown
          formDataNotifier.updateSubProperties(itemsKey, {priceKey: value}, index: index);
          _updateTotal(formDataNotifier, totalAmountKey, priceKey);
          if (!formDataNotifier.isValidProperty(property: totalAmountKey)) {
            errorPrint('formData[$totalAmountKey] is not valid');
            return;
          }
          textEditingController.data[totalAmountKey].text =
              formDataNotifier.data[totalAmountKey].toString();
        },
      ),
    );
  }
}
