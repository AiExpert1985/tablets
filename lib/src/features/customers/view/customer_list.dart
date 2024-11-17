import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tablets/src/common/classes/db_repository.dart';
import 'package:tablets/src/common/providers/image_picker_provider.dart';
import 'package:tablets/src/common/values/gaps.dart';
import 'package:tablets/src/common/values/settings.dart';
import 'package:tablets/src/common/widgets/main_screen_list_cells.dart';
import 'package:tablets/src/common/widgets/reload_page_button.dart';
import 'package:tablets/src/features/customers/controllers/customer_db_cache_provider.dart';
import 'package:tablets/src/features/customers/controllers/customer_form_data_notifier.dart';
import 'package:tablets/src/features/customers/controllers/customer_screen_controller.dart';
import 'package:tablets/src/features/customers/controllers/customer_screen_data_notifier.dart';
import 'package:tablets/src/features/customers/repository/customer_repository_provider.dart';
import 'package:tablets/src/features/customers/utils/customer_map_keys.dart';
import 'package:tablets/src/features/customers/utils/customer_report_utils.dart';
import 'package:tablets/src/features/customers/model/customer.dart';
import 'package:tablets/src/features/customers/view/customer_form.dart';
import 'package:tablets/generated/l10n.dart';
import 'package:tablets/src/common/classes/item_form_data.dart';
import 'package:tablets/src/common/values/constants.dart';
import 'package:tablets/src/features/transactions/repository/transaction_repository_provider.dart';
import 'package:tablets/src/routers/go_router_provider.dart';

class CustomerList extends ConsumerWidget {
  const CustomerList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final screenController = ref.read(customerScreenControllerProvider);
    final transactionProvider = ref.read(transactionRepositoryProvider);
    _fetchTransactions(transactionProvider);
    final customerDbCache = ref.read(customerDbCacheProvider.notifier);
    final customers = customerDbCache.data;
    ref.watch(customerDbCacheProvider); // important for reload button

    screenController.processCustomerTransactions(context, customers);
    Widget screenWidget = customers.isNotEmpty
        ? Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [const ListHeaders(), const Divider(), ListData(customers)],
            ),
          )
        : const ReLoadCustomerScreenButton();
    return screenWidget;
  }
}

class ListData extends ConsumerWidget {
  const ListData(this.customers, {super.key});
  final List<Map<String, dynamic>> customers;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Expanded(
      child: ListView.builder(
        itemCount: customers.length,
        itemBuilder: (ctx, index) {
          return Column(
            children: [DataRow(index), const Divider(thickness: 0.2, color: Colors.grey)],
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
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const MainScreenPlaceholder(width: 20, isExpanded: false),
            MainScreenHeaderCell(S.of(context).customer),
            MainScreenHeaderCell(S.of(context).salesman_selection),
            MainScreenHeaderCell(S.of(context).current_debt),
            MainScreenHeaderCell(S.of(context).num_open_invoice),
            MainScreenHeaderCell(S.of(context).due_debt_amount),
            MainScreenHeaderCell(S.of(context).average_invoice_closing_duration),
            if (!hideCustomerProfit) MainScreenHeaderCell(S.of(context).customer_invoice_profit),
            MainScreenHeaderCell(S.of(context).customer_gifts_and_discounts),
          ],
        ),
        VerticalGap.m,
        if (!hideMainScreenColumnTotals) const HeaderTotalsRow()
      ],
    );
  }
}

