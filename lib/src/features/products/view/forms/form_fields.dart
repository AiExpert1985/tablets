import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tablets/generated/l10n.dart';
import 'package:tablets/src/utils/field_box_decoration.dart';
import 'package:tablets/src/features/products/controller/product_state_controller.dart';
import 'package:tablets/src/features/products/model/product.dart';
import 'package:tablets/src/utils/utils.dart' as utils;
import 'package:tablets/src/constants/constants.dart' as constants;

class ProductFormFields extends ConsumerWidget {
  const ProductFormFields({super.key, this.editMode = false});
  final bool editMode;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productStateController = ref.watch(productStateNotifierProvider);
    Product oldProduct = productStateController.product.copyWith();
    return Column(
      children: [
        Row(
          children: [
            ProductCodeFormField(editMode ? oldProduct.code.toString() : null),
            constants.FormGap.horizontal,
            ProductNameFormField(editMode ? oldProduct.name : null),
            constants.FormGap.horizontal,
            ProductCategoryFormField(editMode ? oldProduct.category : null),
          ],
        ),
        constants.FormGap.vertical,
        Row(
          children: [
            ProductSellRetaiPriceFormField(editMode ? oldProduct.sellRetailPrice.toString() : null),
            constants.FormGap.horizontal,
            ProductSellWholePriceFormField(editMode ? oldProduct.sellWholePrice.toString() : null),
            constants.FormGap.horizontal,
            ProductSellsmanCommissionFormField(
              editMode ? oldProduct.salesmanComission.toString() : null,
            ),
          ],
        ),
        constants.FormGap.vertical,
        Row(
          children: [
            ProductInitialQuantityFormField(
              editMode ? oldProduct.initialQuantity.toString() : null,
            ),
            constants.FormGap.horizontal,
            ProductAltertWhenLessThanFormField(
              editMode ? oldProduct.altertWhenLessThan.toString() : null,
            ),
            constants.FormGap.horizontal,
            ProductAlertWhenExceedsFormField(
              editMode ? oldProduct.alertWhenExceeds.toString() : null,
            ),
          ],
        ),
        constants.FormGap.vertical,
        Row(
          children: [
            ProductPackageTypeFormField(editMode ? oldProduct.packageType.toString() : null),
            constants.FormGap.horizontal,
            ProductPackageWeightFormField(editMode ? oldProduct.packageWeight.toString() : null),
            constants.FormGap.horizontal,
            ProductNumItemsInsidePackageFormField(
              editMode ? oldProduct.numItemsInsidePackage.toString() : null,
            ),
          ],
        )
      ],
    );
  }
}

class ProductCodeFormField extends ConsumerWidget {
  const ProductCodeFormField(this.initialValue, {super.key});
  final String? initialValue;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Expanded(
      child: TextFormField(
          initialValue: initialValue,
          textAlign: TextAlign.center,
          decoration: formFieldDecoration(S.of(context).product_code),
          validator: (value) => utils.FormValidation.validateNumberField(
              fieldValue: value,
              errorMessage: S.of(context).input_validation_error_message_for_numbers),
          onSaved: (value) {
            final product = ref.read(productStateNotifierProvider).product;
            ref
                .read(productStateNotifierProvider.notifier)
                .setProduct(product.copyWith(code: int.parse(value!)));
          }),
    );
  }
}

class ProductNameFormField extends ConsumerWidget {
  const ProductNameFormField(this.initialValue, {super.key});
  final String? initialValue;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Expanded(
      child: TextFormField(
          initialValue: initialValue,
          textAlign: TextAlign.center,
          decoration: formFieldDecoration(S.of(context).product_name),
          validator: (value) => utils.FormValidation.validateNameField(
              fieldValue: value,
              errorMessage: S.of(context).input_validation_error_message_for_names),
          onSaved: (value) {
            final product = ref.read(productStateNotifierProvider).product;
            ref
                .read(productStateNotifierProvider.notifier)
                .setProduct(product.copyWith(name: value!));
          }),
    );
  }
}

