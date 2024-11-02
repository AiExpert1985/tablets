import 'package:flutter/material.dart';
import 'package:tablets/generated/l10n.dart';
import 'package:tablets/src/common/classes/db_repository.dart';
import 'package:tablets/src/common/classes/item_form_data.dart';
import 'package:tablets/src/common/functions/debug_print.dart';
import 'package:tablets/src/common/providers/text_editing_controllers_provider.dart';
import 'package:tablets/src/common/values/constants.dart' as constants;
import 'package:tablets/src/common/values/form_dimenssions.dart';
import 'package:tablets/src/common/widgets/form_fields/drop_down_with_search.dart';
import 'package:tablets/src/common/widgets/form_fields/edit_box.dart';
import 'package:tablets/src/features/transactions/view/forms/common_utils/item_cell.dart';

const String nameKey = 'name';
const String salesmanKey = 'salesman';
const String currencyKey = 'currency';
const String discountKey = 'discount';
const String numberKey = 'number';
const String paymentTypeKey = 'paymentType';
const String dateKey = 'date';
const String notesKey = 'notes';
const String totalAsTextKey = 'totalAsText';
const String transactionTotalAmountKey = 'totalAmount';
const String totalWeightKey = 'totalWeight';
const String itemsKey = 'items';
const String weightKey = 'weight';
const String priceKey = 'price';
const String soldQuantityKey = 'soldQuantity';
const String giftQuantityKey = 'giftQuantity';
const String itemTotalAmountKey = 'itemTotalAmount';

const double sequenceColumnWidth = customerInvoiceFormWidth * 0.055;
const double nameColumnWidth = customerInvoiceFormWidth * 0.345;
const double priceColumnWidth = customerInvoiceFormWidth * 0.16;
const double soldQuantityColumnWidth = customerInvoiceFormWidth * 0.1;
const double giftQuantityColumnWidth = customerInvoiceFormWidth * 0.1;
const double soldTotalAmountColumnWidth = customerInvoiceFormWidth * 0.17;

Widget buildItemList(BuildContext context, ItemFormData formDataNotifier,
    TextControllerNotifier textEditingNotifier, DbRepository productRepository) {
  return Container(
    height: 350,
    decoration: BoxDecoration(
      border: Border.all(color: Colors.black38, width: 1.0),
      borderRadius: BorderRadius.circular(8.0),
    ),
    padding: const EdgeInsets.all(12),
    child: SingleChildScrollView(
      child: Column(
        children: [
          _buildColumnTitles(context, formDataNotifier, textEditingNotifier),
          ..._buildDataRows(formDataNotifier, textEditingNotifier, productRepository),
        ],
      ),
    ),
  );
}

List<Widget> _buildDataRows(ItemFormData formDataNotifier,
    TextControllerNotifier textEditingNotifier, DbRepository productRepository) {
  if (!formDataNotifier.data.containsKey(itemsKey) || formDataNotifier.data[itemsKey] is! List) {
    return const [];
  }
  final items = formDataNotifier.data[itemsKey] as List<Map<String, dynamic>>;
  return List.generate(items.length, (index) {
    if (!textEditingNotifier.data.containsKey(itemsKey) ||
        textEditingNotifier.data[itemsKey]!.length <= index) {
      errorPrint('Warning: Missing TextEditingController for item index: $index');
      return const SizedBox.shrink(); // Return an empty widget if the controller is missing
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // buildDataCell(sequenceColumnWidth, Text((index + 1).toString()), isFirst: true),
        _buildDeleteItemButton(formDataNotifier, textEditingNotifier, index, sequenceColumnWidth,
            isFirst: true),
        _buildDropDownWithSearch(
            formDataNotifier, textEditingNotifier, productRepository, index, nameColumnWidth),
        _buildFormInputField(formDataNotifier, index, priceColumnWidth, itemsKey, priceKey,
            textEditingNotifier: textEditingNotifier),
        _buildFormInputField(
            formDataNotifier, index, soldQuantityColumnWidth, itemsKey, soldQuantityKey),
        _buildFormInputField(
            formDataNotifier, index, giftQuantityColumnWidth, itemsKey, giftQuantityKey),
        _buildFormInputField(
            formDataNotifier, index, soldTotalAmountColumnWidth, itemsKey, itemTotalAmountKey,
            // textEditingNotifier: textEditingNotifier,
            isLast: true,
            isReadOnly: true),
      ],
    );
  });
}

Widget _buildAddItemButton(
    ItemFormData formDataNotifier, TextControllerNotifier textEditingNotifier) {
  return IconButton(
    onPressed: () {
      textEditingNotifier.addControllerToList(itemsKey);
      formDataNotifier.updateSubProperties(itemsKey, {});
    },
    icon: const Icon(Icons.add, color: Colors.green),
  );
}

