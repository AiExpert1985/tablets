import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tablets/generated/l10n.dart';
import 'package:tablets/src/common/functions/utils.dart' as utils;
import 'package:tablets/src/common/values/settings.dart' as settings;
import 'package:tablets/src/common/widgets/form_fields/date_picker.dart';
import 'package:tablets/src/common/values/constants.dart' as constants;
import 'package:tablets/src/common/values/gaps.dart' as gaps;
import 'package:tablets/src/common/widgets/form_fields/drop_down.dart';
import 'package:tablets/src/common/widgets/form_fields/drop_down_with_search.dart';
import 'package:tablets/src/features/customers/repository/customer_repository_provider.dart';
import 'package:tablets/src/features/salesmen/repository/salesman_repository_provider.dart';
import 'package:tablets/src/features/transactions/controllers/transaction_form_controller.dart';
import 'package:tablets/src/features/transactions/view/forms/invoice_item_list.dart';
import 'package:tablets/src/common/widgets/form_title.dart';
import 'package:tablets/src/features/transactions/view/forms/transaction_form_field.dart';
import 'package:tablets/src/common/values/form_dimenssions.dart';

class InvoiceFormFields extends ConsumerWidget {
  const InvoiceFormFields({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formData = ref.watch(transactionFormDataProvider);
    final formDataNotifier = ref.read(transactionFormDataProvider.notifier);
    final salesmanRepository = ref.read(salesmanRepositoryProvider);
    final customerRepository = ref.read(customerRepositoryProvider);
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        FormTitle(S.of(context).transaction_type_customer_invoice),
        gaps.VerticalGap.formFieldToField,
        gaps.VerticalGap.formFieldToField,
        Row(
          children: [
            DropDownWithSearchFormField(
              targetProperties: const {'counterParty': 'name', 'salesman': 'salesman'},
              fieldName: 'counterParty',
              label: S.of(context).customer,
              formData: formData,
              onChangedFn: formDataNotifier.update,
              dbListFetchFn: customerRepository.fetchItemListAsMaps,
            ),
            gaps.HorizontalGap.formFieldToField,
            DropDownWithSearchFormField(
              targetProperties: const {'salesman': 'name'},
              fieldName: 'salesman',
              label: S.of(context).transaction_salesman,
              formData: formData,
              onChangedFn: formDataNotifier.update,
              dbListFetchFn: salesmanRepository.fetchItemListAsMaps,
            ),
          ],
        ),
        gaps.VerticalGap.formFieldToField,
        Row(
          children: [
            TransactionFormInputField(
              dataType: constants.FieldDataTypes.double,
              name: 'amount',
              displayedTitle: S.of(context).transaction_amount,
            ),
            gaps.HorizontalGap.formFieldToField,
            DropDownListFormField(
              onChangedFn: formDataNotifier.update,
              formData: formData,
              itemList: [
                S.of(context).transaction_payment_Dinar,
                S.of(context).transaction_payment_Dollar,
              ],
              label: S.of(context).transaction_currency,
              fieldName: 'currency',
            ),
            gaps.HorizontalGap.formFieldToField,
            TransactionFormInputField(
              dataType: constants.FieldDataTypes.double,
              name: 'discount',
              displayedTitle: S.of(context).transaction_discount,
            ),
          ],
        ),
        gaps.VerticalGap.formFieldToField,
        Row(
          children: [
            TransactionFormInputField(
              dataType: constants.FieldDataTypes.int,
              name: 'number',
              displayedTitle: S.of(context).transaction_number,
            ),
            gaps.HorizontalGap.formFieldToField,
            DropDownListFormField(
              onChangedFn: formDataNotifier.update,
              formData: formData,
              itemList: [
                S.of(context).transaction_payment_cash,
                S.of(context).transaction_payment_credit,
              ],
              label: S.of(context).transaction_payment_type,
              fieldName: 'paymentType',
            ),
            gaps.HorizontalGap.formFieldToField,
            FormDatePickerField(
              onChangedFn: formDataNotifier.update,
              formData: formData,
              fieldName: 'date',
              label: S.of(context).transaction_date,
            ),
          ],
        ),
        gaps.VerticalGap.formFieldToField,
        Row(
          children: [
            TransactionFormInputField(
              isRequired: false,
              dataType: constants.FieldDataTypes.string,
              name: 'notes',
              displayedTitle: S.of(context).transaction_notes,
            ),
          ],
        ),
        gaps.VerticalGap.formFieldToField,
        Row(
          children: [
            Visibility(
              visible: settings.writeTotalPriceAsText,
              child: TransactionFormInputField(
                isRequired: false,
                dataType: constants.FieldDataTypes.string,
                name: 'totalAsText',
                displayedTitle: S.of(context).transaction_total_amount_as_text,
              ),
            ),
          ],
        ),
        gaps.VerticalGap.formFieldToField,
        const InvoiceItemList(),
        gaps.VerticalGap.formFieldToField,
        gaps.VerticalGap.formFieldToField,
        SizedBox(
          width: customerInvoiceFormWidth * 0.6,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: FormBuilderTextField(
                  textAlign: TextAlign.center,
                  initialValue: '12345',
                  name: 'invoiceTotal',
                  readOnly: true,
                  decoration: utils.formFieldDecoration(label: S.of(context).invoice_total_price),
                ),
              ),
              gaps.HorizontalGap.formFieldToField,
              Expanded(
                child: FormBuilderTextField(
                  textAlign: TextAlign.center,
                  initialValue: '12345',
                  name: 'invoiceTotal',
                  readOnly: true,
                  decoration: utils.formFieldDecoration(label: S.of(context).invoice_total_weight),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
