import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tablets/src/common_widgets/form/button_cancel.dart';
import 'package:tablets/src/common_widgets/form/button_delete.dart';
import 'package:tablets/src/common_widgets/form/button_update.dart';
import 'package:tablets/src/common_widgets/form/form_frame.dart';
import 'package:tablets/src/common_widgets/various/image_picker_button.dart';
import 'package:tablets/src/common_widgets/various/slider_image_picker.dart';
import 'package:tablets/src/features/products/controller/product_form_provider.dart';
import 'package:tablets/src/constants/constants.dart' as constants;
import 'package:tablets/src/features/products/controller/product_state_controller.dart';

import 'package:tablets/src/features/products/view/product_form_fields.dart';

class EditProductForm extends ConsumerWidget {
  const EditProductForm({super.key});

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
          ),
          ImagePickerButton(uploadingMethod: formController.uploadImageToDb),
          constants.ImageToFormFieldsGap.vertical,
          const ProductFormFields(
            editMode: true,
          ),
        ],
      ),
      buttons: [
        FromUpdateButton(
          updateMethod: formController.updateProductInDB,
          itemToBeUpdated: productStateController.product.copyWith(),
        ),
        const FormCancelButton(),
        FromDeleteButton(
          deleteMethod: formController.deleteProductFromDB,
          itemToBeDeleted: productStateController.product.copyWith(),
          message: productStateController.product.name,
        ),
      ],
      widthRatio: 0.5,
      heightRatio: 0.75,
    );
  }
}
