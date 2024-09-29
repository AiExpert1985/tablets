// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tablets/generated/l10n.dart';
import 'package:tablets/src/common_styling_and_decorations/form_field_box_input_decoration.dart';
import 'package:tablets/src/common_widgets/various/general_image_picker.dart';
import 'package:tablets/src/constants/constants.dart' as constants;
import 'package:tablets/src/features/products/controller/products_controller.dart';
import 'package:tablets/src/utils/utils.dart' as utils;

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
                GeneralImagePicker(
                  imageUrl: constants.DefaultImage.url,
                ),
                constants.ImageToFormFieldsGap.vertical,
                //! 1st Row
                Row(
                  children: [
                    //! product code
                    Expanded(
                      child: TextFormField(
                        textAlign: TextAlign.center,
                        decoration: formFieldBoxInputDecoration(
                            S.of(context).product_code),
                        validator: (value) =>
                            utils.FormValidation.validateNumberField(
                                fieldValue: value,
                                errorMessage: S
                                    .of(context)
                                    .input_validation_error_message_for_numbers),
                        onSaved: (value) {
                          productController.tempProduct.code = double.parse(
                              value!); // value is double (never null)
                        },
                      ),
                    ),
                    constants.FormGap.horizontal,
                    //! prodcut name
                    Expanded(
                      child: TextFormField(
                        textAlign: TextAlign.center,
                        decoration: formFieldBoxInputDecoration(
                            S.of(context).product_name),
                        validator: (value) =>
                            utils.FormValidation.validateNameField(
                                fieldValue: value,
                                errorMessage: S
                                    .of(context)
                                    .input_validation_error_message_for_names),
                        onSaved: (value) {
                          productController.tempProduct.name =
                              value!; // value can't be null
                        },
                      ),
                    ),
                    constants.FormGap.horizontal,
                    //! product Category
                    Expanded(
                      child: TextFormField(
                        textAlign: TextAlign.center,
                        decoration: formFieldBoxInputDecoration(
                            S.of(context).product_category),
                        validator: (value) =>
                            utils.FormValidation.validateNameField(
                                fieldValue: value,
                                errorMessage: S
                                    .of(context)
                                    .input_validation_error_message_for_names),
                        onSaved: (value) {
                          productController.tempProduct.category =
                              value!; // value can't be null
                        },
                      ),
                    ),
                  ],
                ),
                constants.FormGap.vertical,
                //! 2nd Row
                Row(
                  children: [
                    //! product sellRetailPrice
                    Expanded(
                      child: TextFormField(
                        textAlign: TextAlign.center,
                        decoration: formFieldBoxInputDecoration(
                            S.of(context).product_sell_retail_price),
                        validator: (value) =>
                            utils.FormValidation.validateNumberField(
                                fieldValue: value,
                                errorMessage: S
                                    .of(context)
                                    .input_validation_error_message_for_numbers),
                        onSaved: (value) {
                          productController.tempProduct.sellRetailPrice =
                              double.parse(
                                  value!); // value is double (never null)// value can't be null
                        },
                      ),
                    ),
                    constants.FormGap.horizontal,
                    //! prodcut sellWholePrice
                    Expanded(
                      child: TextFormField(
                        textAlign: TextAlign.center,
                        decoration: formFieldBoxInputDecoration(
                            S.of(context).product_sell_whole_price),
                        validator: (value) =>
                            utils.FormValidation.validateNameField(
                                fieldValue: value,
                                errorMessage: S
                                    .of(context)
                                    .input_validation_error_message_for_numbers),
                        onSaved: (value) {
                          productController.tempProduct.sellWholePrice =
                              double.parse(
                                  value!); // value is double (never null)/ value can't be null
                        },
                      ),
                    ),
                    constants.FormGap.horizontal,
                    //! prodcut sellsman commission
                    Expanded(
                      child: TextFormField(
                        textAlign: TextAlign.center,
                        decoration: formFieldBoxInputDecoration(
                            S.of(context).product_salesman_comission),
                        validator: (value) =>
                            utils.FormValidation.validateNameField(
                                fieldValue: value,
                                errorMessage: S
                                    .of(context)
                                    .input_validation_error_message_for_numbers),
                        onSaved: (value) {
                          productController.tempProduct.salesmanComission =
                              double.parse(
                                  value!); // value is double (never null)// value can't be null
                        },
                      ),
                    ),
                  ],
                ),
                constants.FormGap.vertical,
                //! 3rd Row
                Row(
                  children: [
                    //! prodcut initial quantity
                    Expanded(
                      child: TextFormField(
                        textAlign: TextAlign.center,
                        decoration: formFieldBoxInputDecoration(
                            S.of(context).product_initial_quantitiy),
                        validator: (value) =>
                            utils.FormValidation.validateNumberField(
                                fieldValue: value,
                                errorMessage: S
                                    .of(context)
                                    .input_validation_error_message_for_numbers),
                        onSaved: (value) {
                          productController.tempProduct.initialQuantity =
                              double.parse(
                                  value!); // value is double (never null)// value can't be null
                        },
                      ),
                    ),
                    constants.FormGap.horizontal,
                    //! product alert when less than
                    Expanded(
                      child: TextFormField(
                        textAlign: TextAlign.center,
                        decoration: formFieldBoxInputDecoration(
                            S.of(context).product_altert_when_less_than),
                        validator: (value) =>
                            utils.FormValidation.validateNumberField(
                                fieldValue: value,
                                errorMessage: S
                                    .of(context)
                                    .input_validation_error_message_for_numbers),
                        onSaved: (value) {
                          productController.tempProduct.altertWhenLessThan =
                              double.parse(
                                  value!); // value is double (never null) value can't be null
                        },
                      ),
                    ),
                    constants.FormGap.horizontal,
                    //! prodcut alert when exceeds
                    Expanded(
                      child: TextFormField(
                        textAlign: TextAlign.center,
                        decoration: formFieldBoxInputDecoration(
                            S.of(context).product_alert_when_exceeds),
                        validator: (value) =>
                            utils.FormValidation.validateNameField(
                                fieldValue: value,
                                errorMessage: S
                                    .of(context)
                                    .input_validation_error_message_for_numbers),
                        onSaved: (value) {
                          productController.tempProduct.alertWhenExceeds =
                              double.parse(
                                  value!); // value is double (never null)// value can't be null
                        },
                      ),
                    ),
                  ],
                ),
                constants.FormGap.vertical,
                //! 4th Row
                Row(
                  children: [
                    //! prodcut package type
                    Expanded(
                      child: TextFormField(
                        textAlign: TextAlign.center,
                        decoration: formFieldBoxInputDecoration(
                            S.of(context).product_package_type),
                        validator: (value) =>
                            utils.FormValidation.validateNameField(
                                fieldValue: value,
                                errorMessage: S
                                    .of(context)
                                    .input_validation_error_message_for_names),
                        onSaved: (value) {
                          productController.tempProduct.packageType =
                              value!; // value can't be null
                        },
                      ),
                    ),
                    constants.FormGap.horizontal,
                    //! product package weight
                    Expanded(
                      child: TextFormField(
                        textAlign: TextAlign.center,
                        decoration: formFieldBoxInputDecoration(
                            S.of(context).product_package_weight),
                        validator: (value) =>
                            utils.FormValidation.validateNumberField(
                                fieldValue: value,
                                errorMessage: S
                                    .of(context)
                                    .input_validation_error_message_for_numbers),
                        onSaved: (value) {
                          productController.tempProduct.packageWeight =
                              double.parse(
                                  value!); // value is double (never null)/ value can't be null
                        },
                      ),
                    ),
                    constants.FormGap.horizontal,
                    //! prodcut num of items inside package
                    Expanded(
                      child: TextFormField(
                        textAlign: TextAlign.center,
                        decoration: formFieldBoxInputDecoration(
                            S.of(context).product_num_items_inside_package),
                        validator: (value) =>
                            utils.FormValidation.validateNameField(
                                fieldValue: value,
                                errorMessage: S
                                    .of(context)
                                    .input_validation_error_message_for_numbers),
                        onSaved: (value) {
                          productController.tempProduct.numItemsInsidePackage =
                              double.parse(
                                  value!); // value is double (never null)// value can't be null
                        },
                      ),
                    ),
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
            TextButton(
              onPressed: () => productController.createNewProductInDb(context),
              child: Column(
                children: [
                  const Icon(Icons.check, color: Colors.green),
                  constants.IconToTextGap.vertical,
                  Text(S.of(context).save),
                ],
              ),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Column(
                children: [
                  const Icon(Icons.close),
                  constants.IconToTextGap.vertical,
                  Text(S.of(context).cancel),
                ],
              ),
            ),
          ],
        )
      ],
    );
  }
}
