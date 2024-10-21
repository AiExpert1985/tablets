import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tablets/generated/l10n.dart';
import 'package:tablets/src/common/widgets/form_field_date_picker.dart';
import 'package:tablets/src/common/constants/constants.dart';
import 'package:tablets/src/common/constants/gaps.dart' as gaps;
import 'package:tablets/src/common/widgets/form_field_drop_down_list.dart';
import 'package:tablets/src/features/transactions/controllers/transaction_form_controller.dart';
import 'package:tablets/src/features/transactions/view/transaction_form_field.dart';

class InvoiceFormFields extends ConsumerWidget {
  const InvoiceFormFields({super.key, this.editMode = false});
  final bool editMode;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formData = ref.watch(transactionFormDataProvider);
    final formDataNotifier = ref.read(transactionFormDataProvider.notifier);
    return Column(
      children: [
        Row(
          children: [
            TransactionFormInputField(
              dataType: FieldDataTypes.string,
              name: 'counterParty',
              displayedTitle: S.of(context).transaction_counterParty,
            ),
            gaps.HorizontalGap.formFieldToField,
            FormDatePickerField(
              onSaveFn: formDataNotifier.update,
              formData: formData,
            ),
          ],
        ),
        gaps.VerticalGap.formFieldToField,
        Row(
          children: [
            TransactionFormInputField(
              dataType: FieldDataTypes.double,
              name: 'amount',
              displayedTitle: S.of(context).transaction_amount,
            ),
            gaps.HorizontalGap.formFieldToField,
            DropDownListFormField(
              onSaveFn: formDataNotifier.update,
              formData: formData,
              itemList: [
                S.of(context).transaction_payment_Dinar,
                S.of(context).transaction_payment_Dollar,
              ],
              label: S.of(context).transaction_currency,
              name: 'currency',
            ),
            gaps.HorizontalGap.formFieldToField,
            TransactionFormInputField(
              dataType: FieldDataTypes.double,
              name: 'discount',
              displayedTitle: S.of(context).transaction_discount,
            ),
          ],
        ),
        gaps.VerticalGap.formFieldToField,
        Row(
          children: [
            TransactionFormInputField(
              dataType: FieldDataTypes.int,
              name: 'number',
              displayedTitle: S.of(context).transaction_number,
            ),
            gaps.HorizontalGap.formFieldToField,
            DropDownListFormField(
              onSaveFn: formDataNotifier.update,
              formData: formData,
              itemList: [
                S.of(context).transaction_payment_cash,
                S.of(context).transaction_payment_credit,
              ],
              label: S.of(context).transaction_payment_type,
              name: 'paymentType',
            ),
            gaps.HorizontalGap.formFieldToField,
            TransactionFormInputField(
              dataType: FieldDataTypes.string,
              name: 'salesman',
              displayedTitle: S.of(context).transaction_salesman,
            ),
          ],
        ),
        gaps.VerticalGap.formFieldToField,
        Row(
          children: [
            TransactionFormInputField(
              dataType: FieldDataTypes.string,
              name: 'notes',
              displayedTitle: S.of(context).transaction_notes,
            ),
          ],
        ),
      ],
    );
  }
}
