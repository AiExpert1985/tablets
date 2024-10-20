import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tablets/generated/l10n.dart';
import 'package:tablets/src/common/constants/constants.dart';
import 'package:tablets/src/common/widgets/form_field_custom_input.dart';
import 'package:tablets/src/features/categories/controllers/category_form_controller.dart';

class CategoryFormFields extends StatelessWidget {
  const CategoryFormFields({super.key, this.editMode = false});
  final bool editMode;
  @override
  Widget build(BuildContext context) {
    return CategoryFormInputField(
      dataType: FieldDataTypes.string,
      name: 'name',
      displayedTitle: S.of(context).product_name,
    );
  }
}

class CategoryFormInputField extends ConsumerWidget {
  const CategoryFormInputField({
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
    final productFormController = ref.watch(categoryFormDataProvider.notifier);
    final formData = productFormController.data;
    return FormInputField(
        formData: formData,
        onSaveFn: productFormController.update,
        dataType: dataType,
        name: name,
        displayedTitle: displayedTitle);
  }
}
