// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tablets/src/common_widgets/form_buttons/form_cancel_button.dart';
import 'package:tablets/src/common_widgets/various/general_image_picker.dart';
import 'package:tablets/src/constants/constants.dart' as constants;
import 'package:tablets/src/features/products/controller/products_controller.dart';
import 'package:tablets/src/common_widgets/form_buttons/form_creation_button.dart';
import 'package:tablets/src/features/products/view/product_form_fields.dart';

class CreateProductDialog extends ConsumerStatefulWidget {
  const CreateProductDialog({super.key});

  @override
  ConsumerState<CreateProductDialog> createState() => _AddProductDialogState();
}

class _AddProductDialogState extends ConsumerState<CreateProductDialog> {
  @override
  Widget build(BuildContext context) {
    final productController = ref.read(productsControllerProvider);
    return AlertDialog(
      alignment: Alignment.center,
      scrollable: true,
      contentPadding: const EdgeInsets.symmetric(vertical: 5, horizontal: 30),
      // title: Text(S.of(context).add_new_user),
      content: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(20),
          width: MediaQuery.of(context).size.width * 0.5,
          height: MediaQuery.of(context).size.height * 0.75,
          child: Form(
            key: productController.formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
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
            ),
          ),
        ),
      ),

      actions: [
        OverflowBar(
          alignment: MainAxisAlignment.center,
          children: [
            FormCreateButton(
                creationMethod: productController.createNewProductInDb),
            const FormCancelButton(),
          ],
        )
      ],
    );
  }
}
