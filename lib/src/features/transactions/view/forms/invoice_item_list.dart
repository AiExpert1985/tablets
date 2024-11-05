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
import 'package:tablets/src/features/transactions/view/forms/common_values.dart';

const double sequenceColumnWidth = customerInvoiceFormWidth * 0.055;
const double nameColumnWidth = customerInvoiceFormWidth * 0.345;
const double priceColumnWidth = customerInvoiceFormWidth * 0.16;
const double soldQuantityColumnWidth = customerInvoiceFormWidth * 0.1;
const double giftQuantityColumnWidth = customerInvoiceFormWidth * 0.1;
const double soldTotalAmountColumnWidth = customerInvoiceFormWidth * 0.17;

Widget buildItemList(BuildContext context, ItemFormData formDataNotifier,
    TextControllerNotifier textEditingNotifier, DbRepository productRepository, bool includeGift) {
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
          _buildColumnTitles(context, formDataNotifier, textEditingNotifier, includeGift),
          ..._buildDataRows(formDataNotifier, textEditingNotifier, productRepository, includeGift),
        ],
      ),
    ),
  );
}

List<Widget> _buildDataRows(ItemFormData formDataNotifier,
    TextControllerNotifier textEditingNotifier, DbRepository productRepository, bool includeGift) {
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
      children: includeGift
          ? [
              // buildDataCell(sequenceColumnWidth, Text((index + 1).toString()), isFirst: true),
              _buildDeleteItemButton(
                  formDataNotifier, textEditingNotifier, index, sequenceColumnWidth,
                  isFirst: true),
              _buildDropDownWithSearch(
                  formDataNotifier, textEditingNotifier, productRepository, index, nameColumnWidth),
              _buildFormInputField(formDataNotifier, index, priceColumnWidth, itemsKey,
                  itemPriceKey, textEditingNotifier),
              _buildFormInputField(formDataNotifier, index, soldQuantityColumnWidth, itemsKey,
                  itemSoldQuantityKey, textEditingNotifier),
              _buildFormInputField(formDataNotifier, index, giftQuantityColumnWidth, itemsKey,
                  itemGiftQuantityKey, textEditingNotifier),
              _buildFormInputField(formDataNotifier, index, soldTotalAmountColumnWidth, itemsKey,
                  itemTotalAmountKey, textEditingNotifier,
                  // textEditingNotifier: textEditingNotifier,
                  isLast: true,
                  isReadOnly: true),
            ]
          : [
              // buildDataCell(sequenceColumnWidth, Text((index + 1).toString()), isFirst: true),
              _buildDeleteItemButton(
                  formDataNotifier, textEditingNotifier, index, sequenceColumnWidth,
                  isFirst: true),
              _buildDropDownWithSearch(
                  formDataNotifier, textEditingNotifier, productRepository, index, nameColumnWidth),
              _buildFormInputField(formDataNotifier, index, priceColumnWidth, itemsKey,
                  itemPriceKey, textEditingNotifier),
              _buildFormInputField(formDataNotifier, index, soldQuantityColumnWidth, itemsKey,
                  itemSoldQuantityKey, textEditingNotifier),
              _buildFormInputField(formDataNotifier, index, soldTotalAmountColumnWidth, itemsKey,
                  itemTotalAmountKey, textEditingNotifier,
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
      formDataNotifier.updateSubProperties(itemsKey, emptyInvoiceItem);
      textEditingNotifier.updateSubControllers(itemsKey, {
        itemPriceKey: 0,
        itemSoldQuantityKey: 0,
        itemGiftQuantityKey: 0,
        itemTotalAmountKey: 0,
        itemTotalWeightKey: 0
      });
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
          final items = formDataNotifier.getProperty(itemsKey);
          // if there is only one item, it is not deleted, but formData & textEditingData is reseted
          if (items is List && items.length <= 1) {
            formDataNotifier.updateSubProperties(itemsKey, emptyInvoiceItem, index: 0);
          } else {
            formDataNotifier.removeSubProperties(itemsKey, index);
            textEditingNotifier.removeSubController(itemsKey, index, itemPriceKey);
          }
          final totalAmount = _getTotal(formDataNotifier, itemsKey, itemTotalAmountKey);
          final totalWeight = _getTotal(formDataNotifier, itemsKey, itemTotalWeightKey);
          formDataNotifier
              .updateProperties({totalAmountKey: totalAmount, totalWeightKey: totalWeight});
          textEditingNotifier
              .updateControllers({totalAmountKey: totalAmount, totalWeightKey: totalWeight});
        },
        icon: const Icon(Icons.remove, color: Colors.red),
      ),
      isFirst: true);
}

