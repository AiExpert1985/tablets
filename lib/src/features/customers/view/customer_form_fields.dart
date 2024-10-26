import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tablets/generated/l10n.dart';
import 'package:tablets/src/common/values/constants.dart';
import 'package:tablets/src/common/values/gaps.dart';
import 'package:tablets/src/common/widgets/form_fields/drop_down_with_search.dart';
import 'package:tablets/src/common/widgets/form_fields/edit_box.dart';
import 'package:tablets/src/features/customers/controllers/customer_form_controller.dart';
import 'package:tablets/src/features/customers/repository/customer_repository_provider.dart';
import 'package:tablets/src/features/salesmen/repository/salesman_repository_provider.dart';

class CustomerFormFields extends StatelessWidget {
  const CustomerFormFields({super.key, this.editMode = false});
  final bool editMode;
  @override
  Widget build(BuildContext context) {
    return CustomerFormInputField(
      dataType: FieldDataTypes.string,
      name: 'name',
      displayedTitle: S.of(context).salesman_name,
    );
  }
}

class CustomerFormInputField extends ConsumerWidget {
  const CustomerFormInputField({
    required this.dataType,
    required this.name,
    required this.displayedTitle,
    super.key,
  });

  final FieldDataTypes dataType;
  final String name;
  final String displayedTitle;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formController = ref.watch(customerFormDataProvider.notifier);
    final repository = ref.watch(salesmanRepositoryProvider);
    return Expanded(
      child: Column(
        children: [
          FormInputField(
              formData: formController.data,
              onChangedFn: formController.update,
              dataType: dataType,
              fieldName: name,
              label: displayedTitle),
          VerticalGap.formFieldToField,
          DropDownWithSearchFormField(
              formData: formController.data,
              onChangedFn: formController.update,
              fieldName: 'salesman',
              dbListFetchFn: repository.fetchItemListAsMaps,
              targetProperties: const {'salesman': 'name'})
        ],
      ),
    );
  }
}
