import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tablets/generated/l10n.dart';
import 'package:tablets/src/common/values/constants.dart';
import 'package:tablets/src/common/values/gaps.dart';
import 'package:tablets/src/common/widgets/form_fields/drop_down_with_search.dart';
import 'package:tablets/src/common/widgets/form_fields/edit_box.dart';
import 'package:tablets/src/features/customers/controllers/customer_form_controller.dart';
import 'package:tablets/src/features/salesmen/repository/salesman_repository_provider.dart';

class CustomerFormFields extends ConsumerWidget {
  const CustomerFormFields({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formDataNotifier = ref.watch(customerFormDataProvider.notifier);
    final repository = ref.watch(salesmanRepositoryProvider);
    return Expanded(
      child: Column(
        children: [
          FormInputField(
            onChangedFn: (value) {
              formDataNotifier.updateProperties({'name': value});
            },
            initialValue: formDataNotifier.getProperty('name'),
            dataType: FieldDataType.string,
            name: 'name',
            label: S.of(context).salesman_name,
          ),
          VerticalGap.formFieldToField,
          DropDownWithSearchFormField(
            initialValue: formDataNotifier.getProperty('salesman'),
            dbRepository: repository,
            onChangedFn: (item) {
              formDataNotifier.updateProperties({'salesman': item['name']});
            },
          )
        ],
      ),
    );
  }
}
