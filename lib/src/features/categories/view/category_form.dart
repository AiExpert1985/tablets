import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tablets/src/common/providers/image_picker_provider.dart';
import 'package:tablets/src/common/values/form_dimenssions.dart';
import 'package:tablets/src/common/widgets/form_frame.dart';
import 'package:tablets/src/common/widgets/custom_icons.dart';
import 'package:tablets/src/common/widgets/image_slider.dart';
import 'package:tablets/src/common/widgets/dialog_delete_confirmation.dart';
import 'package:tablets/src/features/categories/controllers/category_form_controller.dart';
import 'package:tablets/src/features/categories/model/category.dart';
import 'package:tablets/src/features/categories/view/category_form_fields.dart';
import 'package:tablets/src/common/values/gaps.dart' as gaps;

class CategoryForm extends ConsumerWidget {
  const CategoryForm({this.isEditMode = false, super.key});
  final bool isEditMode;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formController = ref.watch(categoryFormControllerProvider);
    final formData = ref.watch(categoryFormDataProvider);
    final formDataNotifier = ref.read(categoryFormDataProvider.notifier);
    final formImagesNotifier = ref.read(imagePickerProvider.notifier);
    ref.watch(imagePickerProvider);
    return FormFrame(
      formKey: formController.formKey,
      fields: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          ImageSlider(imageUrls: formData['imageUrls']),
          gaps.VerticalGap.formImageToFields,
          const CategoryFormFields(editMode: true),
        ],
      ),
      buttons: [
        IconButton(
          onPressed: () {
            if (!formController.validateData()) return;
            formController.submitData();
            final updateFormData = formDataNotifier.data;
            final imageUrls = formImagesNotifier.saveChanges();
            final category = ProductCategory.fromMap({...updateFormData, 'imageUrls': imageUrls});
            formController.saveItemToDb(context, category, isEditMode);
          },
          icon: const SaveIcon(),
        ),
        IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const CancelIcon(),
        ),
        Visibility(
          visible: isEditMode,
          child: IconButton(
              onPressed: () async {
                bool? confiramtion =
                    await showDeleteConfirmationDialog(context: context, message: formData['name']);
                if (confiramtion != null) {
                  final updateFormData = formDataNotifier.data;
                  final imageUrls = formImagesNotifier.saveChanges();
                  final category =
                      ProductCategory.fromMap({...updateFormData, 'imageUrls': imageUrls});
                  // ignore: use_build_context_synchronously
                  formController.deleteItemFromDb(context, category);
                }
              },
              icon: const DeleteIcon()),
        )
      ],
      width: categoryFormWidth,
      height: categoryFormHeight,
    );
  }
}
