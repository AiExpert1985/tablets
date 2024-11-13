import 'package:flutter/material.dart';
import 'package:tablets/generated/l10n.dart';
import 'package:tablets/src/common/functions/utils.dart';
import 'package:tablets/src/common/values/constants.dart';

List<String> getCustomerMatchingReportTitles(BuildContext context) {
  return [
    S.of(context).transaction_type,
    S.of(context).transaction_number,
    S.of(context).transaction_date,
    S.of(context).transaction_amount,
    S.of(context).previous_debt,
    S.of(context).later_debt,
  ];
}

List<String> getInvoiceReportTitles(BuildContext context) {
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

List<String> getTransactionTypeDropList(BuildContext context) {
  return [
    translateDbTextToScreenText(context, TransactionType.customerInvoice.name),
    translateDbTextToScreenText(context, TransactionType.customerReceipt.name),
    translateDbTextToScreenText(context, TransactionType.customerReturn.name),
    translateDbTextToScreenText(context, TransactionType.gifts.name),
  ];
}
