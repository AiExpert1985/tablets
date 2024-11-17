import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tablets/src/common/functions/db_cache_inialization.dart';
import 'package:tablets/src/common/functions/debug_print.dart';
import 'package:tablets/src/common/providers/image_picker_provider.dart';
import 'package:tablets/src/common/providers/page_title_provider.dart';
import 'package:tablets/src/common/values/gaps.dart';
import 'package:tablets/src/common/values/settings.dart';
import 'package:tablets/src/common/widgets/main_screen_list_cells.dart';
import 'package:tablets/src/common/widgets/reload_page_button.dart';
import 'package:tablets/src/features/customers/controllers/customer_form_data_notifier.dart';
import 'package:tablets/src/features/customers/controllers/customer_screen_data_notifier.dart';
import 'package:tablets/src/features/customers/utils/customer_map_keys.dart';
import 'package:tablets/src/features/customers/utils/customer_report_utils.dart';
import 'package:tablets/src/features/customers/model/customer.dart';
import 'package:tablets/src/features/customers/view/customer_form.dart';
import 'package:tablets/generated/l10n.dart';
import 'package:tablets/src/common/classes/item_form_data.dart';
import 'package:tablets/src/common/values/constants.dart';

import 'package:tablets/src/routers/go_router_provider.dart';

class CustomerList extends ConsumerWidget {
  const CustomerList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final screenDataNotifier = ref.read(customerScreenDataProvider.notifier);
    final screenData = screenDataNotifier.data;
    ref.watch(customerScreenDataProvider);
    Widget screenWidget = screenData.isNotEmpty
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
        : const ReLoadCustomerScreenButton();
    return screenWidget;
  }
}

class ListData extends ConsumerWidget {
  const ListData({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final screenDataNotifier = ref.read(customerScreenDataProvider.notifier);
    final screenData = screenDataNotifier.data;
    return Expanded(
      child: ListView.builder(
        itemCount: screenData.length,
        itemBuilder: (ctx, index) {
          final customerData = screenData[index];
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
        if (!hideMainScreenColumnTotals) const HeaderTotalsRow()
      ],
    );
  }
}

class DataRow extends ConsumerWidget {
  const DataRow(this.rowData, {super.key});
  final Map<String, dynamic> rowData;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final imagePickerNotifier = ref.read(imagePickerProvider.notifier);
    final formDataNotifier = ref.read(customerFormDataProvider.notifier);
    final customer = rowData[customerKey]!['value'] as Customer;
    final invoiceAverageClosingDays = rowData[avgClosingDaysKey]!['value'] as int;
    final closedInvoices = rowData[avgClosingDaysKey]!['details'] as List<List<dynamic>>;
    final numOpenInvoices = rowData[openInvoicesKey]!['value'] as int;
    final openInvoices = rowData[openInvoicesKey]!['details'] as List<List<dynamic>>;
    final dueInvoices = rowData[avgClosingDaysKey]!['details'] as List<List<dynamic>>;
    final numDueInvoices = dueInvoices.length;
    final totalDebt = rowData[totalDebtKey]!['value'] as double;
    final matchingList = rowData[totalDebtKey]!['details'] as List<List<dynamic>>;
    final dueDebt = rowData[avgClosingDaysKey]!['value'];
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
    final screenDataNotifier = ref.read(customerScreenDataProvider.notifier);
    final summary = screenDataNotifier.summary;
    int openInvoices = summary[openInvoicesKey]['value'];
    int dueInvoices = summary[dueInvoicesKey]['value'];
    double totalDebt = summary[totalDebtKey]['value'];
    double dueDebt = summary[dueDebtKey]['value'];
    double profit = summary[invoicesProfitKey]['value'];
    double gifts = summary[giftsKey]['value'];
    double averageClosingDays = summary[avgClosingDaysKey]['value'];

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const MainScreenPlaceholder(width: 20, isExpanded: false),
        const MainScreenPlaceholder(),
        const MainScreenPlaceholder(),
        MainScreenHeaderCell(totalDebt, isColumnTotal: true),
        MainScreenHeaderCell('$openInvoices ($dueInvoices)'),
        MainScreenHeaderCell(dueDebt, isColumnTotal: true),
        MainScreenHeaderCell('($averageClosingDays ${S.of(context).days} )'),
        if (!hideCustomerProfit) MainScreenHeaderCell(profit, isColumnTotal: true),
        MainScreenHeaderCell(gifts, isColumnTotal: true),
      ],
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

/// perform same functionality as CustomersButton in the main drawer
class ReLoadCustomerScreenButton extends ConsumerWidget {
  const ReLoadCustomerScreenButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ReLoadScreenButton(
      () async {
        await initializeCustomerDbCache(context, ref);
        if (context.mounted) {
          // initialized related transactionDbCache
          await initializeTransactionDbCache(context, ref);
        }
        if (context.mounted) {
          await initializeScreenDataNotifier(context, ref);
        }
        // set page title in the main top bar
        final pageTitleNotifier = ref.read(pageTitleProvider.notifier);
        if (context.mounted) {
          pageTitleNotifier.state = S.of(context).customers;
        }
        if (context.mounted) {
          context.goNamed(AppRoute.customers.name);
        }
      },
    );
  }
}
