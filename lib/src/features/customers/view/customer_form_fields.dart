import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tablets/generated/l10n.dart';
import 'package:tablets/src/common/values/constants.dart';
import 'package:tablets/src/common/values/gaps.dart';
import 'package:tablets/src/common/widgets/form_fields/drop_down_with_search.dart';
import 'package:tablets/src/common/widgets/form_fields/edit_box.dart';
import 'package:tablets/src/features/customers/controllers/customer_form_controller.dart';
import 'package:tablets/src/features/regions/repository/region_repository_provider.dart';
import 'package:tablets/src/features/salesmen/repository/salesman_repository_provider.dart';

class CustomerFormFields extends ConsumerWidget {
  const CustomerFormFields({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formDataNotifier = ref.watch(customerFormDataProvider.notifier);
    final salesmanRepository = ref.watch(salesmanRepositoryProvider);
    final regionRepository = ref.watch(regionRepositoryProvider);
    return Expanded(
      child: Column(
        children: [
          Row(children: [
            FormInputField(
              onChangedFn: (value) {
                formDataNotifier.updateProperties({'name': value});
              },
              initialValue: formDataNotifier.getProperty('name'),
              dataType: FieldDataType.string,
              name: 'name',
              label: S.of(context).salesman_name,
            ),
            HorizontalGap.m,
            DropDownWithSearchFormField(
              label: S.of(context).salesman_name,
              initialValue: formDataNotifier.getProperty('salesman'),
              dbRepository: salesmanRepository,
              onChangedFn: (item) {
                formDataNotifier.updateProperties({'salesman': item['name'], 'salesmanDbRef': item['dbRef']});
              },
            ),
          ]),
          VerticalGap.m,
          Row(
            children: [
              DropDownWithSearchFormField(
                label: S.of(context).region_name,
                initialValue: formDataNotifier.getProperty('region'),
                dbRepository: regionRepository,
                onChangedFn: (item) {
                  formDataNotifier.updateProperties({'region': item['name'], 'regionDbRef': item['dbRef']});
                },
              ),
              HorizontalGap.m,
              FormInputField(
                onChangedFn: (value) {
                  formDataNotifier.updateProperties({'phone': value});
                },
                initialValue: formDataNotifier.getProperty('phone'),
                dataType: FieldDataType.string,
                name: 'phone',
                label: S.of(context).phone,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
