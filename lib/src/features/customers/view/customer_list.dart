import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tablets/src/common/classes/db_repository.dart';
import 'package:tablets/src/common/providers/image_picker_provider.dart';
import 'package:tablets/src/common/values/gaps.dart';
import 'package:tablets/src/common/values/settings.dart';
import 'package:tablets/src/common/widgets/async_value_widget.dart';
import 'package:tablets/src/common/widgets/form_fields/build_screen_column_cell.dart';
import 'package:tablets/src/features/customers/controllers/customer_filter_controller_.dart';
import 'package:tablets/src/features/customers/controllers/customer_filtered_list.dart';
import 'package:tablets/src/features/customers/controllers/customer_form_controller.dart';
import 'package:tablets/src/features/customers/utils/customer_report_utils.dart';
import 'package:tablets/src/features/customers/utils/process_customer_invoices.dart';
import 'package:tablets/src/features/customers/model/customer.dart';
import 'package:tablets/src/features/customers/repository/customer_repository_provider.dart';
import 'package:tablets/src/features/customers/utils/customer_screen_utils.dart';
import 'package:tablets/src/features/customers/view/customer_form.dart';
import 'package:tablets/generated/l10n.dart';
import 'package:tablets/src/common/classes/item_form_data.dart';
import 'package:tablets/src/common/values/constants.dart';
import 'package:tablets/src/features/transactions/model/transaction.dart';
import 'package:tablets/src/features/transactions/repository/transaction_repository_provider.dart';

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

Widget buildCustomerList(BuildContext context, WidgetRef ref) {
  final transactionProvider = ref.read(transactionRepositoryProvider);
  _fetchTransactions(transactionProvider);
  final formDataNotifier = ref.read(customerFormDataProvider.notifier);
  final customertStream = ref.watch(customerStreamProvider);
  final filterIsOn = ref.watch(customerFilterSwitchProvider);
  final imagePickerNotifier = ref.read(imagePickerProvider.notifier);
  final customerListValue =
      filterIsOn ? ref.read(customerFilteredListProvider).getFilteredList() : customertStream;

  return AsyncValueWidget<List<Map<String, dynamic>>>(
    value: customerListValue,
    data: (customers) {
      _processCustomerTransactions(context, customers);
      return Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildListHeaders(context),
            const Divider(),
            _buildListData(context, customers, formDataNotifier, imagePickerNotifier)
          ],
        ),
      );
    },
  );
}

Widget _buildListData(BuildContext context, List<Map<String, dynamic>> customers,
    ItemFormData formDataNotifier, ImageSliderNotifier imagePickerNotifier) {
  return Expanded(
    child: ListView.builder(
      itemCount: customers.length,
      itemBuilder: (ctx, index) {
        return Column(
          children: [
            _buildDataRow(ctx, index, imagePickerNotifier, formDataNotifier),
            const Divider(thickness: 0.2, color: Colors.grey)
          ],
        );
      },
    ),
  );
}

Widget _buildListHeaders(BuildContext context) {
  return Column(
    children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          buildMainScreenPlaceholder(width: 20, isExpanded: false),
          buildMainScreenHeaderCell(S.of(context).customer),
          buildMainScreenHeaderCell(S.of(context).salesman_selection),
          buildMainScreenHeaderCell(S.of(context).current_debt),
          buildMainScreenHeaderCell(S.of(context).num_open_invoice),
          buildMainScreenHeaderCell(S.of(context).due_debt_amount),
          buildMainScreenHeaderCell(S.of(context).average_invoice_closing_duration),
          if (!hideCustomerProfit) buildMainScreenHeaderCell(S.of(context).customer_invoice_profit),
          buildMainScreenHeaderCell(S.of(context).customer_gifts_and_discounts),
        ],
      ),
      VerticalGap.m,
      if (!hideMainScreenColumnTotals) _buildHeaderTotalsRow(context)
    ],
  );
}

Widget _buildDataRow(
  BuildContext context,
  int index,
  ImageSliderNotifier imagePickerNotifier,
  ItemFormData formDataNotifier,
) {
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
        buildMainScreenEditButton(defaultImageUrl,
            () => _showEditCustomerForm(context, formDataNotifier, imagePickerNotifier, customer)),
        buildMainScreenTextCell(customer.name, isWarning: inValidCustomer),
        buildMainScreenTextCell(customer.salesman, isWarning: inValidCustomer),
        buildMainScreenClickableCell(
          totalDebt,
          () => showCustomerMatchingReport(context, matchingList, customer.name),
          isWarning: inValidCustomer,
        ),
        buildMainScreenClickableCell(
          '$numOpenInvoices ($numDueInvoices)',
          () => showInvoicesReport(context, openInvoices, '${customer.name}  ( $numOpenInvoices )'),
          isWarning: inValidCustomer,
        ),
        buildMainScreenClickableCell(
          dueDebt,
          () => showInvoicesReport(context, dueInvoices, '${customer.name}  ( $numDueInvoices )'),
          isWarning: inValidCustomer,
        ),
        buildMainScreenClickableCell(
          invoiceAverageClosingDays,
          () => showInvoicesReport(
              context, closedInvoices, '${customer.name}  ( $invoiceAverageClosingDays )'),
          isWarning: inValidCustomer,
        ),
        if (!hideCustomerProfit)
          buildMainScreenClickableCell(
            profit,
            () => showProfitReport(context, invoiceWithProfit, customer.name),
            isWarning: inValidCustomer,
          ),
        buildMainScreenClickableCell(
          totalGiftsAmount,
          () => showGiftsReport(context, giftsAndDiscounts, customer.name),
          isWarning: inValidCustomer,
        ),
      ],
    ),
  );
}

Widget _buildHeaderTotalsRow(BuildContext context) {
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
      buildMainScreenPlaceholder(width: 20, isExpanded: false),
      buildMainScreenPlaceholder(),
      buildMainScreenPlaceholder(),
      buildMainScreenHeaderCell(totalDebtSum, isColumnTotal: true),
      buildMainScreenHeaderCell('$totalOpenInvoices ($totalDueInvoices)'),
      buildMainScreenHeaderCell(totalDueDebtSum, isColumnTotal: true),
      buildMainScreenHeaderCell('($averageClosingDays ${S.of(context).days} )'),
      if (!hideCustomerProfit) buildMainScreenHeaderCell(totalProfitSum, isColumnTotal: true),
      buildMainScreenHeaderCell(totalGifts, isColumnTotal: true),
    ],
  );
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
