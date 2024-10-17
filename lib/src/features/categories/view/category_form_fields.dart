import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tablets/generated/l10n.dart';
import 'package:tablets/src/common/constants/constants.dart';
import 'package:tablets/src/common/widgets/form_input_field.dart';
import 'package:tablets/src/features/categories/controllers/category_form_fields_data_provider.dart';

class CategoryFormFields extends ConsumerWidget {
  const CategoryFormFields({super.key, this.editMode = false});
  final bool editMode;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(categoryFormFieldsDataProvider);
    final categoryFormController = ref.watch(categoryFormFieldsDataProvider.notifier);
    dynamic initialValue = categoryFormController.getState()['name'];
    if (initialValue != null) {
      initialValue = initialValue is String ? initialValue : initialValue.toString();
    }
    return FormInputField(
      formDataUpdateFn: categoryFormController.update,
      initialValue: initialValue,
      dataType: FieldDataTypes.string,
      name: 'name',
      displayedTitle: S.of(context).product_name,
    );
  }
}
