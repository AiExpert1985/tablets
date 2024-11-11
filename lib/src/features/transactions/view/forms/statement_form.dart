import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tablets/generated/l10n.dart';
import 'package:tablets/src/common/classes/db_repository.dart';
import 'package:tablets/src/common/classes/item_form_data.dart';
import 'package:tablets/src/common/providers/text_editing_controllers_provider.dart';
import 'package:tablets/src/common/values/settings.dart' as settings;
import 'package:tablets/src/common/widgets/form_fields/date_picker.dart';
import 'package:tablets/src/common/values/constants.dart' as constants;
import 'package:tablets/src/common/values/gaps.dart';
import 'package:tablets/src/common/widgets/form_fields/drop_down_with_search.dart';
import 'package:tablets/src/common/widgets/form_fields/edit_box.dart';
import 'package:tablets/src/features/customers/repository/customer_repository_provider.dart';
import 'package:tablets/src/features/products/repository/product_repository_provider.dart';
import 'package:tablets/src/features/salesmen/repository/salesman_repository_provider.dart';
import 'package:tablets/src/features/transactions/controllers/transaction_form_controller.dart';
import 'package:tablets/src/common/widgets/form_title.dart';
import 'package:tablets/src/features/transactions/view/forms/item_list.dart';
import 'package:tablets/src/common/values/transactions_common_values.dart';
import 'package:tablets/src/features/vendors/repository/vendor_repository_provider.dart';

class StatementForm extends ConsumerWidget {
  const StatementForm(this.title, {this.isGift = false, super.key});

  final String title;
  final bool isGift;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formDataNotifier = ref.read(transactionFormDataProvider.notifier);
    final textEditingNotifier = ref.read(textFieldsControllerProvider.notifier);
    final salesmanRepository = ref.read(salesmanRepositoryProvider);
    final customerRepository = ref.read(customerRepositoryProvider);
    final vendorRepository = ref.read(vendorRepositoryProvider);
    final productRepository = ref.read(productRepositoryProvider);
    final counterPartyRepository = isGift ? vendorRepository : customerRepository;
    ref.watch(transactionFormDataProvider);

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 18),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            buildFormTitle(title),
            VerticalGap.xl,
            if (isGift)
              _buildFirstRow(context, formDataNotifier, counterPartyRepository, salesmanRepository),
            VerticalGap.m,
            _buildSecondRow(context, formDataNotifier),
            VerticalGap.m,
            _buildThirdRow(context, formDataNotifier),
            VerticalGap.m,
            _buildFourthRow(context, formDataNotifier),
            VerticalGap.m,
            buildItemList(
                context, formDataNotifier, textEditingNotifier, productRepository, true, true),
          ],
        ),
      ),
    );
  }

  Widget _buildFirstRow(BuildContext context, ItemFormData formDataNotifier,
      DbRepository repository, DbRepository salesmanRepository) {
    return Row(
      children: [
        DropDownWithSearchFormField(
          label: S.of(context).customer,
          initialValue: formDataNotifier.getProperty(nameKey),
          dbRepository: repository,
          onChangedFn: (item) {
            formDataNotifier.updateProperties({
              nameKey: item[nameKey],
              salesmanKey: item[salesmanKey],
            });
          },
        ),
        HorizontalGap.l,
        DropDownWithSearchFormField(
          label: S.of(context).transaction_salesman,
          initialValue: formDataNotifier.getProperty(salesmanKey),
          dbRepository: salesmanRepository,
          onChangedFn: (item) {
            formDataNotifier.updateProperties({salesmanKey: item[nameKey]});
          },
        ),
      ],
    );
  }

  Widget _buildSecondRow(BuildContext context, ItemFormData formDataNotifier) {
    return Row(
      children: [
        FormInputField(
          dataType: constants.FieldDataType.num,
          name: numberKey,
          label: S.of(context).transaction_number,
          initialValue: formDataNotifier.getProperty(numberKey),
          onChangedFn: (value) {
            formDataNotifier.updateProperties({numberKey: value});
          },
        ),
        HorizontalGap.l,
        FormDatePickerField(
          initialValue: formDataNotifier.getProperty(dateKey) is Timestamp
              ? formDataNotifier.getProperty(dateKey).toDate()
              : formDataNotifier.getProperty(dateKey),
          name: dateKey,
          label: S.of(context).transaction_date,
          onChangedFn: (date) {
            formDataNotifier.updateProperties({dateKey: Timestamp.fromDate(date!)});
          },
        ),
      ],
    );
  }

  Widget _buildThirdRow(BuildContext context, ItemFormData formDataNotifier) {
    return Row(
      children: [
        FormInputField(
          isRequired: false,
          dataType: constants.FieldDataType.text,
          name: notesKey,
          label: S.of(context).transaction_notes,
          initialValue: formDataNotifier.getProperty(notesKey),
          onChangedFn: (value) {
            formDataNotifier.updateProperties({notesKey: value});
          },
        ),
      ],
    );
  }

  Widget _buildFourthRow(BuildContext context, ItemFormData formDataNotifier) {
    return Visibility(
      visible: settings.writeTotalAmountAsText,
      child: Row(
        children: [
          FormInputField(
            isRequired: false,
            dataType: constants.FieldDataType.text,
            name: totalAsTextKey,
            label: S.of(context).transaction_total_amount_as_text,
            initialValue: formDataNotifier.getProperty(totalAsTextKey),
            onChangedFn: (value) {
              formDataNotifier.updateProperties({totalAsTextKey: value});
            },
          ),
        ],
      ),
    );
  }
}
