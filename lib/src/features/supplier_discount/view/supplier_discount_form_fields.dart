import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tablets/generated/l10n.dart';
import 'package:tablets/src/common/values/constants.dart';
import 'package:tablets/src/common/widgets/form_fields/edit_box.dart';
import 'package:tablets/src/features/supplier_discount/controllers/supplier_discount_form_controller.dart';

class SupplierDiscountFormFields extends ConsumerWidget {
  const SupplierDiscountFormFields({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formDataNotifier = ref.watch(supplierDiscountFormDataProvider.notifier);
    return FormInputField(
      onChangedFn: (value) {
        formDataNotifier.updateProperties({'name': value});
      },
      dataType: FieldDataType.text,
      name: 'name',
      label: S.of(context).region_name,
      initialValue: formDataNotifier.getProperty('name'),
    );
  }
}
