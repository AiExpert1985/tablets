import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tablets/generated/l10n.dart';
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
import 'package:tablets/src/features/salesmen/repository/salesman_repository_provider.dart';
import 'package:tablets/src/features/transactions/controllers/transaction_form_controller.dart';
import 'package:tablets/src/features/transactions/view/forms/customer_invoice_form/item_list.dart';
import 'package:tablets/src/common/widgets/form_title.dart';

class CustomerInvoiceForm extends ConsumerWidget {
  const CustomerInvoiceForm({super.key});

  static const String nameKey = 'name';
  static const String salesmanKey = 'salesman';
  static const String currencyKey = 'currency';
  static const String discountKey = 'discount';
  static const String numberKey = 'number';
  static const String paymentTypeKey = 'paymentType';
  static const String dateKey = 'date';
  static const String notesKey = 'notes';
  static const String totalAsTextKey = 'totalAsText';
  static const String totalAmountKey = 'totalAmount';
  static const String totalWeightKey = 'totalWeight';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formDataNotifier = ref.read(transactionFormDataProvider.notifier);
    final salesmanRepository = ref.read(salesmanRepositoryProvider);
    final customerRepository = ref.read(customerRepositoryProvider);
    final textEditingControllers = ref.read(textFieldsControllerProvider);
    ref.watch(transactionFormDataProvider);
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        FormTitle(S.of(context).transaction_type_customer_invoice),
        gaps.VerticalGap.formFieldToField,
        gaps.VerticalGap.formFieldToField,
        Row(
          children: [
            DropDownWithSearchFormField(
              label: S.of(context).customer,
              initialValue: formDataNotifier.getProperty(nameKey),
              dbRepository: customerRepository,
              onChangedFn: (item) {
                formDataNotifier.updateProperties({nameKey: item[nameKey]});
                // update related property
                formDataNotifier.updateProperties({salesmanKey: item[salesmanKey]});
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
        ),
        gaps.VerticalGap.formFieldToField,
        Row(
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
        ),
        gaps.VerticalGap.formFieldToField,
        Row(
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
        ),
        gaps.VerticalGap.formFieldToField,
        Row(
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
        ),
        gaps.VerticalGap.formFieldToField,
        Row(
          children: [
            Visibility(
              visible: settings.writeTotalAmountAsText,
              child: FormInputField(
                isRequired: false,
                dataType: constants.FieldDataType.string,
                name: totalAsTextKey,
                label: S.of(context).transaction_total_amount_as_text,
                initialValue: formDataNotifier.getProperty(totalAsTextKey),
                onChangedFn: (value) {
                  formDataNotifier.updateProperties({totalAsTextKey: value});
                },
              ),
            ),
          ],
        ),
        gaps.VerticalGap.formFieldToField,
        const CustomerInvoiceItemList(),
        gaps.VerticalGap.formFieldToField,
        gaps.VerticalGap.formFieldToField,
        SizedBox(
          width: customerInvoiceFormWidth * 0.6,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
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
          ),
        ),
      ],
    );
  }
}
