import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tablets/generated/l10n.dart';
import 'package:tablets/src/common/values/constants.dart';
import 'package:tablets/src/common/widgets/form_fields/edit_box.dart';
import 'package:tablets/src/features/salesmen/controllers/salesman_form_controller.dart';

class SalesmanFormFields extends ConsumerWidget {
  const SalesmanFormFields({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formDataNotifier = ref.watch(salesmanFormDataProvider.notifier);
    return FormInputField(
      dataType: FieldDataType.string,
      name: 'name',
      label: S.of(context).salesman_name,
      initialValue: formDataNotifier.getProperty('name'),
      onChangedFn: (value) {
        formDataNotifier.updateProperties({'name': value});
      },
    );
  }
}
