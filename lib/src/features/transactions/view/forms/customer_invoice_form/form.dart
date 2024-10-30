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
import 'package:tablets/src/features/customers/repository/customer_repository_provider.dart';
import 'package:tablets/src/features/salesmen/repository/salesman_repository_provider.dart';
import 'package:tablets/src/features/transactions/controllers/transaction_form_controller.dart';
import 'package:tablets/src/features/transactions/view/forms/customer_invoice_form/item_list.dart';
import 'package:tablets/src/common/widgets/form_title.dart';
import 'package:tablets/src/features/transactions/view/forms/text_input_field.dart';

class CustomerInvoiceForm extends ConsumerWidget {
  const CustomerInvoiceForm({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formController = ref.read(transactionFormDataProvider.notifier);
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
              initialValue: formController.getProperty(property: 'counterParty'),
              dbRepository: customerRepository,
              onChangedFn: (item) {
                formController.updateProperties({'counterParty': item['name']});
                // update related property
                formController.updateProperties({'salesman': item['salesman']});
              },
            ),
            gaps.HorizontalGap.formFieldToField,
            DropDownWithSearchFormField(
              label: S.of(context).transaction_salesman,
              initialValue: formController.getProperty(property: 'salesman'),
              dbRepository: salesmanRepository,
              onChangedFn: (item) {
                formController.updateProperties({'counterParty': item['name']});
              },
            ),
          ],
        ),
        gaps.VerticalGap.formFieldToField,
        Row(
          children: [
            DropDownListFormField(
              initialValue: formController.getProperty(property: 'currency'),
              itemList: [
                S.of(context).transaction_payment_Dinar,
                S.of(context).transaction_payment_Dollar,
              ],
              label: S.of(context).transaction_currency,
              name: 'currency',
              onChangedFn: (value) {
                formController.updateProperties({'currency': value});
              },
            ),
            gaps.HorizontalGap.formFieldToField,
            TransactionFormInputField(
              dataType: constants.FieldDataTypes.double,
              property: 'discount',
              label: S.of(context).transaction_discount,
            ),
          ],
        ),
        gaps.VerticalGap.formFieldToField,
        Row(
          children: [
            TransactionFormInputField(
              dataType: constants.FieldDataTypes.int,
              property: 'number',
              label: S.of(context).transaction_number,
            ),
            gaps.HorizontalGap.formFieldToField,
            DropDownListFormField(
              initialValue: formController.getProperty(property: 'paymentType'),
              itemList: [
                S.of(context).transaction_payment_cash,
                S.of(context).transaction_payment_credit,
              ],
              label: S.of(context).transaction_payment_type,
              name: 'paymentType',
              onChangedFn: (value) {
                formController.updateProperties({'paymentType': value});
              },
            ),
            gaps.HorizontalGap.formFieldToField,
            FormDatePickerField(
              initialValue: formController.getProperty(property: 'date'),
              name: 'date',
              label: S.of(context).transaction_date,
              onChangedFn: (date) {
                formController.updateProperties({'date': date!});
              },
            ),
          ],
        ),
        gaps.VerticalGap.formFieldToField,
        Row(
          children: [
            TransactionFormInputField(
              isRequired: false,
              dataType: constants.FieldDataTypes.string,
              property: 'notes',
              label: S.of(context).transaction_notes,
            ),
          ],
        ),
        gaps.VerticalGap.formFieldToField,
        Row(
          children: [
            Visibility(
              visible: settings.writeTotalAmountAsText,
              child: TransactionFormInputField(
                isRequired: false,
                dataType: constants.FieldDataTypes.string,
                property: 'totalAsText',
                label: S.of(context).transaction_total_amount_as_text,
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
              TransactionFormInputField(
                controller: textEditingControllers['totalAmount'],
                isReadOnly: true,
                dataType: constants.FieldDataTypes.double,
                label: S.of(context).invoice_total_price,
                property: 'totalAmount',
              ),
              gaps.HorizontalGap.formFieldToField,
              TransactionFormInputField(
                controller: textEditingControllers['totalWeight'],
                isReadOnly: true,
                dataType: constants.FieldDataTypes.double,
                label: S.of(context).invoice_total_weight,
                property: 'totalWeight',
              ),
            ],
          ),
        ),
      ],
    );
  }
}
