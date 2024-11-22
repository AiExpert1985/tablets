import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tablets/generated/l10n.dart';
import 'package:tablets/src/common/providers/page_is_loading_notifier.dart';
import 'package:tablets/src/common/values/constants.dart';
import 'package:tablets/src/common/values/gaps.dart';
import 'package:tablets/src/common/values/settings.dart';
import 'package:tablets/src/common/widgets/home_screen.dart';
import 'package:tablets/src/common/widgets/main_frame.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:tablets/src/common/providers/image_picker_provider.dart';
import 'package:tablets/src/common/widgets/main_screen_list_cells.dart';
import 'package:tablets/src/features/salesmen/controllers/salesman_drawer_provider.dart';
import 'package:tablets/src/features/salesmen/controllers/salesman_form_controller.dart';
import 'package:tablets/src/features/salesmen/controllers/salesman_report_controller.dart';
import 'package:tablets/src/features/salesmen/controllers/salesman_screen_controller.dart';
import 'package:tablets/src/features/salesmen/controllers/salesman_screen_data_notifier.dart';
import 'package:tablets/src/features/salesmen/repository/salesman_db_cache_provider.dart';
import 'package:tablets/src/features/salesmen/view/salesman_form.dart';
import 'package:tablets/src/features/salesmen/model/salesman.dart';

class SalesmanScreen extends ConsumerWidget {
  const SalesmanScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // I need to read and watch db for one reason, which is hiding floating buttons when
    // page is accessed by refresh and not throught the side bar
    final dbCache = ref.read(salesmanDbCacheProvider.notifier).data;
    ref.watch(salesmanDbCacheProvider);
    return AppScreenFrame(
      const SalesmanList(),
      buttonsWidget: dbCache.isEmpty ? null : const SalesmanFloatingButtons(),
    );
  }
}

class SalesmanFloatingButtons extends ConsumerWidget {
  const SalesmanFloatingButtons({super.key});

  void showAddSalesmanForm(BuildContext context, WidgetRef ref) {
    ref.read(salesmanFormDataProvider.notifier).initialize();
    final imagePicker = ref.read(imagePickerProvider.notifier);
    imagePicker.initialize();
    showDialog(
      context: context,
      builder: (BuildContext ctx) => const SalesmanForm(),
    ).whenComplete(imagePicker.close);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final drawerController = ref.watch(salesmanDrawerControllerProvider);
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
          onTap: () => showAddSalesmanForm(context, ref),
        ),
      ],
    );
  }
}

class SalesmanList extends ConsumerWidget {
  const SalesmanList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dbCache = ref.read(salesmanDbCacheProvider.notifier);
    final dbData = dbCache.data;
    ref.watch(salesmanDbCacheProvider);
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
    final screenDataNotifier = ref.read(salesmanScreenDataNotifier.notifier);
    final screenData = screenDataNotifier.data;
    ref.watch(salesmanScreenDataNotifier);
    return Expanded(
      child: ListView.builder(
        itemCount: screenData.length,
        itemBuilder: (ctx, index) {
          final vendorData = screenData[index];
          return Column(
            children: [
              DataRow(vendorData),
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
            MainScreenHeaderCell(S.of(context).salesman_name),
            MainScreenHeaderCell(S.of(context).salary),
            MainScreenHeaderCell(S.of(context).customers),
            MainScreenHeaderCell(S.of(context).current_debt),
            MainScreenHeaderCell(S.of(context).due_debt_amount),
            MainScreenHeaderCell(S.of(context).num_open_invoice),
            MainScreenHeaderCell(S.of(context).num_due_invoices),
            MainScreenHeaderCell(S.of(context).profits),
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
    return const Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        MainScreenPlaceholder(width: 20, isExpanded: false),
        MainScreenPlaceholder(),
        MainScreenPlaceholder(),
        MainScreenPlaceholder(),
        MainScreenPlaceholder(),
        MainScreenPlaceholder(),
        MainScreenPlaceholder(),
        MainScreenPlaceholder(),
        MainScreenPlaceholder(),
      ],
    );
  }
}

class DataRow extends ConsumerWidget {
  const DataRow(this.salesmanScreenData, {super.key});
  final Map<String, dynamic> salesmanScreenData;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final reportController = ref.read(salesmanReportControllerProvider);
    final customerRef = salesmanScreenData[salesmanDbRefKey];
    final salesmanDbCache = ref.read(salesmanDbCacheProvider.notifier);
    final customerData = salesmanDbCache.getItemByDbRef(customerRef);
    final salesman = Salesman.fromMap(customerData);
    final name = salesmanScreenData[salesmanNameKey] as String;
    final salary = salesmanScreenData[salaryKey] as double;
    final salaryDetails = salesmanScreenData[salaryDetailsKey] as List<List<dynamic>>;
    final numCustomers = salesmanScreenData[customersKey] as double;
    final customersList = salesmanScreenData[customersDetailsKey] as List<List<dynamic>>;
    final totalDebt = salesmanScreenData[totalDebtKey] as double;
    final customersTotalDebts = salesmanScreenData[totalDebtDetailsKey] as List<List<dynamic>>;
    final dueDebt = salesmanScreenData[dueDebtKey] as double;
    final customersDueDebts = salesmanScreenData[dueDebtDetailsKey] as List<List<dynamic>>;
    final numOpenInvoices = salesmanScreenData[openInvoicesKey] as int;
    final openInvoices = salesmanScreenData[openInvoicesDetailsKey] as List<List<dynamic>>;
    final numDueInovies = salesmanScreenData[dueInvoicesKey] as int;
    final dueInvoices = salesmanScreenData[dueInvoicesDetailsKey] as List<List<dynamic>>;
    final profit = salesmanScreenData[profitKey] as double;
    final profitTransactions = salesmanScreenData[profitDetailsKey] as List<List<dynamic>>;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          MainScreenEditButton(
              defaultImageUrl, () => _showEditSalesmanForm(context, ref, salesman)),
          MainScreenTextCell(name),
          MainScreenClickableCell(
            salary,
            () => reportController.showSalaryDetails(context, salaryDetails, name),
          ),
          MainScreenClickableCell(
            numCustomers,
            () => reportController.showCustomers(context, customersList, name),
          ),
          MainScreenClickableCell(
            totalDebt,
            () => reportController.showTotalDebts(context, customersTotalDebts, name),
          ),
          MainScreenClickableCell(
            dueDebt,
            () => reportController.showDueDebts(context, customersDueDebts, name),
          ),
          MainScreenClickableCell(
            numOpenInvoices,
            () => reportController.showOpenInvoices(context, openInvoices, name),
          ),
          MainScreenClickableCell(
            numDueInovies,
            () => reportController.showDueInvoices(context, dueInvoices, name),
          ),
          MainScreenClickableCell(
            profit,
            () => reportController.showProfitTransactions(context, profitTransactions, name),
          ),
        ],
      ),
    );
  }

  void _showEditSalesmanForm(BuildContext context, WidgetRef ref, Salesman salesman) {
    ref.read(salesmanFormDataProvider.notifier).initialize(initialData: salesman.toMap());
    final imagePicker = ref.read(imagePickerProvider.notifier);
    imagePicker.initialize(urls: salesman.imageUrls);
    showDialog(
      context: context,
      builder: (BuildContext ctx) => const SalesmanForm(
        isEditMode: true,
      ),
    ).whenComplete(imagePicker.close);
  }
}
