import 'package:flutter/material.dart';
import 'package:tablets/generated/l10n.dart';
import 'package:tablets/src/common/functions/utils.dart';
import 'package:tablets/src/common/values/constants.dart';
import 'package:tablets/src/common/widgets/dialog_report.dart';

void showHistoryReport(
    BuildContext context, List<List<dynamic>> productTransactions, String title) {
  //last two indexes (profit & commission) are not needed in this report
  final trimmedList = productTransactions
      .map((innerList) => innerList.sublist(0, innerList.length - 2)) // Skip the last index
      .toList();
  final selectionList = _getTransactionTypeDropList(context);
  showReportDialog(context, _getHistoryTitles(context), trimmedList,
      dropdownIndex: 1,
      dropdownLabel: S.of(context).transaction_type,
      dropdownList: selectionList,
      dateIndex: 3,
      title: title,
      sumIndex: 4,
      useOriginalTransaction: true);
}

List<String> _getHistoryTitles(BuildContext context) {
  return [
    S.of(context).transaction_type,
    S.of(context).transaction_number,
    S.of(context).transaction_date,
    S.of(context).quantity,
  ];
}

List<String> _getTransactionTypeDropList(BuildContext context) {
  return [
    translateDbTextToScreenText(context, TransactionType.customerInvoice.name),
    translateDbTextToScreenText(context, TransactionType.vendorInvoice.name),
    translateDbTextToScreenText(context, TransactionType.customerReturn.name),
    translateDbTextToScreenText(context, TransactionType.vendorReturn.name),
    translateDbTextToScreenText(context, TransactionType.damagedItems.name),
    translateDbTextToScreenText(context, TransactionType.gifts.name),
    S.of(context).initialAmount
  ];
}