Widget _buildDeleteItemButton(ItemFormData formDataNotifier,
    TextControllerNotifier textEditingNotifier, int index, double width,
    {bool isFirst = false}) {
  return buildDataCell(
      width,
      IconButton(
        onPressed: () {
          formDataNotifier.removeSubProperties(itemsKey, index);
          textEditingNotifier.removeControllerFromList(itemsKey, index);
          _updateTotal(formDataNotifier, itemsKey, priceKey, transactionTotalAmountKey);
          _updateTotal(formDataNotifier, itemsKey, weightKey, totalWeightKey);
          textEditingNotifier.data[transactionTotalAmountKey].text =
              formDataNotifier.data[transactionTotalAmountKey].toString();
          textEditingNotifier.data[totalWeightKey].text =
              formDataNotifier.data[totalWeightKey].toString();
        },
        icon: const Icon(Icons.remove, color: Colors.red),
      ),
      isFirst: true);
}

Widget _buildColumnTitles(BuildContext context, ItemFormData formDataNotifier,
    TextControllerNotifier textEditingNotifier) {
  final titles = [
    _buildAddItemButton(formDataNotifier, textEditingNotifier),
    Text(S.of(context).item_name),
    Text(S.of(context).item_price),
    Text(S.of(context).item_sold_quantity),
    Text(S.of(context).item_gifts_quantity),
    Text(S.of(context).item_total_price),
  ];

  final widths = [
    sequenceColumnWidth,
    nameColumnWidth,
    priceColumnWidth,
    soldQuantityColumnWidth,
    giftQuantityColumnWidth,
    soldTotalAmountColumnWidth,
  ];

  return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        ...List.generate(titles.length, (index) {
          return buildDataCell(
            widths[index],
            titles[index],
            isTitle: true,
            isFirst: index == 0,
            isLast: index == titles.length - 1,
          );
        })
      ]);
}

void _updateTotal(
    ItemFormData formDataNotifier, String property, String subProperty, String targetProperty) {
  double total = 0;
  if (!formDataNotifier.data.containsKey(property) ||
      formDataNotifier.data[property] is! List<Map<String, dynamic>>) {
    errorPrint(
        'formData does not contain the key ($property) or items is not a List<Map<String, dynamic>>');
    return;
  }
  for (var item in formDataNotifier.data[property]) {
    if (!item.containsKey(subProperty)) {
      errorPrint('form[$property] does not contain ($subProperty) key');
      continue;
    }
    final value = item[subProperty];
    if (value is! double) {
      errorPrint('$subProperty[$subProperty] is not of type double');
      continue;
    }
    total += value;
  }
  formDataNotifier.updateProperties({targetProperty: total});
}

Widget _buildDropDownWithSearch(ItemFormData formDataNotifier,
    TextControllerNotifier textEditingController, dynamic repository, int index, double width) {
  return buildDataCell(
    width,
    DropDownWithSearchFormField(
      initialValue: formDataNotifier.getSubProperty(itemsKey, index, nameKey),
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
            itemsKey,
            {
              nameKey: item['name'],
              priceKey: item['sellWholePrice'],
              weightKey: item['packageWeight']
            },
            index: index);
        if (!textEditingController.isValidSubController(itemsKey, index)) return;
        textEditingController.data[itemsKey][index].text =
            formDataNotifier.data[itemsKey][index][priceKey].toString();
        _updateTotal(formDataNotifier, itemsKey, weightKey, totalWeightKey);
        if (!formDataNotifier.isValidProperty(totalWeightKey)) {
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
    ItemFormData formDataNotifier, int index, double width, String property, String subProperty,
    {TextControllerNotifier? textEditingNotifier, bool isLast = false, isReadOnly = false}) {
  return buildDataCell(
    width,
    FormInputField(
      initialValue: formDataNotifier.getSubProperty(property, index, subProperty),
      controller: textEditingNotifier?.data[property][index],
      hideBorders: true,
      isReadOnly: isReadOnly,
      dataType: constants.FieldDataType.num,
      name: subProperty,
      onChangedFn: (value) {
        // this method is executed throught two ways, first when the field is updated by the user
        // and the second is automatic when user selects and item through adjacent product selection dropdown
        formDataNotifier.updateSubProperties(property, {subProperty: value}, index: index);
        tempPrint(formDataNotifier.data);
        // update the item total price if both price & sold quantity has been entered
        final itemPrice = formDataNotifier.getSubProperty(property, index, priceKey);
        final itemQuantity = formDataNotifier.getSubProperty(property, index, soldQuantityKey);
        if (itemPrice != null && itemQuantity != null) {
          final itemTotalAmount = itemQuantity * itemPrice;
          formDataNotifier.updateSubProperties(property, {itemTotalAmountKey: itemTotalAmount},
              index: index);
        }

        if (subProperty != priceKey) return;
        _updateTotal(formDataNotifier, property, subProperty, transactionTotalAmountKey);
        if (!formDataNotifier.isValidProperty(transactionTotalAmountKey)) {
          errorPrint('formData[$transactionTotalAmountKey] is not valid');
          return;
        }
        textEditingNotifier?.data[transactionTotalAmountKey].text =
            formDataNotifier.data[transactionTotalAmountKey].toString();
      },
    ),
    isLast: isLast,
  );
}
