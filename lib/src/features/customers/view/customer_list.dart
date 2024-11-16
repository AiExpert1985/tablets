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
import 'package:tablets/src/features/customers/repository/customer_repository_provider.dart';
import 'package:tablets/src/features/customers/utils/customer_report_utils.dart';
import 'package:tablets/src/features/customers/utils/process_customer_invoices.dart';
import 'package:tablets/src/features/customers/model/customer.dart';
import 'package:tablets/src/features/customers/utils/customer_screen_utils.dart';
import 'package:tablets/src/features/customers/view/customer_form.dart';
import 'package:tablets/generated/l10n.dart';
import 'package:tablets/src/common/classes/item_form_data.dart';
import 'package:tablets/src/common/values/constants.dart';
import 'package:tablets/src/features/transactions/model/transaction.dart';
import 'package:tablets/src/features/transactions/repository/transaction_repository_provider.dart';
import 'package:tablets/src/routers/go_router_provider.dart';

List<Map<String, dynamic>> _transactionsList = [];
List<Customer> _customersList = [];
List<List<Map<String, dynamic>>> _customerTransactionsList = [];
List<List<List<dynamic>>> _processedInvoicesList = [];
List<List<List<dynamic>>> _closedInvoicesList = [];
List<List<List<dynamic>>> _openInvoicesList = [];
List<double> _totalDebtList = [];
List<List<List<dynamic>>> _dueInvoicesList = [];
List<double> _dueDebtList = [];
List<int> _averageInvoiceClosingDaysList = [];
List<List<List<dynamic>>> _invoicesWithProfitList = [];
List<double> _totalProfitList = [];
List<List<List<dynamic>>> _giftsAndDiscountsList = [];
List<double> _totalGiftsAmountList = [];

void _processCustomerTransactions(BuildContext context, List<Map<String, dynamic>> customers) {
  _resetGlobalLists();
  for (var customerData in customers) {
    final customer = Customer.fromMap(customerData);
    _updateGlobalLists(context, customer);
  }
}

void _updateGlobalLists(BuildContext context, Customer customer) {
  _customersList.add(customer);
  final customerTransactions = getCustomerTransactions(_transactionsList, customer.dbRef);
  _customerTransactionsList.add(customerTransactions);
  // if customer has initial credit, it should be added to the tansactions, so, we add
  // it here and give it transaction type 'initialCredit'
  if (customer.initialCredit > 0) {
    customerTransactions.add(Transaction(
      dbRef: 'na',
      name: customer.name,
      imageUrls: ['na'],
      number: 1000001,
      date: customer.initialDate,
      currency: 'na',
      transactionType: TransactionType.initialCredit.name,
      totalAmount: customer.initialCredit,
    ).toMap());
  }
  final processedInvoices = getCustomerProcessedInvoices(context, customerTransactions, customer);
  _processedInvoicesList.add(processedInvoices);
  final invoicesWithProfit = getInvoicesWithProfit(processedInvoices);
  _invoicesWithProfitList.add(invoicesWithProfit);
  final totalProfit = getTotalProfit(invoicesWithProfit, 5);
  _totalProfitList.add(totalProfit);
  final closedInvoices = getClosedInvoices(context, processedInvoices, 5);
  _closedInvoicesList.add(closedInvoices);
  final averageClosingDays = calculateAverageClosingDays(closedInvoices, 6);
  _averageInvoiceClosingDaysList.add(averageClosingDays);
  final openInvoices = getOpenInvoices(context, processedInvoices, 5);
  _openInvoicesList.add(openInvoices);
  final totalDebt = getTotalDebt(openInvoices, 7);
  _totalDebtList.add(totalDebt);
  final dueInvoices = getDueInvoices(context, openInvoices, 5);
  _dueInvoicesList.add(dueInvoices);
  final dueDebt = getDueDebt(dueInvoices, 7);
  _dueDebtList.add(dueDebt);
  final giftsAndDicounts = getGiftsAndDiscounts(context, customerTransactions);
  _giftsAndDiscountsList.add(giftsAndDicounts);
  final totalGiftsAmount = getTotalGiftsAndDiscounts(giftsAndDicounts, 4);
  _totalGiftsAmountList.add(totalGiftsAmount);
}

void _resetGlobalLists() {
  _customersList = [];
  _customerTransactionsList = [];
  _processedInvoicesList = [];
  _closedInvoicesList = [];
  _openInvoicesList = [];
  _totalDebtList = [];
  _dueInvoicesList = [];
  _dueDebtList = [];
  _averageInvoiceClosingDaysList = [];
  _invoicesWithProfitList = [];
  _totalProfitList = [];
  _giftsAndDiscountsList = [];
  _totalGiftsAmountList = [];
}

class CustomerList extends ConsumerWidget {
  const CustomerList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final transactionProvider = ref.read(transactionRepositoryProvider);
    _fetchTransactions(transactionProvider);
    final customerDbCache = ref.read(customerDbCacheProvider.notifier);
    final customers = customerDbCache.data;
    ref.watch(customerDbCacheProvider); // important for reload button

    _processCustomerTransactions(context, customers);
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
    final imagePickerNotifier = ref.read(imagePickerProvider.notifier);
    final formDataNotifier = ref.read(customerFormDataProvider.notifier);
    final customer = _customersList[index];
    final customerTransactions = _customerTransactionsList[index];
    final closedInvoices = _closedInvoicesList[index];
    final invoiceAverageClosingDays = _averageInvoiceClosingDaysList[index];
    final openInvoices = _openInvoicesList[index];
    final numOpenInvoices = openInvoices.length;
    final dueInvoices = _dueInvoicesList[index];
    final numDueInvoices = dueInvoices.length;
    final totalDebt = _totalDebtList[index];
    final dueDebt = _dueDebtList[index];
    final invoiceWithProfit = _invoicesWithProfitList[index];
    final profit = _totalProfitList[index];
    final giftsAndDiscounts = _giftsAndDiscountsList[index];
    final totalGiftsAmount = _totalGiftsAmountList[index];
    final matchingList = customerMatching(customerTransactions, customer, context);
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
            () => showGiftsReport(context, giftsAndDiscounts, customer.name),
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
