import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tablets/src/common_widgets/form_frame.dart';
import 'package:tablets/src/common_widgets/custom_icons.dart';
import 'package:tablets/src/common_widgets/image_slider.dart';
import 'package:tablets/src/constants/constants.dart' as constants;
import 'package:tablets/src/features/products/controllers/form_controller_provider.dart';
import 'package:tablets/src/features/products/controllers/form_data_provider.dart';
import 'package:tablets/src/features/products/view/form_fields.dart';

class AddProductForm extends ConsumerWidget {
  const AddProductForm({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formController = ref.watch(productFormControllerProvider);
    final userFormData = ref.watch(productFormDataProvider);
    return FormFrame(
      formKey: formController.formKey,
      fields: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          ImageSlider(
            userFormData['imageUrls'] ?? [constants.DefaultImage.url],
          ),
          constants.ImageToFormFieldsGap.vertical,
          const ProductFormFields(),
        ],
      ),
      buttons: [
        IconButton(onPressed: () => formController.addProduct(context), icon: const ApproveIcon()),
        IconButton(onPressed: () => Navigator.of(context).pop(), icon: const CancelIcon()),
      ],
      width: 600,
      height: 600,
    );
  }
}
