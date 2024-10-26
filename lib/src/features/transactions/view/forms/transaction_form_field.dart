import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tablets/src/common/values/constants.dart';
import 'package:tablets/src/common/widgets/form_fields/edit_box.dart';
import 'package:tablets/src/features/transactions/controllers/transaction_form_controller.dart';

class TransactionFormInputField extends ConsumerWidget {
  const TransactionFormInputField({
    required this.dataType,
    required this.name,
    required this.displayedTitle,
    this.isRequired = true,
    super.key,
  });

  final FieldDataTypes dataType;
  final String name;
  final String displayedTitle;
  final bool isRequired;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final transactionFormController = ref.watch(transactionFormDataProvider.notifier);
    final formData = transactionFormController.data;
    return FormInputField(
        isRequired: isRequired,
        formData: formData,
        onChangedFn: transactionFormController.update,
        dataType: dataType,
        fieldName: name,
        label: displayedTitle);
  }
}
