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

  void showTransactionReport(
    BuildContext context,
    List<List<dynamic>> transactionList,
    String salesmanName, {
    int? sumIndex,
    bool isProfit = false,
    bool isCount = false,
  }) {
    showReportDialog(
      context,
      _getTransactionsReportTitles(context, isProfit: isProfit),
      transactionList,
      dateIndex: 2,
      title: salesmanName,
      useOriginalTransaction: true,
      sumIndex: sumIndex,
      isCount: isCount,
    );
  }

  List<String> _getTransactionsReportTitles(BuildContext context, {bool isProfit = false}) {
    return [
      S.of(context).transaction_type,
      S.of(context).transaction_date,
      S.of(context).transaction_name,
      isProfit ? S.of(context).profits : S.of(context).transaction_amount,
    ];
  }
}
