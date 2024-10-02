import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tablets/src/common_widgets/form/button_cancel.dart';
import 'package:tablets/src/common_widgets/form/button_delete.dart';
import 'package:tablets/src/common_widgets/form/button_update.dart';
import 'package:tablets/src/common_widgets/form/form_frame.dart';
import 'package:tablets/src/common_widgets/various/single_image_picker.dart';
import 'package:tablets/src/features/products/controller/product_form_controller.dart';
import 'package:tablets/src/constants/constants.dart' as constants;
import 'package:tablets/src/features/products/controller/product_state_controller.dart';

import 'package:tablets/src/features/products/view/form_fields.dart';

class EditProductForm extends ConsumerWidget {
  const EditProductForm({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formController = ref.read(productsFormControllerProvider);
    final productStateController = ref.watch(productStateNotifierProvider);
    return FormFrame(
      formKey: formController.formKey,
      fields: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          SingleImagePicker(imageUrl: constants.DefaultImage.url),
          constants.ImageToFormFieldsGap.vertical,
          const ProductFormFields(editMode: true),
        ],
      ),
      buttons: [
        FromUpdateButton(
          updateMethod: formController.updateProductInDB,
          itemToBeUpdated: productStateController.product.copyWith(),
        ),
        const FormCancelButton(),
        FromDeleteButton(
          deleteMethod: formController.deleteCategoryInDB,
          itemToBeDeleted: productStateController.product.copyWith(),
          message: productStateController.product.name,
        ),
      ],
      widthRatio: 0.5,
      heightRatio: 0.75,
    );
  }
}
