// receive list of all transaction, it does filtering based on
import 'package:flutter/material.dart';
import 'package:tablets/generated/l10n.dart';
import 'package:tablets/src/common/functions/utils.dart';
import 'package:tablets/src/common/values/constants.dart';
import 'package:tablets/src/common/values/transactions_common_values.dart' as trans;
import 'package:tablets/src/features/customers/model/customer.dart';

import '../../transactions/model/transaction.dart';

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

List<List<dynamic>> getOpenInvoices(
    BuildContext context, List<List<dynamic>> processedInvoices, int statusIndex) {
  if (processedInvoices.isEmpty) return [];
  String openStatus = S.of(context).invoice_status_open;
  String dueStatus = S.of(context).invoice_status_due;
  final openInvoices = processedInvoices
      .where((item) => item[statusIndex] == openStatus || item[statusIndex] == dueStatus)
      .toList();
  // skip last index, which stores the profit of the invoice
  final openInvoicesWithoutProfit = openInvoices
      .map((innerList) => innerList.sublist(0, innerList.length - 1)) // Skip the last index
      .toList();
  return openInvoicesWithoutProfit;
}

List<List<dynamic>> getDueInvoices(
    BuildContext context, List<List<dynamic>> openInvoicesWithoutProfit, int statusIndex) {
  if (openInvoicesWithoutProfit.isEmpty) return [];
  String dueStatus = S.of(context).invoice_status_due;
  return openInvoicesWithoutProfit.where((item) => item[statusIndex] == dueStatus).toList();
}

List<List<dynamic>> getClosedInvoices(
    BuildContext context, List<List<dynamic>> processedInvoices, int statusIndex) {
  if (processedInvoices.isEmpty) return [];
  String closedStatus = S.of(context).invoice_status_closed;
  final closedInvoices =
      processedInvoices.where((item) => item[statusIndex] == closedStatus).toList();
  // skip last index, which stores the profit of the invoice
  final closedInvoicesWithoutProfit = closedInvoices
      .map((innerList) => innerList.sublist(0, innerList.length - 1)) // Skip the last index
      .toList();
  return closedInvoicesWithoutProfit;
}

double getTotalDebt(List<List<dynamic>> openInvoices, int amountIndex) {
  if (openInvoices.isEmpty) return 0;
  return openInvoices.map((item) => item[amountIndex] as double).reduce((a, b) => a + b);
}

double getDueDebt(List<List<dynamic>> dueInvoices, int amountIndex) {
  if (dueInvoices.isEmpty) return 0;
  return dueInvoices.map((item) => item[amountIndex] as double).reduce((a, b) => a + b);
}

List<List<dynamic>> getInvoicesWithProfit(List<List<dynamic>> processedInvoices) {
  List<int> skippedIndexes = [4, 6, 7];
  List<List<dynamic>> invoicesWithProfit = [];
  for (var invoice in processedInvoices) {
    List<dynamic> filteredInnerList = [];
    for (int i = 0; i < invoice.length; i++) {
      if (!skippedIndexes.contains(i)) {
        filteredInnerList.add(invoice[i]);
      }
    }
    invoicesWithProfit.add(filteredInnerList);
  }
  return invoicesWithProfit;
}

double getTotalProfit(List<List<dynamic>> invoicesWithProfit, int profitIndex) {
  if (invoicesWithProfit.isEmpty) return 0;
  return invoicesWithProfit.map((item) => item[profitIndex] as double).reduce((a, b) => a + b);
}

double calculateAverageClosingDays(List<List<dynamic>> processedInvoices, int daysIndex) {
  List<double> values = processedInvoices
      .where((innerList) => innerList.length > daysIndex && innerList[daysIndex] is num)
      .map((innerList) => innerList[daysIndex] as double)
      .toList();
  double average = values.isNotEmpty
      ? values.reduce((a, b) => a + b) / values.length
      : 0.0; // Avoid division by zero
  return average;
}
