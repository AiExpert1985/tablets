import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tablets/generated/l10n.dart';
import 'package:tablets/src/common/classes/db_repository.dart';
import 'package:tablets/src/common/classes/item_form_data.dart';
import 'package:tablets/src/common/functions/debug_print.dart';
import 'package:tablets/src/common/providers/text_editing_controllers_provider.dart';
import 'package:tablets/src/common/values/form_dimenssions.dart';
import 'package:tablets/src/common/values/settings.dart' as settings;
import 'package:tablets/src/common/widgets/form_fields/date_picker.dart';
import 'package:tablets/src/common/values/constants.dart' as constants;
import 'package:tablets/src/common/values/gaps.dart' as gaps;
import 'package:tablets/src/common/widgets/form_fields/drop_down.dart';
import 'package:tablets/src/common/widgets/form_fields/drop_down_with_search.dart';
import 'package:tablets/src/common/widgets/form_fields/edit_box.dart';
import 'package:tablets/src/features/customers/repository/customer_repository_provider.dart';
import 'package:tablets/src/features/products/repository/product_repository_provider.dart';
import 'package:tablets/src/features/salesmen/repository/salesman_repository_provider.dart';
import 'package:tablets/src/features/transactions/controllers/transaction_form_controller.dart';
import 'package:tablets/src/common/widgets/form_title.dart';
import 'package:tablets/src/features/transactions/view/common/item_cell.dart';

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

class CustomerInvoiceForm extends ConsumerWidget {
  const CustomerInvoiceForm({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formDataNotifier = ref.read(transactionFormDataProvider.notifier);
    final salesmanRepository = ref.read(salesmanRepositoryProvider);
    final customerRepository = ref.read(customerRepositoryProvider);
    final textEditingControllers = ref.read(textFieldsControllerProvider);
    ref.watch(transactionFormDataProvider);

    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          buildFormTitle(S.of(context).transaction_type_customer_invoice),
          gaps.VerticalGap.formFieldToField,
          _buildFirstRow(context, formDataNotifier, customerRepository, salesmanRepository),
          gaps.VerticalGap.formFieldToField,
          _buildSecondRow(context, formDataNotifier),
          gaps.VerticalGap.formFieldToField,
          _buildThirdRow(context, formDataNotifier),
          gaps.VerticalGap.formFieldToField,
          _buildForthRow(context, formDataNotifier),
          gaps.VerticalGap.formFieldToField,
          _buildFifthRow(context, formDataNotifier),
          gaps.VerticalGap.formFieldToField,
          _buildCustomerInvoiceItemList(context, ref),
          gaps.VerticalGap.formFieldToField,
          gaps.VerticalGap.formFieldToField,
          gaps.VerticalGap.formFieldToField,
          gaps.VerticalGap.formFieldToField,
          _buildTotalsRow(context, formDataNotifier, textEditingControllers),
        ],
      ),
    );
  }

  Widget _buildFirstRow(BuildContext context, ItemFormData formDataNotifier, var customerRepository,
      var salesmanRepository) {
    return Row(
      children: [
        DropDownWithSearchFormField(
          label: S.of(context).customer,
          initialValue: formDataNotifier.getProperty(nameKey),
          dbRepository: customerRepository,
          onChangedFn: (item) {
            formDataNotifier.updateProperties({
              nameKey: item[nameKey],
              salesmanKey: item[salesmanKey],
            });
          },
        ),
        gaps.HorizontalGap.formFieldToField,
        DropDownWithSearchFormField(
          label: S.of(context).transaction_salesman,
          initialValue: formDataNotifier.getProperty(salesmanKey),
          dbRepository: salesmanRepository,
          onChangedFn: (item) {
            formDataNotifier.updateProperties({salesmanKey: item[nameKey]});
          },
        ),
      ],
    );
  }

  Widget _buildSecondRow(BuildContext context, ItemFormData formDataNotifier) {
    return Row(
      children: [
        DropDownListFormField(
          initialValue: formDataNotifier.getProperty(currencyKey),
          itemList: [
            S.of(context).transaction_payment_Dinar,
            S.of(context).transaction_payment_Dollar,
          ],
          label: S.of(context).transaction_currency,
          name: currencyKey,
          onChangedFn: (value) {
            formDataNotifier.updateProperties({currencyKey: value});
          },
        ),
        gaps.HorizontalGap.formFieldToField,
        FormInputField(
          initialValue: formDataNotifier.getProperty(discountKey),
          name: discountKey,
          dataType: constants.FieldDataType.num,
          label: S.of(context).transaction_discount,
          onChangedFn: (value) {
            formDataNotifier.updateProperties({discountKey: value});
          },
        ),
      ],
    );
  }

  Widget _buildThirdRow(BuildContext context, ItemFormData formDataNotifier) {
    return Row(
      children: [
        FormInputField(
          dataType: constants.FieldDataType.num,
          name: numberKey,
          label: S.of(context).transaction_number,
          initialValue: formDataNotifier.getProperty(numberKey),
          onChangedFn: (value) {
            formDataNotifier.updateProperties({numberKey: value});
          },
        ),
        gaps.HorizontalGap.formFieldToField,
        DropDownListFormField(
          initialValue: formDataNotifier.getProperty(paymentTypeKey),
          itemList: [
            S.of(context).transaction_payment_cash,
            S.of(context).transaction_payment_credit,
          ],
          label: S.of(context).transaction_payment_type,
          name: paymentTypeKey,
          onChangedFn: (value) {
            formDataNotifier.updateProperties({paymentTypeKey: value});
          },
        ),
        gaps.HorizontalGap.formFieldToField,
        FormDatePickerField(
          initialValue: formDataNotifier.getProperty(dateKey) is Timestamp
              ? formDataNotifier.getProperty(dateKey).toDate()
              : formDataNotifier.getProperty(dateKey),
          name: dateKey,
          label: S.of(context).transaction_date,
          onChangedFn: (date) {
            formDataNotifier.updateProperties({dateKey: Timestamp.fromDate(date!)});
          },
        ),
      ],
    );
  }

  Widget _buildForthRow(BuildContext context, ItemFormData formDataNotifier) {
    return Row(
      children: [
        FormInputField(
          isRequired: false,
          dataType: constants.FieldDataType.string,
          name: notesKey,
          label: S.of(context).transaction_notes,
          initialValue: formDataNotifier.getProperty(notesKey),
          onChangedFn: (value) {
            formDataNotifier.updateProperties({notesKey: value});
          },
        ),
      ],
    );
  }

  Widget _buildFifthRow(BuildContext context, ItemFormData formDataNotifier) {
    return Visibility(
      visible: settings.writeTotalAmountAsText,
      child: Row(
        children: [
          FormInputField(
            isRequired: false,
            dataType: constants.FieldDataType.string,
            name: totalAsTextKey,
            label: S.of(context).transaction_total_amount_as_text,
            initialValue: formDataNotifier.getProperty(totalAsTextKey),
            onChangedFn: (value) {
              formDataNotifier.updateProperties({totalAsTextKey: value});
            },
          ),
        ],
      ),
    );
  }

  Widget _buildTotalsRow(
      BuildContext context, ItemFormData formDataNotifier, var textEditingControllers) {
    return SizedBox(
        width: customerInvoiceFormWidth * 0.6,
        child: Row(
          children: [
            FormInputField(
              controller: textEditingControllers[totalAmountKey],
              isReadOnly: true,
              dataType: constants.FieldDataType.num,
              label: S.of(context).invoice_total_price,
              name: totalAmountKey,
              initialValue: formDataNotifier.getProperty(totalAmountKey),
              onChangedFn: (value) {
                formDataNotifier.updateProperties({totalAmountKey: value});
              },
            ),
            gaps.HorizontalGap.formFieldToField,
            FormInputField(
              controller: textEditingControllers[totalWeightKey],
              isReadOnly: true,
              dataType: constants.FieldDataType.num,
              label: S.of(context).invoice_total_weight,
              name: totalWeightKey,
              initialValue: formDataNotifier.getProperty(totalWeightKey),
              onChangedFn: (value) {
                formDataNotifier.updateProperties({totalWeightKey: value});
              },
            ),
          ],
        ));
  }
}

