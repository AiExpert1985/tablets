import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tablets/generated/l10n.dart';
import 'package:tablets/src/common/values/constants.dart';
import 'package:tablets/src/common/widgets/form_fields/edit_box.dart';
import 'package:tablets/src/features/categories/controllers/category_form_controller.dart';

class CategoryFormFields extends StatelessWidget {
  const CategoryFormFields({super.key, this.editMode = false});
  final bool editMode;
  @override
  Widget build(BuildContext context) {
    return CategoryFormInputField(
      dataType: FieldDataTypes.string,
      name: 'name',
      displayedTitle: S.of(context).category_name,
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
    final categoryFormController = ref.watch(categoryFormDataProvider.notifier);
    final formData = categoryFormController.data;
    return FormInputField(
        formData: formData,
        onChangedFn: categoryFormController.update,
        dataType: dataType,
        property: name,
        label: displayedTitle);
  }
}