class ProductCategoryFormField extends ConsumerWidget {
  const ProductCategoryFormField(this.initialValue, {super.key});
  final String? initialValue;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Expanded(
      child: TextFormField(
          initialValue: initialValue,
          textAlign: TextAlign.center,
          decoration: formFieldDecoration(S.of(context).product_category),
          validator: (value) => utils.FormValidation.validateNameField(
              fieldValue: value,
              errorMessage: S.of(context).input_validation_error_message_for_names),
          onSaved: (value) {
            final product = ref.read(productStateNotifierProvider).product;
            ref
                .read(productStateNotifierProvider.notifier)
                .setProduct(product.copyWith(category: value!));
          }),
    );
  }
}

class ProductSellRetaiPriceFormField extends ConsumerWidget {
  const ProductSellRetaiPriceFormField(this.initialValue, {super.key});
  final String? initialValue;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Expanded(
      child: TextFormField(
          initialValue: initialValue,
          textAlign: TextAlign.center,
          decoration: formFieldDecoration(S.of(context).product_sell_retail_price),
          validator: (value) => utils.FormValidation.validateNumberField(
              fieldValue: value,
              errorMessage: S.of(context).input_validation_error_message_for_numbers),
          onSaved: (value) {
            final product = ref.read(productStateNotifierProvider).product;
            ref
                .read(productStateNotifierProvider.notifier)
                .setProduct(product.copyWith(sellRetailPrice: double.parse(value!)));
          }),
    );
  }
}

class ProductSellWholePriceFormField extends ConsumerWidget {
  const ProductSellWholePriceFormField(this.initialValue, {super.key});
  final String? initialValue;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Expanded(
      child: TextFormField(
          initialValue: initialValue,
          textAlign: TextAlign.center,
          decoration: formFieldDecoration(S.of(context).product_sell_whole_price),
          validator: (value) => utils.FormValidation.validateNameField(
              fieldValue: value,
              errorMessage: S.of(context).input_validation_error_message_for_numbers),
          onSaved: (value) {
            final product = ref.read(productStateNotifierProvider).product;
            ref
                .read(productStateNotifierProvider.notifier)
                .setProduct(product.copyWith(sellWholePrice: double.parse(value!)));
          }),
    );
  }
}

class ProductSellsmanCommissionFormField extends ConsumerWidget {
  const ProductSellsmanCommissionFormField(this.initialValue, {super.key});
  final String? initialValue;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Expanded(
      child: TextFormField(
          initialValue: initialValue,
          textAlign: TextAlign.center,
          decoration: formFieldDecoration(S.of(context).product_salesman_comission),
          validator: (value) => utils.FormValidation.validateNameField(
              fieldValue: value,
              errorMessage: S.of(context).input_validation_error_message_for_numbers),
          onSaved: (value) {
            final product = ref.read(productStateNotifierProvider).product;
            ref
                .read(productStateNotifierProvider.notifier)
                .setProduct(product.copyWith(salesmanComission: double.parse(value!)));
          }),
    );
  }
}

class ProductInitialQuantityFormField extends ConsumerWidget {
  const ProductInitialQuantityFormField(this.initialValue, {super.key});
  final String? initialValue;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Expanded(
      child: TextFormField(
          initialValue: initialValue,
          textAlign: TextAlign.center,
          decoration: formFieldDecoration(S.of(context).product_initial_quantitiy),
          validator: (value) => utils.FormValidation.validateNumberField(
              fieldValue: value,
              errorMessage: S.of(context).input_validation_error_message_for_numbers),
          onSaved: (value) {
            final product = ref.read(productStateNotifierProvider).product;
            ref
                .read(productStateNotifierProvider.notifier)
                .setProduct(product.copyWith(initialQuantity: int.parse(value!)));
          }),
    );
  }
}