Widget _buildColumnTitles(BuildContext context, ItemFormData formDataNotifier,
    TextControllerNotifier textEditingNotifier, bool includeGift) {
  final titles = includeGift
      ? [
          _buildAddItemButton(formDataNotifier, textEditingNotifier),
          Text(S.of(context).item_name),
          Text(S.of(context).item_price),
          Text(S.of(context).item_sold_quantity),
          Text(S.of(context).item_gifts_quantity),
          Text(S.of(context).item_total_price),
        ]
      : [
          _buildAddItemButton(formDataNotifier, textEditingNotifier),
          Text(S.of(context).item_name),
          Text(S.of(context).item_price),
          Text(S.of(context).item_sold_quantity),
          Text(S.of(context).item_total_price),
        ];

  final widths = includeGift
      ? [
          sequenceColumnWidth,
          nameColumnWidth,
          priceColumnWidth,
          soldQuantityColumnWidth,
          giftQuantityColumnWidth,
          soldTotalAmountColumnWidth,
        ]
      : [
          sequenceColumnWidth,
          nameColumnWidth,
          priceColumnWidth,
          soldQuantityColumnWidth,
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

dynamic _getTotal(ItemFormData formDataNotifier, String property, String subProperty) {
  dynamic total = 0;
  if (!formDataNotifier.isValidProperty(property) ||
      formDataNotifier.getProperty(property) is! List<Map<String, dynamic>>) {
    errorPrint('form property provided is invalid');
    return total;
  }
  final items = formDataNotifier.getProperty(property);
  for (var i = 0; i < items.length; i++) {
    if (!items[i].containsKey(subProperty)) {
      errorPrint('formData[$property][$i][$subProperty] is invalid');
      continue;
    }
    final value = items[i][subProperty];
    if (value is! double && value is! int) {
      errorPrint('$subProperty[$subProperty] is not a nummber');
      continue;
    }
    total += value;
  }
  return total;
}

Widget _buildDropDownWithSearch(ItemFormData formDataNotifier,
    TextControllerNotifier textEditingNotifier, dynamic repository, int index, double width) {
  return buildDataCell(
    width,
    DropDownWithSearchFormField(
      initialValue: formDataNotifier.getSubProperty(itemsKey, index, itemNameKey),
      hideBorders: true,
      dbRepository: repository,
      isRequired: false,
      onChangedFn: (item) {
        // updates related fields using the item selected (of type Map<String, dynamic>)
        // and triger the on changed function in price field using its controller
        final subProperties = {
          itemNameKey: item['name'],
          itemPriceKey: item['sellWholePrice'],
          itemWeightKey: item['packageWeight']
        };
        formDataNotifier.updateSubProperties(itemsKey, subProperties, index: index);
        final price = formDataNotifier.getSubProperty(itemsKey, index, itemPriceKey);
        textEditingNotifier.updateSubControllers(itemsKey, {itemPriceKey: price}, index: index);
      },
    ),
  );
}

Widget _buildFormInputField(ItemFormData formDataNotifier, int index, double width, String property,
    String subProperty, TextControllerNotifier textEditingNotifier,
    {bool isLast = false, isReadOnly = false}) {
  return buildDataCell(
    width,
    FormInputField(
      initialValue: formDataNotifier.getSubProperty(property, index, subProperty),
      controller: textEditingNotifier.getSubController(property, index, subProperty),
      hideBorders: true,
      isRequired: false,
      isReadOnly: isReadOnly,
      dataType: constants.FieldDataType.num,
      name: subProperty,
      onChangedFn: (value) {
        // this method is executed throught two ways, first when the field is updated by the user
        // and the second is automatic when user selects and item through adjacent product selection dropdown
        formDataNotifier.updateSubProperties(property, {subProperty: value}, index: index);
        final price = formDataNotifier.getSubProperty(property, index, itemPriceKey);
        final weight = formDataNotifier.getSubProperty(property, index, itemWeightKey);
        final soldQuantity = formDataNotifier.getSubProperty(property, index, itemSoldQuantityKey);
        if (soldQuantity == null || price == null) {
          return;
        }
        final updatedSubProperties = {
          itemTotalAmountKey: soldQuantity * price,
          itemTotalWeightKey: soldQuantity * weight
        };
        formDataNotifier.updateSubProperties(property, updatedSubProperties, index: index);
        textEditingNotifier.updateSubControllers(property, updatedSubProperties, index: index);
        final subTotalAmount = _getTotal(formDataNotifier, property, itemTotalAmountKey);
        formDataNotifier.updateProperties({subTotalAmountKey: subTotalAmount});
        final itemsTotalWeight = _getTotal(formDataNotifier, property, itemTotalWeightKey);
        final discount = formDataNotifier.getProperty(discountKey);
        final totalAmount = subTotalAmount - discount;
        final updatedProperties = {totalAmountKey: totalAmount, totalWeightKey: itemsTotalWeight};
        formDataNotifier.updateProperties(updatedProperties);
        textEditingNotifier.updateControllers(updatedProperties);
      },
    ),
    isLast: isLast,
  );
}

Widget buildDataCell(width, cell, {height = 45, isTitle = false, isFirst = false, isLast = false}) {
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
