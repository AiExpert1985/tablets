import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tablets/src/common/classes/db_repository.dart';
import 'package:tablets/src/common/functions/utils.dart';
import 'package:tablets/src/common/providers/image_picker_provider.dart';
import 'package:tablets/src/common/values/gaps.dart';
import 'package:tablets/src/common/values/settings.dart';
import 'package:tablets/src/common/widgets/async_value_widget.dart';
import 'package:tablets/src/common/widgets/show_dialog_list.dart';
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
    return const Color.fromARGB(255, 153, 141, 28);
  }
  return Colors.green;
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

@override
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
      return Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildHeaderRow(context),
            VerticalGap.l,
            _buildHorizontalLine(), // Add some space between header and data
            Expanded(
              child: ListView.builder(
                itemCount: customers.length,
                itemBuilder: (context, index) {
                  final customer = Customer.fromMap(customers[index]);
                  final customerTransactions =
                      getCustomerTransactions(_allTransactions, customer.dbRef);
                  final totalDebt = getTotalDebt(customerTransactions);
                  final openInvoices = getOpenInvoices(customerTransactions, totalDebt);
                  final dueInvoices = getDueInvoices(openInvoices, customer.paymentDurationLimit);
                  final dueDebt = getDueDebt(dueInvoices, 4);
                  Color statusColor = getStatusColor(dueInvoices.length, totalDebt, customer);
                  return _buildDataRow(customer, context, imagePickerNotifier, formDataNotifier,
                      totalDebt, openInvoices, dueInvoices, dueDebt, statusColor);
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
      Expanded(child: _buildHeader('')),
      Expanded(child: _buildHeader(S.of(context).customer)),
      Expanded(child: _buildHeader(S.of(context).salesman_selection)),
      Expanded(child: _buildHeader(S.of(context).current_debt)),
      Expanded(child: _buildHeader(S.of(context).num_open_invoice)),
      Expanded(child: _buildHeader(S.of(context).num_due_invoices)),
      Expanded(child: _buildHeader(S.of(context).due_debt_amount)),
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
    Color color) {
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
          Expanded(child: _buildDataCell(numberToText(totalDebt), color)),
          Expanded(
            child: InkWell(
              child: _buildDataCell(numberToText(openInvoices.length), color),
              onTap: () {
                final title = '${customer.name} (${openInvoices.length})';
                showDialogList(context, title, 800, 400, invoiceColumnTitles, openInvoices);
              },
            ),
          ),
          Expanded(
            child: InkWell(
              child: _buildDataCell(numberToText(dueInvoices.length), color),
              onTap: () {
                final title = '${customer.name} (${dueInvoices.length})';
                showDialogList(context, title, 800, 400, invoiceColumnTitles, dueInvoices);
              },
            ),
          ),
          Expanded(child: _buildDataCell(numberToText(dueDebt), color)),
        ],
      ),

      const SizedBox(height: 4), // Space between row and divider
      _buildHorizontalLine()
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

Widget _buildHorizontalLine() {
  return Container(
    margin: const EdgeInsets.symmetric(vertical: 10),
    height: 1, // Height of the divider
    color: Colors.grey[300], // Light gray color
  );
}
