import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tablets/src/common_widgets/forms/form_frame.dart';
import 'package:tablets/src/common_widgets/images/slider_image_picker.dart';
import 'package:tablets/src/features/products/controllers/form_provider.dart';
import 'package:tablets/src/common_widgets/forms/form_buttons.dart';
import 'package:tablets/src/constants/constants.dart' as constants;
import 'package:tablets/src/features/products/controllers/temp_product_provider.dart';
import 'package:tablets/src/features/products/view/forms/form_fields.dart';

class AddProductForm extends ConsumerWidget {
  const AddProductForm({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formController = ref.watch(productsFormControllerProvider);
    final productStateController = ref.watch(productStateNotifierProvider);
    return FormFrame(
      formKey: formController.formKey,
      fields: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          SliderImagePicker(
            imageUrls: productStateController.imageUrls,
            deletingMethod: formController.removeFormImage,
            uploadMethod: formController.uploadImageToDb,
          ),
          constants.ImageToFormFieldsGap.vertical,
          const ProductFormFields(),
        ],
      ),
      buttons: [
        FormAddButton(createMethod: formController.addProductToDb),
        const FormCancelButton(),
      ],
      widthRatio: 0.5,
      heightRatio: 0.9,
    );
  }
}
