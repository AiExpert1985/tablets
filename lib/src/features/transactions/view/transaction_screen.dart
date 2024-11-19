import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tablets/src/common/widgets/main_frame.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:tablets/src/common/providers/background_color.dart';
import 'package:tablets/src/features/transactions/controllers/transaction_drawer_provider.dart';
import 'package:tablets/src/features/transactions/repository/transaction_repository_provider.dart';
import 'package:tablets/src/features/transactions/view/transaction_group_selection.dart';
import 'package:tablets/generated/l10n.dart';
import 'package:tablets/src/common/functions/utils.dart';
import 'package:tablets/src/common/providers/image_picker_provider.dart';
import 'package:tablets/src/common/providers/text_editing_controllers_provider.dart';
import 'package:tablets/src/common/values/constants.dart';
import 'package:tablets/src/common/widgets/home_screen.dart';
import 'package:tablets/src/common/widgets/main_screen_list_cells.dart';
import 'package:tablets/src/features/transactions/controllers/transaction_db_cache_provider.dart';
import 'package:tablets/src/features/transactions/controllers/transaction_form_controller.dart';
import 'package:tablets/src/features/transactions/model/transaction.dart';
import 'package:tablets/src/features/transactions/view/transaction_show_form_utils.dart';

class TransactionsScreen extends ConsumerWidget {
  const TransactionsScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return const AppScreenFrame(
      TransactionsList(),
      buttonsWidget: TransactionsFloatingButtons(),
    );
  }
}

class TransactionsList extends ConsumerWidget {
  const TransactionsList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dbCache = ref.read(transactionDbCacheProvider.notifier);
    final dbData = dbCache.data;
    sortListOfMapsByDate(dbData, 'date');
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

    final transactionTypeScreenName =
        translateDbTextToScreenText(context, transaction.transactionType);

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            MainScreenEditButton(
                defaultImageUrl, () => _showEditTransactionForm(context, ref, transaction)),
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

_showEditTransactionForm(BuildContext context, WidgetRef ref, Transaction transaction) {
  final imagePickerNotifier = ref.read(imagePickerProvider.notifier);
  final formDataNotifier = ref.read(transactionFormDataProvider.notifier);
  final textEditingNotifier = ref.read(textFieldsControllerProvider.notifier);
  final backgroundColorNofifier = ref.read(backgroundColorProvider.notifier);
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
}

class TransactionsFloatingButtons extends ConsumerWidget {
  const TransactionsFloatingButtons({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final drawerController = ref.watch(transactionDrawerControllerProvider);
    const iconsColor = Color.fromARGB(255, 126, 106, 211);
    return SpeedDial(
      direction: SpeedDialDirection.up,
      switchLabelPosition: false,
      animatedIcon: AnimatedIcons.menu_close,
      spaceBetweenChildren: 10,
      animatedIconTheme: const IconThemeData(size: 28.0),
      visible: true,
      curve: Curves.bounceInOut,
      children: [
        SpeedDialChild(
            child: const Icon(Icons.pie_chart, color: Colors.white),
            backgroundColor: iconsColor,
            onTap: () async {
              final allTransactions =
                  await ref.read(transactionRepositoryProvider).fetchItemListAsMaps();
              if (context.mounted) {
                drawerController.showReports(context, allTransactions);
              }
            }),
        SpeedDialChild(
          child: const Icon(Icons.search, color: Colors.white),
          backgroundColor: iconsColor,
          onTap: () => drawerController.showSearchForm(context),
        ),
        SpeedDialChild(
          child: const Icon(Icons.add, color: Colors.white),
          backgroundColor: iconsColor,
          onTap: () {
            // reset background color when form is closed
            ref.read(backgroundColorProvider.notifier).state = Colors.white;
            showDialog(
              context: context,
              builder: (BuildContext ctx) => const TransactionGroupSelection(),
            ).whenComplete(() {});
          },
        ),
      ],
    );
  }
}
