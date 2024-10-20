import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tablets/generated/l10n.dart';
import 'package:tablets/src/features/categories/repository/category_repository_provider.dart';
import 'package:tablets/src/common/constants/constants.dart';
import 'package:tablets/src/common/constants/gaps.dart' as gaps;
import 'package:tablets/src/features/transactions/controllers/transaction_form_controller.dart';
import 'package:tablets/src/features/transactions/view/transaction_form_field.dart';

class InvoiceFormFields extends ConsumerWidget {
  const InvoiceFormFields({super.key, this.editMode = false});
  final bool editMode;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formData = ref.watch(transactionFormDataProvider);
    final formDataNotifier = ref.read(transactionFormDataProvider.notifier);
    final categoryRepository = ref.read(categoryRepositoryProvider);
    return Column(
      children: [
        Row(
          children: [
            TransactionFormInputField(
              dataType: FieldDataTypes.int,
              name: 'number',
              displayedTitle: S.of(context).transaction_number,
            ),
            gaps.HorizontalGap.formFieldToField,
            TransactionFormInputField(
              dataType: FieldDataTypes.string,
              name: 'name',
              displayedTitle: S.of(context).transaction_name,
            ),
            gaps.HorizontalGap.formFieldToField,
            // DropDownFormField(
            //   title: S.of(context).category_selection,
            //   formData: formData,
            //   formDataUpdateFn: formDataNotifier.update,
            //   dbItemFetchFn: categoryRepository.fetchItemAsMap,
            //   dbListFetchFn: categoryRepository.fetchItemListAsMaps,
            // ),
            TransactionFormInputField(
              dataType: FieldDataTypes.datetime,
              name: 'date',
              displayedTitle: S.of(context).transaction_date,
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
            TransactionFormInputField(
              dataType: FieldDataTypes.string,
              name: 'currency',
              displayedTitle: S.of(context).transaction_currency,
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
              dataType: FieldDataTypes.string,
              name: 'counterParty',
              displayedTitle: S.of(context).transaction_counterParty,
            ),
            gaps.HorizontalGap.formFieldToField,
            TransactionFormInputField(
              dataType: FieldDataTypes.string,
              name: 'paymentType',
              displayedTitle: S.of(context).transaction_payment_type,
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
        )
      ],
    );
  }
}
