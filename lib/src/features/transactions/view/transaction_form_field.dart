import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tablets/src/common/constants/constants.dart';
import 'package:tablets/src/common/widgets/form_input_field.dart';
import 'package:tablets/src/features/transactions/controllers/transaction_form_controller.dart';

class TransactionFormInputField extends ConsumerWidget {
  const TransactionFormInputField({
    required this.dataType,
    required this.name,
    required this.displayedTitle,
    super.key,
  });

  final FieldDataTypes dataType;
  final String name;
  final String displayedTitle;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final transactionFormController = ref.watch(transactionFormDataProvider.notifier);
    final formData = transactionFormController.data;
    return FormInputField(
        formData: formData,
        formDataUpdateFn: transactionFormController.update,
        dataType: dataType,
        name: name,
        displayedTitle: displayedTitle);
  }
}
