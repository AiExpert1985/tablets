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
const String totalAmountKey = 'totalAmount';
const String totalWeightKey = 'totalWeight';
const String itemsKey = 'items';
const String weightKey = 'weight';
const String priceKey = 'price';

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
          Stack(children: [
            _buildColumnTitles(context),
            Positioned(
                top: 0,
                right: 0,
                child: _buildAddItemButton(formDataNotifier, textEditingNotifier)),
          ]),
          ..._buildRows(formDataNotifier, textEditingNotifier, productRepository),
        ],
      ),
    ),
  );
}

List<Widget> _buildRows(ItemFormData formDataNotifier, TextControllerNotifier textEditingNotifier,
    DbRepository productRepository) {
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
        _buildDeleteItemButton(formDataNotifier, textEditingNotifier, index),
        _buildDropDownWithSearch(formDataNotifier, textEditingNotifier, productRepository, index),
        _buildFormInputField(formDataNotifier, textEditingNotifier, index),
        buildDataCell(soldQuantityColumnWidth, const Text('TempText')),
        buildDataCell(giftQuantityColumnWidth, const Text('tempText')),
        buildDataCell(soldTotalAmountColumnWidth, const Text('tempText'), isLast: true),
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

Widget _buildDeleteItemButton(
    ItemFormData formDataNotifier, TextControllerNotifier textEditingNotifier, int index) {
  return IconButton(
    onPressed: () {
      formDataNotifier.removeSubProperties(itemsKey, index);
      textEditingNotifier.removeControllerFromList(itemsKey, index);
      _updateTotal(formDataNotifier, totalAmountKey, priceKey);
      _updateTotal(formDataNotifier, totalWeightKey, weightKey);
      textEditingNotifier.data[totalAmountKey].text =
          formDataNotifier.data[totalAmountKey].toString();
      textEditingNotifier.data[totalWeightKey].text =
          formDataNotifier.data[totalWeightKey].toString();
    },
    icon: const Icon(Icons.cancel, color: Colors.red),
  );
}

Widget _buildColumnTitles(BuildContext context) {
  final titles = [
    '',
    S.of(context).item_name,
    S.of(context).item_price,
    S.of(context).item_sold_quantity,
    S.of(context).item_gifts_quantity,
    S.of(context).item_total_price,
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
            Text(titles[index]),
            isTitle: true,
            isFirst: index == 0,
            isLast: index == titles.length - 1,
          );
        })
      ]);
}

void _updateTotal(ItemFormData formDataNotifier, String key, String valueKey) {
  double total = 0;
  if (!formDataNotifier.data.containsKey(key) ||
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

Widget _buildDropDownWithSearch(ItemFormData formDataNotifier,
    TextControllerNotifier textEditingController, dynamic repository, index) {
  return buildDataCell(
    nameColumnWidth,
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
        _updateTotal(formDataNotifier, totalWeightKey, weightKey);
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
    ItemFormData formDataNotifier, TextControllerNotifier textEditingNotifier, int index) {
  return buildDataCell(
    priceColumnWidth,
    FormInputField(
      initialValue: formDataNotifier.getSubProperty(itemsKey, index, priceKey),
      controller: textEditingNotifier.data[itemsKey][index],
      isRequired: false,
      hideBorders: true,
      dataType: constants.FieldDataType.num,
      name: priceKey,
      onChangedFn: (value) {
        // this method is executed throught two ways, first when the field is updated by the user
        // and the second is automatic when user selects and item through adjacent product selection dropdown
        formDataNotifier.updateSubProperties(itemsKey, {priceKey: value}, index: index);
        _updateTotal(formDataNotifier, totalAmountKey, priceKey);
        if (!formDataNotifier.isValidProperty(totalAmountKey)) {
          errorPrint('formData[$totalAmountKey] is not valid');
          return;
        }
        textEditingNotifier.data[totalAmountKey].text =
            formDataNotifier.data[totalAmountKey].toString();
      },
    ),
  );
}
