import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tablets/src/common/providers/text_editing_controllers_provider.dart';
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
    super.key,
  });

  final FieldDataTypes dataType;
  final String property;
  final String? label;
  final bool isRequired;
  final bool hideBorders;
  final int? subPropertyIndex;
  final String? subProperty;
  final TextEditingController? controller;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // I added the watching here to make sure that this widget is directly when a controller is updated,
    // this enusre that it is updated before its parent
    // this to solve the issue when giving a text input field a value automatically by an adjacent dropdown field
    ref.watch(textEditingControllerListProvider);
    final formController = ref.read(transactionFormDataProvider.notifier);
    final formData = formController.data;
    return FormInputField(
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
