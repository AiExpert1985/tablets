import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tablets/generated/l10n.dart';
import 'package:tablets/src/common/constants/constants.dart';
import 'package:tablets/src/common/widgets/form_field_custom_input.dart';
import 'package:tablets/src/features/customers/controllers/customer_form_controller.dart';

class CustomerFormFields extends StatelessWidget {
  const CustomerFormFields({super.key, this.editMode = false});
  final bool editMode;
  @override
  Widget build(BuildContext context) {
    return CustomerFormInputField(
      dataType: FieldDataTypes.string,
      name: 'name',
      displayedTitle: S.of(context).salesman_name,
    );
  }
}

class CustomerFormInputField extends ConsumerWidget {
  const CustomerFormInputField({
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
    final customerFormController = ref.watch(customerFormDataProvider.notifier);
    final formData = customerFormController.data;
    return FormInputField(
        formData: formData,
        onSaveFn: customerFormController.update,
        dataType: dataType,
        name: name,
        displayedTitle: displayedTitle);
  }
}
