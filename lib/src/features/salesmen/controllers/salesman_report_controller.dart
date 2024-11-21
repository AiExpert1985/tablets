import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final salesmanReportControllerProvider = Provider<SalesmanReportController>((ref) {
  return SalesmanReportController();
});

class SalesmanReportController {
  SalesmanReportController();

  void showSalaryDetails(
      BuildContext context, List<List<dynamic>> detailsList, String salesmanName) {}
  void showTotalDebts(BuildContext context, List<List<dynamic>> detailsList, String salesmanName) {}
  void showDueDebts(BuildContext context, List<List<dynamic>> detailsList, String salesmanName) {}
  void showOpenInvoices(
      BuildContext context, List<List<dynamic>> detailsList, String salesmanName) {}
  void showDueInvoices(
      BuildContext context, List<List<dynamic>> detailsList, String salesmanName) {}
  void showProfitTransactions(
      BuildContext context, List<List<dynamic>> detailsList, String salesmanName) {}
}
