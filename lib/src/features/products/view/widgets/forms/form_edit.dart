import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tablets/src/common_widgets/forms/form_frame.dart';
import 'package:tablets/src/common_widgets/icons/custom_icons.dart';
import 'package:tablets/src/common_widgets/images/image_slider.dart';
import 'package:tablets/src/common_widgets/various/delete_confirmation_dialog.dart';
import 'package:tablets/src/features/products/controllers/form_provider.dart';
import 'package:tablets/src/constants/constants.dart' as constants;
import 'package:tablets/src/features/products/controllers/temp_product_provider.dart';

import 'package:tablets/src/features/products/view/widgets/forms/form_fields.dart';

class EditProductForm extends ConsumerWidget {
  const EditProductForm({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formController = ref.watch(productsFormFieldsControllerProvider);
    final productStateController = ref.watch(productStateNotifierProvider);
    return FormFrame(
      formKey: formController.formKey,
      fields: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          ImageSlider(
            productStateController.imageUrls,
          ),
          constants.ImageToFormFieldsGap.vertical,
          const ProductFormFields(
            editMode: true,
          ),
        ],
      ),
      buttons: [
        IconButton(
          onPressed: () => formController.updateProduct(
            context,
            productStateController.product.copyWith(),
          ),
          icon: const ApproveIcon(),
        ),
        IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const CancelIcon(),
        ),
        IconButton(
            onPressed: () async {
              bool? confiramtion = await showDeleteConfirmationDialog(
                context: context,
                message: productStateController.product.name,
              );
              if (confiramtion != null && context.mounted) {
                formController.deleteProduct(context, productStateController.product.copyWith());
              }
            },
            icon: const DeleteIcon())
      ],
      widthRatio: 0.5,
      heightRatio: 0.75,
    );
  }
}
