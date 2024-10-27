import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tablets/src/common/values/constants.dart';
import 'package:tablets/src/common/widgets/form_fields/edit_box.dart';
import 'package:tablets/src/features/transactions/controllers/transaction_form_controller.dart';

class TransactionFormInputField extends ConsumerWidget {
  const TransactionFormInputField({
    required this.dataType,
    required this.fieldName,
    this.title,
    this.isRequired = true,
    this.hideBorders = false,
    this.subFieldName,
    this.subItemSequence,
    super.key,
  });

  final FieldDataTypes dataType;
  final String fieldName;
  final String? title;
  final bool isRequired;
  final bool hideBorders;
  final int? subItemSequence;
  final String? subFieldName;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(transactionFormDataProvider);
    final transactionFormController = ref.watch(transactionFormDataProvider.notifier);
    final formData = transactionFormController.data;
    return FormInputField(
        hideBorders: hideBorders,
        isRequired: isRequired,
        formData: formData,
        onChangedFn: transactionFormController.update,
        dataType: dataType,
        fieldName: fieldName,
        subItemProperty: subFieldName,
        subItemSequence: subItemSequence,
        label: title);
  }
}