class DataRow extends ConsumerWidget {
  const DataRow(this.index, {super.key});
  final int index;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final screenDataNotifier = ref.read(customerScreenDataProvider.notifier);
    final screenData = screenDataNotifier.data[index];
    final imagePickerNotifier = ref.read(imagePickerProvider.notifier);
    final formDataNotifier = ref.read(customerFormDataProvider.notifier);
    final customer = screenData[customerKey]!['value'] as Customer;
    final invoiceAverageClosingDays = screenData[avgClosingDaysKey]!['value'] as int;
    final closedInvoices = screenData[avgClosingDaysKey]!['details'] as List<List<dynamic>>;
    final numOpenInvoices = screenData[openInvoicesKey]!['value'] as int;
    final openInvoices = screenData[openInvoicesKey]!['details'] as List<List<dynamic>>;
    final dueInvoices = screenData[avgClosingDaysKey]!['details'] as List<List<dynamic>>;
    final numDueInvoices = dueInvoices.length;
    final totalDebt = screenData[totalDebtKey]!['value'] as double;
    final matchingList = screenData[totalDebtKey]!['details'] as List<List<dynamic>>;
    final dueDebt = screenData[avgClosingDaysKey]!['value'];
    final invoiceWithProfit = screenData[invoicesProfitKey]!['details'] as List<List<dynamic>>;
    final profit = screenData[invoicesProfitKey]!['value'] as double;
    final giftTransactions = screenData[giftsKey]!['details'] as List<List<dynamic>>;
    final totalGiftsAmount = screenData[giftsKey]!['value'] as double;
    bool inValidCustomer = _inValidCustomer(dueDebt, totalDebt, customer);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          MainScreenEditButton(
              defaultImageUrl,
              () =>
                  _showEditCustomerForm(context, formDataNotifier, imagePickerNotifier, customer)),
          MainScreenTextCell(customer.name, isWarning: inValidCustomer),
          MainScreenTextCell(customer.salesman, isWarning: inValidCustomer),
          MainScreenClickableCell(
            totalDebt,
            () => showCustomerMatchingReport(context, matchingList, customer.name),
            isWarning: inValidCustomer,
          ),
          MainScreenClickableCell(
            '$numOpenInvoices ($numDueInvoices)',
            () =>
                showInvoicesReport(context, openInvoices, '${customer.name}  ( $numOpenInvoices )'),
            isWarning: inValidCustomer,
          ),
          MainScreenClickableCell(
            dueDebt,
            () => showInvoicesReport(context, dueInvoices, '${customer.name}  ( $numDueInvoices )'),
            isWarning: inValidCustomer,
          ),
          MainScreenClickableCell(
            invoiceAverageClosingDays,
            () => showInvoicesReport(
                context, closedInvoices, '${customer.name}  ( $invoiceAverageClosingDays )'),
            isWarning: inValidCustomer,
          ),
          if (!hideCustomerProfit)
            MainScreenClickableCell(
              profit,
              () => showProfitReport(context, invoiceWithProfit, customer.name),
              isWarning: inValidCustomer,
            ),
          MainScreenClickableCell(
            totalGiftsAmount,
            () => showGiftsReport(context, giftTransactions, customer.name),
            isWarning: inValidCustomer,
          ),
        ],
      ),
    );
  }
}

class HeaderTotalsRow extends ConsumerWidget {
  const HeaderTotalsRow({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    int totalOpenInvoices = _openInvoicesList
        .expand((innerList) => innerList) // Flatten the second level
        .where((mostInnerList) => mostInnerList.isNotEmpty) // Filter non-empty lists
        .length;
    int totalDueInvoices = _dueInvoicesList
        .expand((innerList) => innerList) // Flatten the second level
        .where((mostInnerList) => mostInnerList.isNotEmpty) // Filter non-empty lists
        .length;
    double totalDebtSum = _totalDebtList.reduce((a, b) => a + b);
    double totalDueDebtSum = _dueDebtList.reduce((a, b) => a + b);
    double totalProfitSum = _totalProfitList.reduce((a, b) => a + b);
    double totalGifts = _totalGiftsAmountList.reduce((a, b) => a + b);

    double averageClosingDays = _averageInvoiceClosingDaysList.isNotEmpty
        ? _averageInvoiceClosingDaysList.reduce((a, b) => a + b) /
            _averageInvoiceClosingDaysList.length
        : 0.0;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const MainScreenPlaceholder(width: 20, isExpanded: false),
        const MainScreenPlaceholder(),
        const MainScreenPlaceholder(),
        MainScreenHeaderCell(totalDebtSum, isColumnTotal: true),
        MainScreenHeaderCell('$totalOpenInvoices ($totalDueInvoices)'),
        MainScreenHeaderCell(totalDueDebtSum, isColumnTotal: true),
        MainScreenHeaderCell('($averageClosingDays ${S.of(context).days} )'),
        if (!hideCustomerProfit) MainScreenHeaderCell(totalProfitSum, isColumnTotal: true),
        MainScreenHeaderCell(totalGifts, isColumnTotal: true),
      ],
    );
  }
}

Future<void> _fetchTransactions(DbRepository transactionProvider) async {
  _transactionsList = await transactionProvider.fetchItemListAsMaps();
}

// we stop transactions if customer either exceeded limit of debt, or has dueDebt
// which is transactions that are not closed within allowed time (for example 20 days)
bool _inValidCustomer(double dueDebt, double totalDebt, Customer customer) {
  return totalDebt > customer.creditLimit || dueDebt > 0;
}

void _showEditCustomerForm(BuildContext context, ItemFormData formDataNotifier,
    ImageSliderNotifier imagePicker, Customer customer) {
  formDataNotifier.initialize(initialData: customer.toMap());
  imagePicker.initialize(urls: customer.imageUrls);
  showDialog(
    context: context,
    builder: (BuildContext ctx) => const CustomerForm(
      isEditMode: true,
    ),
  ).whenComplete(imagePicker.close);
}

class ReLoadCustomerScreenButton extends ConsumerWidget {
  const ReLoadCustomerScreenButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ReLoadScreenButton(
      () async {
        final customerData = await ref.read(customerRepositoryProvider).fetchItemListAsMaps();
        final customerDbCache = ref.read(customerDbCacheProvider.notifier);
        customerDbCache.setData(customerData);
        if (context.mounted) {
          context.goNamed(AppRoute.customers.name);
        }
      },
    );
  }
}
