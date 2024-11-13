// receive list of all transaction, it does filtering based on
import 'package:flutter/material.dart';
import 'package:tablets/generated/l10n.dart';
import 'package:tablets/src/common/functions/utils.dart';
import 'package:tablets/src/common/values/constants.dart';
import 'package:tablets/src/common/values/transactions_common_values.dart' as trans;
import 'package:tablets/src/features/customers/model/customer.dart';

import '../model/transaction.dart';

List<Map<String, dynamic>> getCustomerTransactions(
    List<Map<String, dynamic>> transactions, String dbRef) {
  // Filter transactions for the given database reference
  List<Map<String, dynamic>> customerTransactions =
      transactions.where((item) => item[trans.nameDbRefKey] == dbRef).toList();

  // Sort the transactions in descending order based on the transaction date
  return customerTransactions
    ..sort((a, b) {
      final dateA = a[trans.dateKey];
      final dateB = b[trans.dateKey];
      return dateB.compareTo(dateA);
    });
}

List<List<dynamic>> customerMatching(
    List<Map<String, dynamic>> customerTransactions, Customer customer, BuildContext context) {
  List<List<dynamic>> matchingTransactions = [];
  for (int i = customerTransactions.length - 1; i >= 0; i--) {
    final transaction = Transaction.fromMap(customerTransactions[i]);
    final transactionType = transaction.transactionType;
    if (transactionType == TransactionType.gifts.name) continue;
    double amountSign = (transactionType == TransactionType.customerReceipt.name ||
            transactionType == TransactionType.customerReturn.name)
        ? -1
        : 1;
    final transactionAmount = transaction.totalAmount * amountSign;
    matchingTransactions.add([
      translateDbTextToScreenText(context, transactionType),
      transaction.transactionType == TransactionType.initialCredit.name
          ? ''
          : transaction.number.toString(),
      transaction.date,
      transactionAmount,
    ]);
  }
  return matchingTransactions.reversed.toList();
}

List<List<dynamic>> getOpenInvoices(BuildContext context, List<List<dynamic>> invoices) {
  if (invoices.isEmpty) return [];
  String openStatus = S.of(context).invoice_status_open;
  String dueStatus = S.of(context).invoice_status_due;
  return invoices.where((item) => item[4] == openStatus || item[4] == dueStatus).toList();
}

List<List<dynamic>> getDueInvoices(BuildContext context, List<List<dynamic>> openInvoices) {
  if (openInvoices.isEmpty) return [];
  String dueStatus = S.of(context).invoice_status_due;
  return openInvoices.where((item) => item[4] == dueStatus).toList();
}

double getTotalDebt(List<List<dynamic>> openInvoices) {
  if (openInvoices.isEmpty) return 0;
  return openInvoices.map((item) => item[6] as double).reduce((a, b) => a + b);
}

double getDueDebt(List<List<dynamic>> dueInvoices) {
  if (dueInvoices.isEmpty) return 0;
  return dueInvoices.map((item) => item[6] as double).reduce((a, b) => a + b);
}
