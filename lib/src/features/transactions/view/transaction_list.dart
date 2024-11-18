import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tablets/generated/l10n.dart';
import 'package:tablets/src/common/functions/utils.dart';
import 'package:tablets/src/common/providers/background_color.dart';
import 'package:tablets/src/common/providers/image_picker_provider.dart';
import 'package:tablets/src/common/providers/text_editing_controllers_provider.dart';
import 'package:tablets/src/common/values/constants.dart';
import 'package:tablets/src/common/widgets/home_screen.dart';
import 'package:tablets/src/common/widgets/main_screen_list_cells.dart';
import 'package:tablets/src/features/transactions/controllers/transaction_db_cache_provider.dart';
import 'package:tablets/src/features/transactions/controllers/transaction_form_controller.dart';
import 'package:tablets/src/features/transactions/model/transaction.dart';
import 'package:tablets/src/features/transactions/view/transaction_show_form_utils.dart';

class TransactionsList extends ConsumerWidget {
  const TransactionsList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dbCache = ref.read(transactionDbCacheProvider.notifier);
    final dbData = dbCache.data;
    dbData.sort((a, b) {
      DateTime dateA = a['date'].toDate();
      DateTime dateB = b['date'].toDate();
      return dateB.compareTo(dateA);
    });
    ref.watch(transactionDbCacheProvider);

    Widget screenWidget = dbData.isNotEmpty
        ? const Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              children: [
                ListHeaders(),
                Divider(),
                ListData(),
              ],
            ),
          )
        : const HomeScreenGreeting();
    return screenWidget;
  }
}

class ListData extends ConsumerWidget {
  const ListData({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dbCache = ref.read(transactionDbCacheProvider.notifier);
    final dbData = dbCache.data;
    ref.watch(transactionDbCacheProvider);
    return Expanded(
      child: ListView.builder(
        itemCount: dbData.length,
        itemBuilder: (ctx, index) {
          final transactionData = dbData[index];
          return Column(
            children: [
              DataRow(transactionData),
              const Divider(thickness: 0.2, color: Colors.grey),
            ],
          );
        },
      ),
    );
  }
}

class ListHeaders extends StatelessWidget {
  const ListHeaders({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const MainScreenPlaceholder(width: 20, isExpanded: false),
        MainScreenHeaderCell(S.of(context).transaction_type),
        MainScreenHeaderCell(S.of(context).transaction_date),
        MainScreenHeaderCell(S.of(context).transaction_name),
        MainScreenHeaderCell(S.of(context).transaction_number),
        MainScreenHeaderCell(S.of(context).transaction_amount),
      ],
    );
  }
}

class DataRow extends ConsumerWidget {
  const DataRow(this.transactionData, {super.key});
  final Map<String, dynamic> transactionData;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final transaction = Transaction.fromMap(transactionData);
    final imagePickerNotifier = ref.read(imagePickerProvider.notifier);
    final formDataNotifier = ref.read(transactionFormDataProvider.notifier);
    final textEditingNotifier = ref.read(textFieldsControllerProvider.notifier);
    final backgroundColorNofifier = ref.read(backgroundColorProvider.notifier);
    final transactionTypeScreenName =
        translateDbTextToScreenText(context, transaction.transactionType);

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            InkWell(
              child: const CircleAvatar(
                radius: 15,
                foregroundImage: CachedNetworkImageProvider(defaultImageUrl),
              ),
              onTap: () {
                backgroundColorNofifier.state = Colors.white;
                TransactionShowFormUtils.showForm(
                  context,
                  imagePickerNotifier,
                  formDataNotifier,
                  textEditingNotifier,
                  backgroundColorNofifier,
                  transaction: transaction,
                  formType: transaction.transactionType,
                );
              },
            ),
            MainScreenTextCell(transactionTypeScreenName),
            MainScreenTextCell(transaction.date),
            MainScreenTextCell(transaction.name),
            MainScreenTextCell(transaction.number),
            MainScreenTextCell(transaction.totalAmount),
          ],
        ),
      ],
    );
  }
}
