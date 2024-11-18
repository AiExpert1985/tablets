import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tablets/src/common/providers/image_picker_provider.dart';
import 'package:tablets/src/common/values/gaps.dart';
import 'package:tablets/src/common/values/settings.dart';
import 'package:tablets/src/common/widgets/main_screen_list_cells.dart';
import 'package:tablets/src/common/widgets/home_screen.dart';
import 'package:tablets/src/features/customers/controllers/customer_form_data_notifier.dart';
import 'package:tablets/src/features/customers/controllers/customer_report_controller.dart';
import 'package:tablets/src/features/customers/controllers/customer_screen_controller.dart';
import 'package:tablets/src/features/customers/repository/customer_db_cache_provider.dart';
import 'package:tablets/src/features/customers/model/customer.dart';
import 'package:tablets/src/features/customers/view/customer_form.dart';
import 'package:tablets/generated/l10n.dart';
import 'package:tablets/src/common/classes/item_form_data.dart';
import 'package:tablets/src/common/values/constants.dart';

class CustomerList extends ConsumerWidget {
  const CustomerList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dbCache = ref.read(customerDbCacheProvider.notifier);
    final dbData = dbCache.data;
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
    final dbCache = ref.read(customerDbCacheProvider.notifier);
    final dbData = dbCache.data;
    return Expanded(
      child: ListView.builder(
        itemCount: dbData.length,
        itemBuilder: (ctx, index) {
          final customerData = dbData[index];
          return Column(
            children: [
              DataRow(customerData),
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
        // if (!hideMainScreenColumnTotals) const HeaderTotalsRow()
      ],
    );
  }
}

class DataRow extends ConsumerWidget {
  const DataRow(this.customerData, {super.key});
  final Map<String, dynamic> customerData;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final reportController = ref.read(customerReportControllerProvider);
    final screenController = ref.read(customerScreenControllerProvider);
    final imagePickerNotifier = ref.read(imagePickerProvider.notifier);
    final formDataNotifier = ref.read(customerFormDataProvider.notifier);
    final rowData = screenController.createCustomerScreenData(context, customerData);
    final customer = rowData[customerKey]!['value'] as Customer;
    final invoiceAverageClosingDays = rowData[avgClosingDaysKey]!['value'] as int;
    final closedInvoices = rowData[avgClosingDaysKey]!['details'] as List<List<dynamic>>;
    final numOpenInvoices = rowData[openInvoicesKey]!['value'] as int;
    final openInvoices = rowData[openInvoicesKey]!['details'] as List<List<dynamic>>;
    final dueInvoices = rowData[dueDebtKey]!['details'] as List<List<dynamic>>;
    final numDueInvoices = dueInvoices.length;
    final totalDebt = rowData[totalDebtKey]!['value'] as double;
    final matchingList = rowData[totalDebtKey]!['details'] as List<List<dynamic>>;
    final dueDebt = rowData[dueDebtKey]!['value'];
    final invoiceWithProfit = rowData[invoicesProfitKey]!['details'] as List<List<dynamic>>;
    final profit = rowData[invoicesProfitKey]!['value'] as double;
    final giftTransactions = rowData[giftsKey]!['details'] as List<List<dynamic>>;
    final totalGiftsAmount = rowData[giftsKey]!['value'] as double;
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
            () => reportController.showCustomerMatchingReport(context, matchingList, customer.name),
            isWarning: inValidCustomer,
          ),
          MainScreenClickableCell(
            '$numOpenInvoices ($numDueInvoices)',
            () => reportController.showInvoicesReport(
                context, openInvoices, '${customer.name}  ( $numOpenInvoices )'),
            isWarning: inValidCustomer,
          ),
          MainScreenClickableCell(
            dueDebt,
            () => reportController.showInvoicesReport(
                context, dueInvoices, '${customer.name}  ( $numDueInvoices )'),
            isWarning: inValidCustomer,
          ),
          MainScreenClickableCell(
            invoiceAverageClosingDays,
            () => reportController.showInvoicesReport(
                context, closedInvoices, '${customer.name}  ( $invoiceAverageClosingDays )'),
            isWarning: inValidCustomer,
          ),
          if (!hideCustomerProfit)
            MainScreenClickableCell(
              profit,
              () => reportController.showProfitReport(context, invoiceWithProfit, customer.name),
              isWarning: inValidCustomer,
            ),
          MainScreenClickableCell(
            totalGiftsAmount,
            () => reportController.showGiftsReport(context, giftTransactions, customer.name),
            isWarning: inValidCustomer,
          ),
        ],
      ),
    );
  }
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
