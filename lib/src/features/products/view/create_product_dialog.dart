import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tablets/src/common_widgets/form_buttons/form_cancel_button.dart';
import 'package:tablets/src/common_widgets/form_buttons/form_frame.dart';
import 'package:tablets/src/common_widgets/various/general_image_picker.dart';
import 'package:tablets/src/features/products/controller/products_controller.dart';
import 'package:tablets/src/common_widgets/form_buttons/form_creation_button.dart';
import 'package:tablets/src/features/products/view/product_form_fields.dart';
import 'package:tablets/src/constants/constants.dart' as constants;

class CreateProductForm extends ConsumerWidget {
  const CreateProductForm({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productController = ref.read(productsControllerProvider);
    return FormFrame(
      formKey: productController.formKey,
      fields: [
        GeneralImagePicker(imageUrl: constants.DefaultImage.url),
        constants.ImageToFormFieldsGap.vertical,
        const Row(
          children: [
            ProductCodeFormField(),
            constants.FormGap.horizontal,
            ProductNameFormField(),
            constants.FormGap.horizontal,
            ProductCategoryFormField(),
          ],
        ),
        constants.FormGap.vertical,
        const Row(
          children: [
            ProductSellRetaiPriceFormField(),
            constants.FormGap.horizontal,
            ProductSellWholePriceFormField(),
            constants.FormGap.horizontal,
            ProductSellsmanCommissionFormField(),
          ],
        ),
        constants.FormGap.vertical,
        const Row(
          children: [
            ProductInitialQuantityFormField(),
            constants.FormGap.horizontal,
            ProductAltertWhenLessThanFormField(),
            constants.FormGap.horizontal,
            ProductAlertWhenExceedsFormField(),
          ],
        ),
        constants.FormGap.vertical,
        const Row(
          children: [
            ProductPackageTypeFormField(),
            constants.FormGap.horizontal,
            ProductPackageWeightFormField(),
            constants.FormGap.horizontal,
            ProductNumItemsInsidePackageFormField(),
          ],
        ),
      ],
      buttons: [
        FormCreateButton(createMethod: productController.createNewProductInDb),
        const FormCancelButton(),
      ],
      widthRatio: 0.5,
      heightRatio: 0.75,
    );
  }
}
