import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tablets/src/common/values/constants.dart';
import 'package:tablets/src/common/widgets/form_fields/edit_box.dart';
import 'package:tablets/src/features/transactions/controllers/transaction_form_controller.dart';

class TransactionFormInputField extends ConsumerWidget {
  const TransactionFormInputField({
    required this.dataType,
    required this.property,
    this.label,
    this.isRequired = true,
    this.hideBorders = false,
    this.subProperty,
    this.subPropertyIndex,
    this.controller,
    this.isReadOnly = false,
    this.updateReletedFieldsFn,
    super.key,
  });

  final FieldDataTypes dataType;
  final String property;
  final String? label;
  final bool isRequired;
  final bool hideBorders;
  final int? subPropertyIndex;
  final String? subProperty;
  final bool isReadOnly;
  final TextEditingController? controller;
  final VoidCallback? updateReletedFieldsFn;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formController = ref.read(transactionFormDataProvider.notifier);
    final formData = formController.data;
    return FormInputField(
        updateReletedFieldsFn: updateReletedFieldsFn,
        isReadOnly: isReadOnly,
        controller: controller,
        hideBorders: hideBorders,
        isRequired: isRequired,
        formData: formData,
        onChangedFn: formController.update,
        dataType: dataType,
        property: property,
        subProperty: subProperty,
        subPropertyIndex: subPropertyIndex,
        label: label);
  }
}
