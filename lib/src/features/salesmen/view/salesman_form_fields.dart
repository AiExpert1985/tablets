import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tablets/generated/l10n.dart';
import 'package:tablets/src/common/values/constants.dart';
import 'package:tablets/src/common/widgets/form_fields/edit_box.dart';
import 'package:tablets/src/features/salesmen/controllers/salesman_form_controller.dart';

class SalesmanFormFields extends StatelessWidget {
  const SalesmanFormFields({super.key, this.editMode = false});
  final bool editMode;
  @override
  Widget build(BuildContext context) {
    return SalesmanFormInputField(
      dataType: FieldDataTypes.string,
      name: 'name',
      displayedTitle: S.of(context).salesman_name,
    );
  }
}

class SalesmanFormInputField extends ConsumerWidget {
  const SalesmanFormInputField({
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
    final salesmanFormController = ref.watch(salesmanFormDataProvider.notifier);
    final formData = salesmanFormController.data;
    return FormInputField(
        formData: formData,
        onChangedFn: salesmanFormController.updateProperty,
        dataType: dataType,
        property: name,
        label: displayedTitle);
  }
}
