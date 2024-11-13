import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tablets/src/common/classes/db_repository.dart';
import 'package:tablets/src/common/functions/utils.dart';
import 'package:tablets/src/common/providers/image_picker_provider.dart';
import 'package:tablets/src/common/values/gaps.dart';
import 'package:tablets/src/common/values/settings.dart';
import 'package:tablets/src/common/widgets/async_value_widget.dart';
import 'package:tablets/src/common/widgets/dialog_report.dart';
import 'package:tablets/src/features/customers/controllers/customer_filter_controller_.dart';
import 'package:tablets/src/features/customers/controllers/customer_filtered_list.dart';
import 'package:tablets/src/features/customers/controllers/customer_form_controller.dart';
import 'package:tablets/src/features/customers/model/customer.dart';
import 'package:tablets/src/features/customers/repository/customer_repository_provider.dart';
import 'package:tablets/src/common/functions/customer_utils.dart';
import 'package:tablets/src/features/customers/view/customer_form.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:tablets/generated/l10n.dart';
import 'package:tablets/src/common/classes/item_form_data.dart';
import 'package:tablets/src/common/values/constants.dart';
import 'package:tablets/src/features/transactions/repository/transaction_repository_provider.dart';

List<Map<String, dynamic>> _allTransactions = [];

Future<void> _fetchTransactions(DbRepository transactionProvider) async {
  _allTransactions = await transactionProvider.fetchItemListAsMaps();
}

Color getStatusColor(int numDueInvoice, double totalDebt, Customer customer) {
  if (totalDebt >= customer.creditLimit || numDueInvoice > 0) {
    return Colors.red;
  }
  if (totalDebt >= customer.creditLimit * debtAmountWarning) {
    return Colors.orange;
  }
  return Colors.black87;
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
      // Calculate totals for the columns
      double totalDebtSum = 0;
      int totalOpenInvoices = 0;
      int totalDueInvoices = 0;
      double totalDueDebtSum = 0;

      for (var customerData in customers) {
        final customer = Customer.fromMap(customerData);
        final customerTransactions = getCustomerTransactions(_allTransactions, customer.dbRef);
        final totalDebt = getTotalDebt(customerTransactions, customer);
        final openInvoices = getOpenInvoices(customerTransactions, totalDebt);
        final dueInvoices = getDueInvoices(openInvoices, customer.paymentDurationLimit);
        final dueDebt = getDueDebt(dueInvoices, 4);

        totalDebtSum += totalDebt;
        totalOpenInvoices += openInvoices.length;
        totalDueInvoices += dueInvoices.length;
        totalDueDebtSum += dueDebt;
      }

      return Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // const Divider(),
            // Pass totals to the header row
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: _buildHeaderRow(
                  context, totalDebtSum, totalOpenInvoices, totalDueInvoices, totalDueDebtSum),
            ),
            const Divider(),
            Expanded(
              child: ListView.builder(
                itemCount: customers.length,
                itemBuilder: (context, index) {
                  final customer = Customer.fromMap(customers[index]);
                  final customerTransactions =
                      getCustomerTransactions(_allTransactions, customer.dbRef);
                  final totalDebt = getTotalDebt(customerTransactions, customer);
                  final openInvoices = getOpenInvoices(customerTransactions, totalDebt);
                  final dueInvoices = getDueInvoices(openInvoices, customer.paymentDurationLimit);
                  final dueDebt = getDueDebt(dueInvoices, 4);
                  Color statusColor = getStatusColor(dueInvoices.length, totalDebt, customer);
                  final matchingList = customerMatching(customerTransactions, customer, context);
                  return Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 6.0),
                        child: _buildDataRow(
                            customer,
                            context,
                            imagePickerNotifier,
                            formDataNotifier,
                            totalDebt,
                            openInvoices,
                            dueInvoices,
                            dueDebt,
                            statusColor,
                            matchingList),
                      ),
                      const Divider(thickness: 0.2, color: Colors.grey)
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      );
    },
  );
}

Widget _buildHeaderRow(BuildContext context, double totalDebtSum, int totalOpenInvoices,
    int totalDueInvoices, double totalDueDebtSum) {
  return Column(
    children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(child: _buildHeader('')),
          Expanded(child: _buildHeader(S.of(context).customer)),
          Expanded(child: _buildHeader(S.of(context).salesman_selection)),
          Expanded(child: _buildHeader(S.of(context).current_debt)),
          Expanded(child: _buildHeader(S.of(context).num_open_invoice)),
          Expanded(child: _buildHeader(S.of(context).num_due_invoices)),
          Expanded(child: _buildHeader(S.of(context).due_debt_amount)),
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
            Expanded(child: _buildHeader('($totalOpenInvoices)')),
            Expanded(child: _buildHeader('($totalDueInvoices)')),
            Expanded(child: _buildHeader('(${numberToText(totalDueDebtSum)})')),
          ],
        ),
      ),
    ],
  );
}

Widget _buildDataRow(
  Customer customer,
  BuildContext context,
  ImageSliderNotifier imagePickerNotifier,
  ItemFormData formDataNotifier,
  double totalDebt,
  List<List<dynamic>> openInvoices,
  List<List<dynamic>> dueInvoices,
  double dueDebt,
  Color color,
  List<List<dynamic>> matchingList,
) {
  final invoiceColumnTitles = [
    S.of(context).transaction_number,
    S.of(context).transaction_date,
    S.of(context).transaction_amount,
    S.of(context).paid_amount,
    S.of(context).remaining_amount,
    S.of(context).receipt_date,
    S.of(context).receipt_number,
    S.of(context).receipt_amount,
  ];
  final matchingColumnTitles = [
    S.of(context).transaction_type,
    S.of(context).transaction_number,
    S.of(context).transaction_date,
    S.of(context).transaction_amount,
    S.of(context).previous_debt,
    S.of(context).later_debt,
  ];
  return Column(
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
              onTap: () {
                final title = customer.name;
                final selectionList = [
                  translateDbTextToScreenText(context, TransactionType.customerInvoice.name),
                  translateDbTextToScreenText(context, TransactionType.customerReceipt.name),
                  translateDbTextToScreenText(context, TransactionType.customerReturn.name),
                  translateDbTextToScreenText(context, TransactionType.gifts.name),
                ];
                showReportDialog(context, 700, 700, matchingColumnTitles, matchingList,
                    dateIndex: 2,
                    title: title,
                    sumIndex: 5,
                    dropdownIndex: 0,
                    dropdownList: selectionList,
                    dropdownLabel: S.of(context).transaction_type);
              },
            ),
          ),
          Expanded(
            child: InkWell(
              child: _buildDataCell(numberToText(openInvoices.length), color),
              onTap: () {
                final title = '${customer.name}  ( ${openInvoices.length} )';
                showReportDialog(context, 800, 400, invoiceColumnTitles, openInvoices,
                    title: title);
              },
            ),
          ),
          Expanded(
            child: InkWell(
              child: _buildDataCell(numberToText(dueInvoices.length), color),
              onTap: () {
                final title = '${customer.name}  ( ${dueInvoices.length} )';
                showReportDialog(context, 800, 400, invoiceColumnTitles, dueInvoices, title: title);
              },
            ),
          ),
          Expanded(child: _buildDataCell(numberToText(dueDebt), color)),
        ],
      ),
    ],
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
