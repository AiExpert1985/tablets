import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tablets/src/common/classes/db_repository.dart';
import 'package:tablets/src/common/functions/utils.dart';
import 'package:tablets/src/common/providers/image_picker_provider.dart';
import 'package:tablets/src/common/values/gaps.dart';
import 'package:tablets/src/common/values/settings.dart';
import 'package:tablets/src/common/widgets/async_value_widget.dart';
import 'package:tablets/src/features/customers/controllers/customer_filter_controller_.dart';
import 'package:tablets/src/features/customers/controllers/customer_filtered_list.dart';
import 'package:tablets/src/features/customers/controllers/customer_form_controller.dart';
import 'package:tablets/src/features/customers/utils/customer_report_utils.dart';
import 'package:tablets/src/features/customers/utils/process_customer_invoices.dart';
import 'package:tablets/src/features/customers/model/customer.dart';
import 'package:tablets/src/features/customers/repository/customer_repository_provider.dart';
import 'package:tablets/src/features/customers/utils/customer_screen_utils.dart';
import 'package:tablets/src/features/customers/view/customer_form.dart';
import 'package:cached_network_image/cached_network_image.dart';
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
List<double> _averageInvoiceClosingDaysList = [];
List<List<List<dynamic>>> _invoicesWithProfitList = [];
List<double> _totalProfitList = [];

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
            _buildHeaderRow(context),
            const Divider(),
            _buildDataRows(context, customers, formDataNotifier, imagePickerNotifier)
          ],
        ),
      );
    },
  );
}

Widget _buildDataRows(BuildContext context, List<Map<String, dynamic>> customers,
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

Widget _buildHeaderRow(BuildContext context) {
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

  double averageClosingDays = _averageInvoiceClosingDaysList.isNotEmpty
      ? _averageInvoiceClosingDaysList.reduce((a, b) => a + b) /
          _averageInvoiceClosingDaysList.length
      : 0.0;

  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(child: _buildHeader('')),
            Expanded(child: _buildHeader(S.of(context).customer)),
            Expanded(child: _buildHeader(S.of(context).salesman_selection)),
            Expanded(child: _buildHeader(S.of(context).current_debt)),
            Expanded(child: _buildHeader(S.of(context).num_open_invoice)),
            Expanded(child: _buildHeader(S.of(context).due_debt_amount)),
            Expanded(child: _buildHeader(S.of(context).average_invoice_closing_duration)),
            Expanded(child: _buildHeader(S.of(context).customer_invoice_profit)),
          ],
        ),
        VerticalGap.m,
        Visibility(
          visible: showColumnTotals,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Expanded(child: SizedBox()), // Placeholder for the first column
              const Expanded(child: SizedBox()), // Placeholder for the second column
              const Expanded(child: SizedBox()), // Placeholder for the third column
              Expanded(child: _buildHeader('(${numberToText(totalDebtSum)})')),
              Expanded(child: _buildHeader('$totalOpenInvoices ($totalDueInvoices)')),
              Expanded(child: _buildHeader('(${numberToText(totalDueDebtSum)})')),
              Expanded(child: _buildHeader('(${numberToText(averageClosingDays)})')),
              Expanded(child: _buildHeader('(${numberToText(totalProfitSum)})')),
            ],
          ),
        ),
      ],
    ),
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
  final matchingList = customerMatching(customerTransactions, customer, context);
  bool isValidCustomer = _isValidCustomer(dueDebt, totalDebt, customer);
  Color color = isValidCustomer ? Colors.black87 : Colors.red;
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 6.0),
    child: Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: InkWell(
                child: const CircleAvatar(
                  radius: 15,
                  foregroundImage: CachedNetworkImageProvider(defaultImageUrl),
                ),
                onTap: () =>
                    _showEditCustomerForm(context, formDataNotifier, imagePickerNotifier, customer),
              ),
            ),
            Expanded(child: _buildDataCell(customer.name, color)),
            Expanded(child: _buildDataCell(customer.salesman, color)),
            Expanded(
              child: InkWell(
                child: _buildDataCell(numberToText(totalDebt), color),
                onTap: () => showCustomerMatchingReport(context, matchingList, customer.name),
              ),
            ),
            Expanded(
              child: InkWell(
                child: _buildDataCell('$numOpenInvoices ($numDueInvoices)', color),
                onTap: () => showInvoicesReport(
                    context, openInvoices, '${customer.name}  ( $numOpenInvoices )'),
              ),
            ),
            Expanded(
              child: InkWell(
                child: _buildDataCell(numberToText(dueDebt), color),
                onTap: () => showInvoicesReport(
                    context, dueInvoices, '${customer.name}  ( $numDueInvoices )'),
              ),
            ),
            Expanded(
              child: InkWell(
                child: _buildDataCell(numberToText(invoiceAverageClosingDays), color),
                onTap: () => showInvoicesReport(
                    context, closedInvoices, '${customer.name}  ( $invoiceAverageClosingDays )'),
              ),
            ),
            Expanded(
              child: InkWell(
                child: _buildDataCell(numberToText(profit), color),
                onTap: () => showProfitReport(context, invoiceWithProfit, customer.name),
              ),
            ),
          ],
        ),
      ],
    ),
  );
}

Widget _buildDataCell(String text, Color color) {
  return Text(
    text,
    textAlign: TextAlign.center,
    style: TextStyle(fontSize: 16, color: color),
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

Future<void> _fetchTransactions(DbRepository transactionProvider) async {
  _transactionsList = await transactionProvider.fetchItemListAsMaps();
}

// we stop transactions if customer either exceeded limit of debt, or has dueDebt
// which is transactions that are not closed within allowed time (for example 20 days)
bool _isValidCustomer(double dueDebt, double totalDebt, Customer customer) {
  return totalDebt < customer.creditLimit || dueDebt < 0;
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
  for (var customerData in customers) {
    final customer = Customer.fromMap(customerData);
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
  }
}
