import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tablets/generated/l10n.dart';
import 'package:tablets/src/common/providers/image_picker_provider.dart';
import 'package:tablets/src/common/widgets/async_value_widget.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:tablets/src/common/constants/constants.dart' as constants;
import 'package:tablets/src/features/transactions/controllers/transaction_filter_controller_provider.dart';
import 'package:tablets/src/features/transactions/controllers/transaction_filtered_list_provider.dart';
import 'package:tablets/src/features/transactions/controllers/transaction_form_controller.dart';
import 'package:tablets/src/features/transactions/model/transaction.dart';
import 'package:tablets/src/features/transactions/repository/transaction_repository_provider.dart';
import 'package:tablets/src/features/transactions/view/transaction_form.dart';

class TransactionsTable extends ConsumerWidget {
  const TransactionsTable({super.key});

  void showEditReceiptForm(BuildContext context, WidgetRef ref, Transaction tansaction) {
    ref.read(transactionFormDataProvider.notifier).initialize(item: tansaction);
    final imagePicker = ref.read(imagePickerProvider.notifier);
    imagePicker.initialize(urls: tansaction.imageUrls);
    showDialog(
      context: context,
      builder: (BuildContext ctx) => const TransactionForm(isEditMode: true),
    ).whenComplete(imagePicker.close);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final transactionStream = ref.watch(transactionStreamProvider);
    final filterIsOn = ref.watch(transactionFilterSwitchProvider);
    final transactionsListValue =
        filterIsOn ? ref.read(transactionFilteredListProvider).getFilteredList() : transactionStream;
    return AsyncValueWidget<List<Map<String, dynamic>>>(
        value: transactionsListValue,
        data: (transactions) {
          List<DataRow2> rows = transactions.map((map) {
            Transaction transaction = Transaction.fromMap(map);
            return DataRow2(
              cells: [
                DataCell(Row(
                  children: [
                    InkWell(
                      child: const CircleAvatar(
                        radius: 15,
                        foregroundImage: CachedNetworkImageProvider(constants.defaultImageUrl),
                      ),
                      onTap: () => showEditReceiptForm(context, ref, transaction),
                    ),
                    const SizedBox(width: 20),
                    Text(transaction.name.toString()),
                  ],
                )),
                DataCell(Text(transaction.date.toString())),
                DataCell(Text(transaction.number.toString())),
                DataCell(Text(transaction.amount.toString())),
              ],
            );
          }).toList();
          return Padding(
            padding: const EdgeInsets.all(16),
            child: DataTable2(
              columnSpacing: 12,
              horizontalMargin: 12,
              minWidth: 400,
              columns: [
                DataColumn2(
                  label: Row(
                    children: [
                      const SizedBox(width: 50),
                      ColumnTitleText(S.of(context).transaction_name),
                    ],
                  ),
                  size: ColumnSize.S,
                ),
                DataColumn2(
                  label: ColumnTitleText(S.of(context).transaction_date),
                  size: ColumnSize.S,
                ),
                DataColumn2(
                  label: ColumnTitleText(S.of(context).transaction_number),
                  size: ColumnSize.S,
                ),
                DataColumn2(
                  label: ColumnTitleText(S.of(context).transaction_amount),
                  size: ColumnSize.S,
                ),
              ],
              rows: rows,
            ),
          );
        });
  }
}

class ColumnTitleText extends StatelessWidget {
  const ColumnTitleText(this.title, {super.key});
  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}
