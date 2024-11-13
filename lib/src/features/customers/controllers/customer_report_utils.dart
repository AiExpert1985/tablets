import 'package:flutter/material.dart';
import 'package:tablets/generated/l10n.dart';
import 'package:tablets/src/common/functions/utils.dart';
import 'package:tablets/src/common/values/constants.dart';
import 'package:tablets/src/common/widgets/dialog_report.dart';

void showCustomerMatchingReport(
    BuildContext context, List<List<dynamic>> transactionList, String title) {
  final selectionList = _getTransactionTypeDropList(context);
  showReportDialog(
    context,
    _getCustomerMatchingReportTitles(context),
    transactionList,
    dateIndex: 2,
    title: title,
    dropdownIndex: 0,
    dropdownList: selectionList,
    dropdownLabel: S.of(context).transaction_type,
    sumIndex: 3,
  );
}

void showOpenInvoicesReport(
    BuildContext context, List<List<dynamic>> transactionList, String title) {
  showReportDialog(
    context,
    _getInvoiceReportTitles(context),
    transactionList,
    title: title,
    sumIndex: 4,
  );
}

void showDueInvoicesReport(
    BuildContext context, List<List<dynamic>> transactionList, String title) {
  showReportDialog(
    context,
    _getInvoiceReportTitles(context),
    transactionList,
    title: title,
    sumIndex: 4,
  );
}

List<String> _getCustomerMatchingReportTitles(BuildContext context) {
  return [
    S.of(context).transaction_type,
    S.of(context).transaction_number,
    S.of(context).transaction_date,
    S.of(context).transaction_amount,
  ];
}

List<String> _getInvoiceReportTitles(BuildContext context) {
  return [
    S.of(context).transaction_number,
    S.of(context).transaction_date,
    S.of(context).transaction_amount,
    S.of(context).paid_amount,
    S.of(context).remaining_amount,
    S.of(context).receipt_date,
    S.of(context).receipt_number,
    S.of(context).receipt_amount,
  ];
}

List<String> _getTransactionTypeDropList(BuildContext context) {
  return [
    translateDbTextToScreenText(context, TransactionType.customerInvoice.name),
    translateDbTextToScreenText(context, TransactionType.customerReceipt.name),
    translateDbTextToScreenText(context, TransactionType.customerReturn.name),
    translateDbTextToScreenText(context, TransactionType.gifts.name),
    S.of(context).initialAmount
  ];
}
