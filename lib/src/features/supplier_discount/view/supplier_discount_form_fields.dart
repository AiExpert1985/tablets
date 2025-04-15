import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tablets/generated/l10n.dart';
import 'package:tablets/src/common/values/constants.dart';
import 'package:tablets/src/common/values/gaps.dart';
import 'package:tablets/src/common/widgets/form_fields/edit_box.dart';
import 'package:tablets/src/features/supplier_discount/controllers/supplier_discount_form_controller.dart';

class SupplierDiscountFormFields extends ConsumerWidget {
  const SupplierDiscountFormFields({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        _buildFirstRow(ref),
        VerticalGap.xl,
        _buildSecondRow(ref),
        VerticalGap.xl,
        _buildThirdRow(ref),
      ],
    );
  }

  Widget _buildFirstRow(WidgetRef ref) {
    return Row(children: [
      _buildSupplierName(ref),
      HorizontalGap.xl,
      _buildProductName(ref),
    ]);
  }

  Widget _buildSecondRow(WidgetRef ref) {
    return Row(children: [
      _buildQuantity(ref),
      HorizontalGap.xl,
      _buildDiscountAmount(ref),
    ]);
  }

  Widget _buildThirdRow(WidgetRef ref) {
    return Row(children: [
      _buildDate(ref),
      HorizontalGap.xl,
      _buildNewPrice(ref),
    ]);
  }

  Widget _buildSupplierName(WidgetRef ref) {
    return const Text('hi');
  }

  Widget _buildProductName(WidgetRef ref) {
    return const Text('hi');
  }

  Widget _buildQuantity(WidgetRef ref) {
    final formDataNotifier = ref.watch(supplierDiscountFormDataProvider.notifier);
    return FormInputField(
      onChangedFn: (value) {
        formDataNotifier.updateProperties({'quantity': value});
      },
      dataType: FieldDataType.num,
      name: 'quantity',
      label: 'العدد',
      initialValue: formDataNotifier.getProperty('quantity'),
    );
  }

  Widget _buildDiscountAmount(WidgetRef ref) {
    final formDataNotifier = ref.watch(supplierDiscountFormDataProvider.notifier);
    return FormInputField(
      onChangedFn: (value) {
        formDataNotifier.updateProperties({'discountAmount': value});
      },
      dataType: FieldDataType.num,
      name: 'discountAmount',
      label: 'مبلغ التخفيض',
      initialValue: formDataNotifier.getProperty('discountAmount'),
    );
  }

  Widget _buildDate(WidgetRef ref) {
    return const Text('hi');
  }

  Widget _buildNewPrice(WidgetRef ref) {
    final formDataNotifier = ref.watch(supplierDiscountFormDataProvider.notifier);
    return FormInputField(
      onChangedFn: (value) {
        formDataNotifier.updateProperties({'newPrice': value});
      },
      dataType: FieldDataType.num,
      name: 'name',
      label: 'السعر الجديد',
      initialValue: formDataNotifier.getProperty('newPrice'),
    );
  }
}


    // final formDataNotifier = ref.watch(supplierDiscountFormDataProvider.notifier);
    // return FormInputField(
    //   onChangedFn: (value) {
    //     formDataNotifier.updateProperties({'name': value});
    //   },
    //   dataType: FieldDataType.text,
    //   name: 'name',
    //   label: S.of(context).region_name,
    //   initialValue: formDataNotifier.getProperty('name'),
    // );
