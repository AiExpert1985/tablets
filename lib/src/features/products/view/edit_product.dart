import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tablets/src/common_widgets/form/button_cancel.dart';
import 'package:tablets/src/common_widgets/form/button_delete.dart';
import 'package:tablets/src/common_widgets/form/button_update.dart';
import 'package:tablets/src/common_widgets/form/form_frame.dart';
import 'package:tablets/src/common_widgets/various/general_image_picker.dart';
import 'package:tablets/src/features/products/controller/products_controller.dart';
import 'package:tablets/src/constants/constants.dart' as constants;
import 'package:tablets/src/features/products/model/product.dart';
import 'package:tablets/src/features/products/view/form_fields.dart';

class EditProductForm extends ConsumerWidget {
  const EditProductForm({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productController = ref.read(productsControllerProvider);
    return FormFrame(
      formKey: productController.formKey,
      fields: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          GeneralImagePicker(imageUrl: constants.DefaultImage.url),
          constants.ImageToFormFieldsGap.vertical,
          const ProductFormFields(editMode: true),
        ],
      ),
      buttons: [
        FromUpdateButton(
          updateMethod: productController.updateProductInDB,
          itemToBeUpdated: productController.tempProduct.copyWith(),
        ),
        const FormCancelButton(),
        FromDeleteButton(
          deleteMethod: productController.deleteCategoryInDB,
          itemToBeDeleted: productController.tempProduct,
          message: productController.tempProduct.name,
        ),
      ],
      widthRatio: 0.5,
      heightRatio: 0.75,
    );
  }
}
