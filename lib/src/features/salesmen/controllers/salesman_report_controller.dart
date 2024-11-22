import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tablets/generated/l10n.dart';
import 'package:tablets/src/common/widgets/dialog_report.dart';

final salesmanReportControllerProvider = Provider<SalesmanReportController>((ref) {
  return SalesmanReportController();
});

class SalesmanReportController {
  SalesmanReportController();

  void showSalaryDetails(
      BuildContext context, List<List<dynamic>> detailsList, String salesmanName) {}
  void showCustomers(BuildContext context, List<List<dynamic>> detailsList, String salesmanName) {
    showReportDialog(
      context,
      [S.of(context).customer, S.of(context).region_name],
      detailsList,
      title: salesmanName,
      width: 400,
    );
  }

  void showTotalDebts(BuildContext context, List<List<dynamic>> detailsList, String salesmanName) {}
  void showDueDebts(BuildContext context, List<List<dynamic>> detailsList, String salesmanName) {}
  void showOpenInvoices(
      BuildContext context, List<List<dynamic>> detailsList, String salesmanName) {}
  void showDueInvoices(
      BuildContext context, List<List<dynamic>> detailsList, String salesmanName) {}
  void showProfitTransactions(
      BuildContext context, List<List<dynamic>> detailsList, String salesmanName) {}
  void showTransactionCount(
      BuildContext context, List<List<dynamic>> transactionList, String salesmanName) {
    showReportDialog(
      context,
      _getTransactionsReportTitles(context),
      transactionList,
      dateIndex: 2,
      title: salesmanName,
      useOriginalTransaction: true,
      isCount: true,
    );
  }

  void showTransactionSum(
      BuildContext context, List<List<dynamic>> transactionList, String salesmanName) {
    showReportDialog(
      context,
      _getTransactionsReportTitles(context),
      transactionList,
      dateIndex: 2,
      title: salesmanName,
      useOriginalTransaction: true,
      sumIndex: 4,
    );
  }

  List<String> _getTransactionsReportTitles(BuildContext context) {
    return [
      S.of(context).transaction_type,
      S.of(context).transaction_date,
      S.of(context).transaction_name,
      S.of(context).transaction_amount,
    ];
  }
}
