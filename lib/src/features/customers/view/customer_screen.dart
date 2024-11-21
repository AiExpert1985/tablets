import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tablets/src/common/values/gaps.dart';
import 'package:tablets/src/common/widgets/home_screen.dart';
import 'package:tablets/src/common/widgets/main_frame.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:tablets/generated/l10n.dart';
import 'package:tablets/src/common/providers/image_picker_provider.dart';
import 'package:tablets/src/common/values/settings.dart';
import 'package:tablets/src/features/customers/controllers/customer_drawer_provider.dart';
import 'package:tablets/src/features/customers/controllers/customer_form_data_notifier.dart';
import 'package:tablets/src/features/customers/controllers/customer_screen_data_notifier.dart';
import 'package:tablets/src/features/customers/view/customer_form.dart';
import 'package:tablets/src/common/widgets/main_screen_list_cells.dart';
import 'package:tablets/src/features/customers/controllers/customer_report_controller.dart';
import 'package:tablets/src/features/customers/controllers/customer_screen_controller.dart';
import 'package:tablets/src/features/customers/repository/customer_db_cache_provider.dart';
import 'package:tablets/src/features/customers/model/customer.dart';
import 'package:tablets/src/common/values/constants.dart';

class CustomerScreen extends ConsumerWidget {
  const CustomerScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // I need to read and watch db for one reason, which is hiding floating buttons when
    // page is accessed by refresh and not throught the side bar
    final dbCache = ref.read(customerDbCacheProvider.notifier).data;
    ref.watch(customerDbCacheProvider);
    return AppScreenFrame(
      const CustomerList(),
      buttonsWidget: dbCache.isEmpty ? null : const CustomerFloatingButtons(),
    );
  }
}

class CustomerList extends ConsumerWidget {
  const CustomerList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(customerScreenDataNotifier);
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
    final screenDataNotifier = ref.read(customerScreenDataNotifier.notifier);
    final screenData = screenDataNotifier.data;
    ref.watch(customerScreenDataNotifier);
    return Expanded(
      child: ListView.builder(
        itemCount: screenData.length,
        itemBuilder: (ctx, index) {
          final customerScreenData = screenData[index];
          return Column(
            children: [
              DataRow(customerScreenData),
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

class HeaderTotalsRow extends ConsumerWidget {
  const HeaderTotalsRow({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final screenDataNotifier = ref.read(customerScreenDataNotifier.notifier);
    final summary = screenDataNotifier.summary;
    int openInvoices = summary[openInvoicesKey]['value'];
    int dueInvoices = summary[dueInvoicesKey]['value'];
    double totalDebt = summary[totalDebtKey]['value'];
    double dueDebt = summary[dueDebtKey]['value'];
    double profit = summary[invoicesProfitKey]['value'];
    double gifts = summary[giftsKey]['value'];
    double averageClosingDays = summary[avgClosingDaysKey]['value'].toInt();

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

class DataRow extends ConsumerWidget {
  const DataRow(this.customerScreenData, {super.key});
  final Map<String, dynamic> customerScreenData;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final reportController = ref.read(customerReportControllerProvider);
    final customerRef = customerScreenData[customerDbRefKey];
    final customerDbCache = ref.read(customerDbCacheProvider.notifier);
    final customerData = customerDbCache.getItemByDbRef(customerRef);
    final customer = Customer.fromMap(customerData);
    final invoiceAverageClosingDays = customerScreenData[avgClosingDaysKey] as int;
    final closedInvoices = customerScreenData[avgClosingDaysDetailsKey] as List<List<dynamic>>;
    final numOpenInvoices = customerScreenData[openInvoicesKey] as int;
    final openInvoices = customerScreenData[openInvoicesDetailsKey] as List<List<dynamic>>;
    final dueInvoices = customerScreenData[dueDebtDetailsKey] as List<List<dynamic>>;
    final numDueInvoices = customerScreenData[dueInvoicesKey] as int;
    final totalDebt = customerScreenData[totalDebtKey] as double;
    final matchingList = customerScreenData[totalDebtDetailsKey] as List<List<dynamic>>;
    final dueDebt = customerScreenData[dueDebtKey];
    final invoiceWithProfit = customerScreenData[invoicesProfitDetailsKey] as List<List<dynamic>>;
    final profit = customerScreenData[invoicesProfitKey] as double;
    final giftTransactions = customerScreenData[giftsDetailsKey] as List<List<dynamic>>;
    final totalGiftsAmount = customerScreenData[giftsKey] as double;
    final inValidCustomer = customerScreenData[inValidUserKey] as bool;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          MainScreenEditButton(
              defaultImageUrl, () => _showEditCustomerForm(context, ref, customer)),
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

  void _showEditCustomerForm(BuildContext context, WidgetRef ref, Customer customer) {
    final imagePickerNotifier = ref.read(imagePickerProvider.notifier);
    final formDataNotifier = ref.read(customerFormDataProvider.notifier);
    formDataNotifier.initialize(initialData: customer.toMap());
    imagePickerNotifier.initialize(urls: customer.imageUrls);
    showDialog(
      context: context,
      builder: (BuildContext ctx) => const CustomerForm(
        isEditMode: true,
      ),
    ).whenComplete(imagePickerNotifier.close);
  }
}

class CustomerFloatingButtons extends ConsumerWidget {
  const CustomerFloatingButtons({super.key});

  void showAddCustomerForm(BuildContext context, WidgetRef ref) {
    final formDataNotifier = ref.read(customerFormDataProvider.notifier);
    formDataNotifier.initialize();
    formDataNotifier.updateProperties({
      'initialDate': DateTime.now(),
      'initialCredit': 0,
      'sellingPriceType': S.of(context).selling_price_type_whole,
      'creditLimit': maxDebtAmount,
      'paymentDurationLimit': maxDebtDuration,
    });
    final imagePicker = ref.read(imagePickerProvider.notifier);
    imagePicker.initialize();
    showDialog(
      context: context,
      builder: (BuildContext ctx) => const CustomerForm(),
    ).whenComplete(imagePicker.close);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final drawerController = ref.watch(customerDrawerControllerProvider);
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
          onTap: () => drawerController.showReports(context),
        ),
        SpeedDialChild(
          child: const Icon(Icons.search, color: Colors.white),
          backgroundColor: iconsColor,
          onTap: () => drawerController.showSearchForm(context),
        ),
        SpeedDialChild(
          child: const Icon(Icons.add, color: Colors.white),
          backgroundColor: iconsColor,
          onTap: () => showAddCustomerForm(context, ref),
        ),
      ],
    );
  }
}
