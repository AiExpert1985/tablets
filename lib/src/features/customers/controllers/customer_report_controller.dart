import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tablets/generated/l10n.dart';
import 'package:tablets/src/common/functions/transaction_type_drowdop_list.dart';
import 'package:tablets/src/common/widgets/report_dialog.dart';
import 'package:tablets/src/features/customers/controllers/customer_screen_controller.dart';
import 'package:tablets/src/features/customers/controllers/customer_screen_data_notifier.dart';

final customerReportControllerProvider = Provider<CustomerReportController>((ref) {
  return CustomerReportController();
});

class CustomerReportController {
  CustomerReportController();

  void showCustomerMatchingReport(
      BuildContext context, List<List<dynamic>> transactionList, String title) {
    final selectionList = getTransactionTypeDropList(context);
    showReportDialog(context, _getCustomerMatchingReportTitles(context), transactionList,
        dateIndex: 3,
        title: title,
        dropdownIndex: 1,
        dropdownList: selectionList,
        dropdownLabel: S.of(context).transaction_type,
        sumIndex: 4,
        useOriginalTransaction: true);
  }

  void showGiftsReport(BuildContext context, List<List<dynamic>> giftsList, String title) {
    showReportDialog(
      context,
      _getGiftsReportTitles(context),
      giftsList,
      dateIndex: 3,
      title: title,
      sumIndex: 4,
      dropdownIndex: 2,
      dropdownList: [
        S.of(context).transaction_type_gifts,
        S.of(context).transaction_type_customer_invoice
      ],
      dropdownLabel: S.of(context).transaction_type,
      useOriginalTransaction: true,
    );
  }

  void showInvoicesReport(BuildContext context, List<List<dynamic>> invoices, String title) {
    final selectionList = _getInvoiceStatusDropList(context);
    showReportDialog(
      context,
      _getInvoiceReportTitles(context),
      invoices,
      title: title,
      sumIndex: 7,
      dateIndex: 2,
      dropdownIndex: 5,
      dropdownList: selectionList,
      dropdownLabel: S.of(context).invoice_status,
      useOriginalTransaction: true,
    );
  }

  void showDueInvoicesReport(BuildContext context, List<List<dynamic>> invoices, String title) {
    showReportDialog(
      context,
      _getInvoiceReportTitles(context),
      invoices,
      title: title,
      sumIndex: 8,
      useOriginalTransaction: true,
    );
  }

  void showProfitReport(BuildContext context, List<List<dynamic>> invoices, String title) {
    showReportDialog(
      context,
      _getProfitReportTitles(context),
      invoices,
      title: title,
      sumIndex: 5,
      useOriginalTransaction: true,
      dateIndex: 2,
    );
  }

  List<String> _getCustomerMatchingReportTitles(BuildContext context) {
    return [
      S.of(context).transaction_type,
      S.of(context).transaction_number,
      S.of(context).transaction_date,
      S.of(context).transaction_amount,
      S.of(context).balance,
    ];
  }

  List<String> _getInvoiceReportTitles(BuildContext context) {
    return [
      S.of(context).transaction_number,
      S.of(context).transaction_date,
      S.of(context).transaction_amount,
      S.of(context).payment,
      S.of(context).invoice_status,
      S.of(context).invoice_close_duration,
      S.of(context).remaining_amount,
    ];
  }

  List<String> _getProfitReportTitles(BuildContext context) {
    return [
      S.of(context).transaction_number,
      S.of(context).transaction_date,
      S.of(context).transaction_amount,
      S.of(context).invoice_status,
      S.of(context).invoice_profit,
    ];
  }

  List<String> _getGiftsReportTitles(BuildContext context) {
    return [
      S.of(context).transaction_number,
      S.of(context).transaction_type,
      S.of(context).transaction_date,
      S.of(context).customer_gifts_and_discounts,
    ];
  }

  List<String> _getInvoiceStatusDropList(BuildContext context) {
    return [
      S.of(context).invoice_status_closed,
      S.of(context).invoice_status_open,
      S.of(context).invoice_status_due,
    ];
  }

  List<String> _getAllCustomersColumnTitles(BuildContext context) {
    return [
      S.of(context).customers,
      S.of(context).salesmen,
      S.of(context).regions,
      S.of(context).due_debt_amount,
      S.of(context).total_debt,
    ];
  }

  void showAllCustomersDebt(BuildContext context, WidgetRef ref) {
    final screenDataController = ref.read(customerScreenControllerProvider);
    screenDataController.setFeatureScreenData(context);
    final screenDataNotifier = ref.read(customerScreenDataNotifier.notifier);
    final screenData = screenDataNotifier.data;
    List<List<dynamic>> debtList = [];
    // below Lists will be used to generate set (unique values) to be used to filter report
    List<String> namesList = [];
    List<String> salesmenList = [];
    List<String> regionsList = [];
    for (var customerScreenData in screenData) {
      final name = customerScreenData[customerNameKey] as String;
      final salesman = customerScreenData[customerSalesmanKey] as String;
      final region = (customerScreenData[customerRegionKey] ?? '');
      final totalDebt = customerScreenData[totalDebtKey] as double;
      final dueDebt = customerScreenData[dueDebtKey] as double;
      // only show customers with debt > 0
      if (totalDebt > 0) {
        debtList.add([name, salesman, region, dueDebt, totalDebt]);
        namesList.add(name);
        salesmenList.add(salesman);
        regionsList.add(region);
      }
    }
    final salesmenDropdownList = salesmenList.toSet().toList();
    final customersDropdownList = namesList.toSet().toList();
    final regionsDropdownList = regionsList.toSet().toList();

    showReportDialog(
      context,
      _getAllCustomersColumnTitles(context),
      debtList,
      title: S.of(context).salesmen_debt_report,
      sumIndex: 4,
      dropdownLabel: S.of(context).customers,
      dropdownIndex: 0,
      dropdownList: customersDropdownList,
      dropdown2Label: S.of(context).salesmen,
      dropdown2Index: 1,
      dropdown2List: salesmenDropdownList,
      dropdown3Label: S.of(context).regions,
      dropdown3Index: 2,
      dropdown3List: regionsDropdownList,
    );
  }
}
