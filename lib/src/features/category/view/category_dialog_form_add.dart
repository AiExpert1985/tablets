import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tablets/src/common/widgets/form_frame.dart';
import 'package:tablets/src/common/widgets/custom_icons.dart';
import 'package:tablets/src/common/widgets/image_slider.dart';
import 'package:tablets/src/common/constants/gaps.dart' as gaps;
import 'package:tablets/src/common/constants/constants.dart' as constants;
import 'package:tablets/src/features/category/controllers/category_form_controllers.dart';
import 'package:tablets/src/features/category/view/category_form_fields.dart';

class AddCategoryForm extends ConsumerWidget {
  const AddCategoryForm({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formController = ref.watch(categoryFormControllerProvider);
    final userFormData = ref.watch(categoryFormDataProvider);
    return FormFrame(
      formKey: formController.formKey,
      fields: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          ImageSlider(
            userFormData['imageUrls'] ?? [constants.defaultImageUrl],
          ),
          gaps.VerticalGap.formImageToFields,
          const CategoryFormFields(),
        ],
      ),
      buttons: [
        IconButton(onPressed: () => formController.addCategory(context), icon: const ApproveIcon()),
        IconButton(onPressed: () => Navigator.of(context).pop(), icon: const CancelIcon()),
      ],
      width: constants.categoryFormWidth,
      height: constants.categoryFormHeight,
    );
  }
}
