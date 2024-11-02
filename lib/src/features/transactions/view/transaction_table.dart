import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:tablets/generated/l10n.dart';
import 'package:tablets/src/common/classes/item_form_data.dart';
import 'package:tablets/src/common/functions/utils.dart';
import 'package:tablets/src/common/providers/image_picker_provider.dart';
import 'package:tablets/src/common/providers/text_editing_controllers_provider.dart';
import 'package:tablets/src/common/values/constants.dart';
import 'package:tablets/src/common/widgets/async_value_widget.dart';
import 'package:tablets/src/features/transactions/controllers/transaction_filter_controller_provider.dart';
import 'package:tablets/src/features/transactions/controllers/transaction_filtered_list_provider.dart';
import 'package:tablets/src/features/transactions/controllers/transaction_form_controller.dart';
import 'package:tablets/src/features/transactions/model/transaction.dart';
import 'package:tablets/src/features/transactions/repository/transaction_repository_provider.dart';
import 'package:tablets/src/features/transactions/view/forms/common_utils/transaction_show_form_utils.dart';

class TransactionsList extends ConsumerWidget {
  const TransactionsList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textFieldNotifier = ref.read(textFieldsControllerProvider.notifier);
    final imagePickerNotifier = ref.read(imagePickerProvider.notifier);
    final formDataNotifier = ref.read(transactionFormDataProvider.notifier);
    final transactionStream = ref.watch(transactionStreamProvider);
    final filterIsOn = ref.watch(transactionFilterSwitchProvider);
    final transactionsListValue = filterIsOn
        ? ref.read(transactionFilteredListProvider).getFilteredList()
        : transactionStream;

    return AsyncValueWidget<List<Map<String, dynamic>>>(
      value: transactionsListValue,
      data: (transactions) {
        return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              _buildHeaderRow(context),
              const SizedBox(height: 19),
              _buildHorizontalLine(), // Add some space between header and data
              Expanded(
                child: ListView.builder(
                  itemCount: transactions.length,
                  itemBuilder: (context, index) {
                    final transaction = Transaction.fromMap(transactions[index]);
                    return _buildTransactionRow(transaction, context, imagePickerNotifier,
                        formDataNotifier, textFieldNotifier);
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildHeaderRow(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(child: _buildHeader(S.of(context).transaction_type)),
        Expanded(child: _buildHeader(S.of(context).transaction_date)),
        Expanded(child: _buildHeader(S.of(context).transaction_name)),
        Expanded(child: _buildHeader(S.of(context).transaction_number)),
        Expanded(child: _buildHeader(S.of(context).transaction_amount)),
      ],
    );
  }

  Widget _buildTransactionRow(
      Transaction transaction,
      BuildContext context,
      ImageSliderNotifier imagePickerNotifier,
      ItemFormData formDataNotifier,
      TextControllerNotifier textFieldNotifier) {
    final transactionTypeScreenName =
        transactionTypeDbNameToScreenName(context, transaction.transactionType);

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: InkWell(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const CircleAvatar(
                      radius: 15,
                      foregroundImage: CachedNetworkImageProvider(defaultImageUrl),
                    ),
                    const SizedBox(width: 8),
                    Text(transactionTypeScreenName),
                  ],
                ),
                onTap: () => TransactionShowFormUtils.showForm(
                  context,
                  imagePickerNotifier,
                  formDataNotifier,
                  textFieldNotifier,
                  formType: TransactionType.customerInvoice.name,
                  transaction: transaction,
                ),
              ),
            ),
            Expanded(child: _buildDataCell(formatDate(transaction.date))),
            Expanded(child: _buildDataCell(transaction.name)),
            Expanded(child: _buildDataCell(transaction.number.toString())),
            Expanded(child: _buildDataCell(transaction.totalAmount.toString())),
          ],
        ),
        const SizedBox(height: 4), // Space between row and divider
        _buildHorizontalLine()
      ],
    );
  }

  Widget _buildDataCell(String text) {
    return Text(
      text,
      textAlign: TextAlign.center,
      style: const TextStyle(fontSize: 16),
    );
  }

  Widget _buildHeader(String text) {
    return Text(
      text,
      textAlign: TextAlign.center,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildHorizontalLine() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      height: 1, // Height of the divider
      color: Colors.grey[300], // Light gray color
    );
  }

  String formatDate(DateTime date) => DateFormat('yyyy/MM/dd').format(date);
}