Widget _buildCustomerInvoiceItemList(BuildContext context, WidgetRef ref) {
  ref.watch(transactionFormDataProvider);
  final formDataNotifier = ref.read(transactionFormDataProvider.notifier);
  final textEditingNotifier = ref.read(textFieldsControllerProvider.notifier);
  final productRepository = ref.read(productRepositoryProvider);

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
            _buildTitles(context),
            Positioned(
              top: 0,
              right: 0,
              child: IconButton(
                onPressed: () {
                  textEditingNotifier.addControllerToList(itemsKey);
                  formDataNotifier.updateSubProperties(itemsKey, {});
                },
                icon: const Icon(Icons.add, color: Colors.green),
              ),
            ),
          ]),
          ..._buildItemRows(formDataNotifier, textEditingNotifier, productRepository),
        ],
      ),
    ),
  );
}

List<Widget> _buildItemRows(ItemFormData formDataNotifier,
    TextControllerNotifier textEditingNotifier, DbRepository productRepository) {
  if (!formDataNotifier.data.containsKey(itemsKey) || formDataNotifier.data[itemsKey] is! List) {
    return const [Center(child: Text('No items added yet'))];
  }
  final items = formDataNotifier.data[itemsKey] as List<Map<String, dynamic>>;
  return List.generate(items.length, (index) {
    if (!textEditingNotifier.data.containsKey(itemsKey) ||
        textEditingNotifier.data[itemsKey]!.length <= index) {
      errorPrint('Warning: Missing TextEditingController for item index: $index');
      return const SizedBox.shrink(); // Return an empty widget if the controller is missing
    }
    return _buildItemsRow(formDataNotifier, textEditingNotifier, productRepository, index);
  });
}

Widget _buildTitles(BuildContext context) {
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

Widget _buildItemsRow(ItemFormData formDataNotifier, TextControllerNotifier textEditingNotifier,
    DbRepository repository, int index) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      buildDataCell(sequenceColumnWidth, Text((index + 1).toString()), isFirst: true),
      _buildDropDownWithSearch(formDataNotifier, textEditingNotifier, repository, index),
      _buildFormInputField(formDataNotifier, textEditingNotifier, index),
      buildDataCell(soldQuantityColumnWidth, const Text('TempText')),
      buildDataCell(giftQuantityColumnWidth, const Text('tempText')),
      buildDataCell(soldTotalAmountColumnWidth, const Text('tempText'), isLast: true),
    ],
  );
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
