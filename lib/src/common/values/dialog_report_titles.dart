import 'package:flutter/material.dart';
import 'package:tablets/generated/l10n.dart';
import 'package:tablets/src/common/functions/utils.dart';
import 'package:tablets/src/common/values/constants.dart';

List<String> getTransactionIncomeReportTitles(BuildContext context) {
  return [
    S.of(context).transaction_type,
    S.of(context).transaction_date,
    S.of(context).transaction_number,
    S.of(context).transaction_name,
    S.of(context).transaction_amount,
    S.of(context).transaction_salesman
  ];
}

List<String> getTransactionTypeDropList(BuildContext context) {
  return [
    translateDbTextToScreenText(context, TransactionType.customerInvoice.name),
    translateDbTextToScreenText(context, TransactionType.customerReceipt.name),
    translateDbTextToScreenText(context, TransactionType.customerReturn.name),
    translateDbTextToScreenText(context, TransactionType.vendorInvoice.name),
    translateDbTextToScreenText(context, TransactionType.vendorReceipt.name),
    translateDbTextToScreenText(context, TransactionType.vendorReturn.name),
    translateDbTextToScreenText(context, TransactionType.gifts.name),
    translateDbTextToScreenText(context, TransactionType.expenditures.name),
  ];
}
