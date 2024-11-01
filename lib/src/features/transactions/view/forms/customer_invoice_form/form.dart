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
              initialValue: formDataNotifier.getProperty('name'),
              dbRepository: customerRepository,
              onChangedFn: (item) {
                formDataNotifier.updateProperties({'name': item['name']});
                // update related property
                formDataNotifier.updateProperties({'salesman': item['salesman']});
              },
            ),
            gaps.HorizontalGap.formFieldToField,
            DropDownWithSearchFormField(
              label: S.of(context).transaction_salesman,
              initialValue: formDataNotifier.getProperty('salesman'),
              dbRepository: salesmanRepository,
              onChangedFn: (item) {
                formDataNotifier.updateProperties({'salesman': item['name']});
              },
            ),
          ],
        ),
        gaps.VerticalGap.formFieldToField,
        Row(
          children: [
            DropDownListFormField(
              initialValue: formDataNotifier.getProperty('currency'),
              itemList: [
                S.of(context).transaction_payment_Dinar,
                S.of(context).transaction_payment_Dollar,
              ],
              label: S.of(context).transaction_currency,
              name: 'currency',
              onChangedFn: (value) {
                formDataNotifier.updateProperties({'currency': value});
              },
            ),
            gaps.HorizontalGap.formFieldToField,
            FormInputField(
              initialValue: formDataNotifier.getProperty('discount'),
              name: 'discount',
              dataType: constants.FieldDataType.num,
              label: S.of(context).transaction_discount,
              onChangedFn: (value) {
                formDataNotifier.updateProperties({'discount': value});
              },
            ),
          ],
        ),
        gaps.VerticalGap.formFieldToField,
        Row(
          children: [
            FormInputField(
              dataType: constants.FieldDataType.num,
              name: 'number',
              label: S.of(context).transaction_number,
              initialValue: formDataNotifier.getProperty('number'),
              onChangedFn: (value) {
                formDataNotifier.updateProperties({'number': value});
              },
            ),
            gaps.HorizontalGap.formFieldToField,
            DropDownListFormField(
              initialValue: formDataNotifier.getProperty('paymentType'),
              itemList: [
                S.of(context).transaction_payment_cash,
                S.of(context).transaction_payment_credit,
              ],
              label: S.of(context).transaction_payment_type,
              name: 'paymentType',
              onChangedFn: (value) {
                formDataNotifier.updateProperties({'paymentType': value});
              },
            ),
            gaps.HorizontalGap.formFieldToField,
            FormDatePickerField(
              initialValue: formDataNotifier.getProperty('date') is Timestamp
                  ? formDataNotifier.getProperty('date').toDate()
                  : formDataNotifier.getProperty('date'),
              name: 'date',
              label: S.of(context).transaction_date,
              onChangedFn: (date) {
                formDataNotifier.updateProperties({'date': Timestamp.fromDate(date!)});
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
              name: 'notes',
              label: S.of(context).transaction_notes,
              initialValue: formDataNotifier.getProperty('notes'),
              onChangedFn: (value) {
                formDataNotifier.updateProperties({'notes': value});
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
                name: 'totalAsText',
                label: S.of(context).transaction_total_amount_as_text,
                initialValue: formDataNotifier.getProperty('totalAsText'),
                onChangedFn: (value) {
                  formDataNotifier.updateProperties({'totalAsText': value});
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
                controller: textEditingControllers['totalAmount'],
                isReadOnly: true,
                dataType: constants.FieldDataType.num,
                label: S.of(context).invoice_total_price,
                name: 'totalAmount',
                initialValue: formDataNotifier.getProperty('totalAmount'),
                onChangedFn: (value) {
                  formDataNotifier.updateProperties({'totalAmount': value});
                },
              ),
              gaps.HorizontalGap.formFieldToField,
              FormInputField(
                controller: textEditingControllers['totalWeight'],
                isReadOnly: true,
                dataType: constants.FieldDataType.num,
                label: S.of(context).invoice_total_weight,
                name: 'totalWeight',
                initialValue: formDataNotifier.getProperty('totalWeight'),
                onChangedFn: (value) {
                  formDataNotifier.updateProperties({'totalWeight': value});
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}
