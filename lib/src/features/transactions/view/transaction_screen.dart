import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tablets/src/common/functions/debug_print.dart';
import 'package:tablets/src/common/providers/page_is_loading_notifier.dart';
import 'package:tablets/src/common/values/features_keys.dart';
import 'package:tablets/src/common/widgets/main_frame.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:tablets/src/common/providers/background_color.dart';
import 'package:tablets/src/features/transactions/controllers/transaction_drawer_provider.dart';
import 'package:tablets/src/features/transactions/controllers/transaction_form_data_notifier.dart';
import 'package:tablets/src/features/transactions/controllers/transaction_screen_data_notifier.dart';
import 'package:tablets/src/features/transactions/repository/transaction_repository_provider.dart';
import 'package:tablets/src/features/transactions/view/transaction_from_selection_dialog.dart';
import 'package:tablets/generated/l10n.dart';
import 'package:tablets/src/common/functions/utils.dart';
import 'package:tablets/src/common/providers/image_picker_provider.dart';
import 'package:tablets/src/common/providers/text_editing_controllers_provider.dart';
import 'package:tablets/src/common/values/constants.dart';
import 'package:tablets/src/common/widgets/home_screen.dart';
import 'package:tablets/src/common/widgets/main_screen_list_cells.dart';
import 'package:tablets/src/features/transactions/repository/transaction_db_cache_provider.dart';
import 'package:tablets/src/features/transactions/model/transaction.dart';
import 'package:tablets/src/features/transactions/view/transaction_show_form.dart';

class TransactionsScreen extends ConsumerWidget {
  const TransactionsScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(transactionDbCacheProvider);
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
    sortMapsByProperty(dbData, 'date');
    ref.watch(transactionScreenDataNotifier);
    final pageIsLoading = ref.read(pageIsLoadingNotifier);
    ref.watch(pageIsLoadingNotifier);
    if (pageIsLoading) {
      return const PageLoading();
    }
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
    final screenDataNotifier = ref.read(transactionScreenDataNotifier.notifier);
    final screenData = screenDataNotifier.data;
    ref.watch(transactionScreenDataNotifier);
    return Expanded(
      child: ListView.builder(
        itemCount: screenData.length,
        itemBuilder: (ctx, index) {
          final transactionData = screenData[index];
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

class ListHeaders extends ConsumerWidget {
  const ListHeaders({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final screenDataNotifier = ref.read(transactionScreenDataNotifier.notifier);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const MainScreenPlaceholder(width: 20, isExpanded: false),
        SortableMainScreenHeaderCell(
            screenDataNotifier, 'transactionType', S.of(context).transaction_type),
        SortableMainScreenHeaderCell(screenDataNotifier, 'date', S.of(context).transaction_date),
        SortableMainScreenHeaderCell(screenDataNotifier, 'name', S.of(context).transaction_name),
        SortableMainScreenHeaderCell(
            screenDataNotifier, 'salesman', S.of(context).salesman_selection),
        SortableMainScreenHeaderCell(
            screenDataNotifier, 'number', S.of(context).transaction_number),
        SortableMainScreenHeaderCell(
            screenDataNotifier, 'totalAmount', S.of(context).transaction_amount),
        SortableMainScreenHeaderCell(screenDataNotifier, 'notes', S.of(context).notes),
      ],
    );
  }
}

class DataRow extends ConsumerWidget {
  const DataRow(this.transactionScreenData, {super.key});
  final Map<String, dynamic> transactionScreenData;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productRef = transactionScreenData[productDbRefKey];
    final productDbCache = ref.read(transactionDbCacheProvider.notifier);
    final transactionData = productDbCache.getItemByDbRef(productRef);
    final transaction = Transaction.fromMap(transactionData);
    final transactionTypeScreenName =
        translateDbTextToScreenText(context, transactionScreenData['transactionType']);
    final date = (transactionScreenData['date']).toDate();
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(3.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              MainScreenEditButton(
                  defaultImageUrl, () => _showEditTransactionForm(context, ref, transaction)),
              MainScreenTextCell(transactionTypeScreenName),
              MainScreenTextCell(date),
              MainScreenTextCell(transactionScreenData['name']),
              MainScreenTextCell(transactionScreenData['salesman']),
              MainScreenTextCell(transactionScreenData['number']),
              MainScreenTextCell(transactionScreenData['totalAmount']),
              MainScreenTextCell(transactionScreenData['notes']),
            ],
          ),
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
  TransactionShowForm.showForm(
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