class ProductAltertWhenLessThanFormField extends ConsumerWidget {
  const ProductAltertWhenLessThanFormField(this.initialValue, {super.key});
  final String? initialValue;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Expanded(
      child: TextFormField(
          initialValue: initialValue,
          textAlign: TextAlign.center,
          decoration: formFieldDecoration(S.of(context).product_altert_when_less_than),
          validator: (value) => utils.FormValidation.validateNumberField(
              fieldValue: value,
              errorMessage: S.of(context).input_validation_error_message_for_numbers),
          onSaved: (value) {
            final product = ref.read(productStateNotifierProvider).product;
            ref
                .read(productStateNotifierProvider.notifier)
                .setProduct(product.copyWith(altertWhenLessThan: int.parse(value!)));
          }),
    );
  }
}

class ProductAlertWhenExceedsFormField extends ConsumerWidget {
  const ProductAlertWhenExceedsFormField(this.initialValue, {super.key});
  final String? initialValue;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Expanded(
      child: TextFormField(
          initialValue: initialValue,
          textAlign: TextAlign.center,
          decoration: formFieldDecoration(S.of(context).product_alert_when_exceeds),
          validator: (value) => utils.FormValidation.validateNameField(
              fieldValue: value,
              errorMessage: S.of(context).input_validation_error_message_for_numbers),
          onSaved: (value) {
            final product = ref.read(productStateNotifierProvider).product;
            ref
                .read(productStateNotifierProvider.notifier)
                .setProduct(product.copyWith(alertWhenExceeds: int.parse(value!)));
          }),
    );
  }
}

class ProductPackageTypeFormField extends ConsumerWidget {
  const ProductPackageTypeFormField(this.initialValue, {super.key});
  final String? initialValue;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Expanded(
      child: TextFormField(
          initialValue: initialValue,
          textAlign: TextAlign.center,
          decoration: formFieldDecoration(S.of(context).product_package_type),
          validator: (value) => utils.FormValidation.validateNameField(
              fieldValue: value,
              errorMessage: S.of(context).input_validation_error_message_for_names),
          onSaved: (value) {
            final product = ref.read(productStateNotifierProvider).product;
            ref
                .read(productStateNotifierProvider.notifier)
                .setProduct(product.copyWith(packageType: value!));
          }),
    );
  }
}

class ProductPackageWeightFormField extends ConsumerWidget {
  const ProductPackageWeightFormField(this.initialValue, {super.key});
  final String? initialValue;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Expanded(
      child: TextFormField(
          initialValue: initialValue,
          textAlign: TextAlign.center,
          decoration: formFieldDecoration(S.of(context).product_package_weight),
          validator: (value) => utils.FormValidation.validateNumberField(
              fieldValue: value,
              errorMessage: S.of(context).input_validation_error_message_for_numbers),
          onSaved: (value) {
            final product = ref.read(productStateNotifierProvider).product;
            ref
                .read(productStateNotifierProvider.notifier)
                .setProduct(product.copyWith(packageWeight: double.parse(value!)));
          }),
    );
  }
}

class ProductNumItemsInsidePackageFormField extends ConsumerWidget {
  const ProductNumItemsInsidePackageFormField(this.initialValue, {super.key});
  final String? initialValue;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Expanded(
      child: TextFormField(
          initialValue: initialValue,
          textAlign: TextAlign.center,
          decoration: formFieldDecoration(S.of(context).product_num_items_inside_package),
          validator: (value) => utils.FormValidation.validateNameField(
              fieldValue: value,
              errorMessage: S.of(context).input_validation_error_message_for_numbers),
          onSaved: (value) {
            final product = ref.read(productStateNotifierProvider).product;
            ref
                .read(productStateNotifierProvider.notifier)
                .setProduct(product.copyWith(numItemsInsidePackage: int.parse(value!)));
          }),
    );
  }
}
