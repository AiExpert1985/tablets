import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tablets/generated/l10n.dart';
import 'package:tablets/src/common_styling_and_decorations/form_field_box_input_decoration.dart';
import 'package:tablets/src/features/products/controller/products_controller.dart';
import 'package:tablets/src/utils/utils.dart' as utils;

class ProductCodeFormField extends ConsumerWidget {
  const ProductCodeFormField({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productController = ref.read(productsControllerProvider);
    return Expanded(
      child: TextFormField(
        textAlign: TextAlign.center,
        decoration: formFieldBoxInputDecoration(S.of(context).product_code),
        validator: (value) => utils.FormValidation.validateNumberField(
            fieldValue: value,
            errorMessage:
                S.of(context).input_validation_error_message_for_numbers),
        onSaved: (value) {
          productController.tempProduct.code =
              double.parse(value!); // value is double (never null)
        },
      ),
    );
  }
}

class ProductNameFormField extends ConsumerWidget {
  const ProductNameFormField({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productController = ref.read(productsControllerProvider);
    return Expanded(
      child: TextFormField(
        textAlign: TextAlign.center,
        decoration: formFieldBoxInputDecoration(S.of(context).product_name),
        validator: (value) => utils.FormValidation.validateNameField(
            fieldValue: value,
            errorMessage:
                S.of(context).input_validation_error_message_for_names),
        onSaved: (value) {
          productController.tempProduct.name = value!; // value can't be null
        },
      ),
    );
  }
}

class ProductCategoryFormField extends ConsumerWidget {
  const ProductCategoryFormField({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productController = ref.read(productsControllerProvider);
    return Expanded(
      child: TextFormField(
        textAlign: TextAlign.center,
        decoration: formFieldBoxInputDecoration(S.of(context).product_category),
        validator: (value) => utils.FormValidation.validateNameField(
            fieldValue: value,
            errorMessage:
                S.of(context).input_validation_error_message_for_names),
        onSaved: (value) {
          productController.tempProduct.category =
              value!; // value can't be null
        },
      ),
    );
  }
}

class ProductSellRetaiPriceFormField extends ConsumerWidget {
  const ProductSellRetaiPriceFormField({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productController = ref.read(productsControllerProvider);
    return Expanded(
      child: TextFormField(
        textAlign: TextAlign.center,
        decoration: formFieldBoxInputDecoration(
            S.of(context).product_sell_retail_price),
        validator: (value) => utils.FormValidation.validateNumberField(
            fieldValue: value,
            errorMessage:
                S.of(context).input_validation_error_message_for_numbers),
        onSaved: (value) {
          productController.tempProduct.sellRetailPrice = double.parse(
              value!); // value is double (never null)// value can't be null
        },
      ),
    );
  }
}

class ProductSellWholePriceFormField extends ConsumerWidget {
  const ProductSellWholePriceFormField({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productController = ref.read(productsControllerProvider);
    return Expanded(
      child: TextFormField(
        textAlign: TextAlign.center,
        decoration:
            formFieldBoxInputDecoration(S.of(context).product_sell_whole_price),
        validator: (value) => utils.FormValidation.validateNameField(
            fieldValue: value,
            errorMessage:
                S.of(context).input_validation_error_message_for_numbers),
        onSaved: (value) {
          productController.tempProduct.sellWholePrice = double.parse(
              value!); // value is double (never null)/ value can't be null
        },
      ),
    );
  }
}

class ProductSellsmanCommissionFormField extends ConsumerWidget {
  const ProductSellsmanCommissionFormField({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productController = ref.read(productsControllerProvider);
    return Expanded(
      child: TextFormField(
        textAlign: TextAlign.center,
        decoration: formFieldBoxInputDecoration(
            S.of(context).product_salesman_comission),
        validator: (value) => utils.FormValidation.validateNameField(
            fieldValue: value,
            errorMessage:
                S.of(context).input_validation_error_message_for_numbers),
        onSaved: (value) {
          productController.tempProduct.salesmanComission = double.parse(
              value!); // value is double (never null)// value can't be null
        },
      ),
    );
  }
}

class ProductInitialQuantityFormField extends ConsumerWidget {
  const ProductInitialQuantityFormField({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productController = ref.read(productsControllerProvider);
    return Expanded(
      child: TextFormField(
        textAlign: TextAlign.center,
        decoration: formFieldBoxInputDecoration(
            S.of(context).product_initial_quantitiy),
        validator: (value) => utils.FormValidation.validateNumberField(
            fieldValue: value,
            errorMessage:
                S.of(context).input_validation_error_message_for_numbers),
        onSaved: (value) {
          productController.tempProduct.initialQuantity = double.parse(
              value!); // value is double (never null)// value can't be null
        },
      ),
    );
  }
}

class ProductAltertWhenLessThanFormField extends ConsumerWidget {
  const ProductAltertWhenLessThanFormField({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productController = ref.read(productsControllerProvider);
    return Expanded(
      child: TextFormField(
        textAlign: TextAlign.center,
        decoration: formFieldBoxInputDecoration(
            S.of(context).product_altert_when_less_than),
        validator: (value) => utils.FormValidation.validateNumberField(
            fieldValue: value,
            errorMessage:
                S.of(context).input_validation_error_message_for_numbers),
        onSaved: (value) {
          productController.tempProduct.altertWhenLessThan = double.parse(
              value!); // value is double (never null) value can't be null
        },
      ),
    );
  }
}

class ProductAlertWhenExceedsFormField extends ConsumerWidget {
  const ProductAlertWhenExceedsFormField({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productController = ref.read(productsControllerProvider);
    return Expanded(
      child: TextFormField(
        textAlign: TextAlign.center,
        decoration: formFieldBoxInputDecoration(
            S.of(context).product_alert_when_exceeds),
        validator: (value) => utils.FormValidation.validateNameField(
            fieldValue: value,
            errorMessage:
                S.of(context).input_validation_error_message_for_numbers),
        onSaved: (value) {
          productController.tempProduct.alertWhenExceeds = double.parse(
              value!); // value is double (never null)// value can't be null
        },
      ),
    );
  }
}

class ProductPackageTypeFormField extends ConsumerWidget {
  const ProductPackageTypeFormField({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productController = ref.read(productsControllerProvider);
    return Expanded(
      child: TextFormField(
        textAlign: TextAlign.center,
        decoration:
            formFieldBoxInputDecoration(S.of(context).product_package_type),
        validator: (value) => utils.FormValidation.validateNameField(
            fieldValue: value,
            errorMessage:
                S.of(context).input_validation_error_message_for_names),
        onSaved: (value) {
          productController.tempProduct.packageType =
              value!; // value can't be null
        },
      ),
    );
  }
}

class ProductPackageWeightFormField extends ConsumerWidget {
  const ProductPackageWeightFormField({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productController = ref.read(productsControllerProvider);
    return Expanded(
      child: TextFormField(
        textAlign: TextAlign.center,
        decoration:
            formFieldBoxInputDecoration(S.of(context).product_package_weight),
        validator: (value) => utils.FormValidation.validateNumberField(
            fieldValue: value,
            errorMessage:
                S.of(context).input_validation_error_message_for_numbers),
        onSaved: (value) {
          productController.tempProduct.packageWeight = double.parse(
              value!); // value is double (never null)/ value can't be null
        },
      ),
    );
  }
}

class ProductNumItemsInsidePackageFormField extends ConsumerWidget {
  const ProductNumItemsInsidePackageFormField({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productController = ref.read(productsControllerProvider);
    return Expanded(
      child: TextFormField(
        textAlign: TextAlign.center,
        decoration: formFieldBoxInputDecoration(
            S.of(context).product_num_items_inside_package),
        validator: (value) => utils.FormValidation.validateNameField(
            fieldValue: value,
            errorMessage:
                S.of(context).input_validation_error_message_for_numbers),
        onSaved: (value) {
          productController.tempProduct.numItemsInsidePackage = double.parse(
              value!); // value is double (never null)// value can't be null
        },
      ),
    );
  }
}
