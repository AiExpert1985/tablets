import 'package:flutter/material.dart';
import 'package:tablets/src/common/functions/utils.dart';
import 'package:tablets/src/common/values/constants.dart';
import 'package:tablets/src/features/customers/model/customer.dart';
import 'package:tablets/src/features/transactions/model/transaction.dart';

class ReceiptUsed {
  String type;
  String number;
  DateTime date;
  double amount;
  double amountUsed;

  ReceiptUsed(this.type, this.number, this.date, this.amount, this.amountUsed);
}

class InvoiceInfo {
  String type;
  String number;
  DateTime date;
  double totalAmount;
  double amountLeft;
  String status;
  List<ReceiptUsed> receiptsUsed;
  Duration durationToClose;

  InvoiceInfo(this.type, this.number, this.date, this.totalAmount, this.amountLeft, this.status,
      this.receiptsUsed, this.durationToClose);
}

List<InvoiceInfo> processTransactions(List<Map<String, dynamic>> transactions) {
  // Separate invoices and receipts
  List<Transaction> invoices = [];
  List<Transaction> receipts = [];

  for (var trans in transactions) {
    Transaction transaction = Transaction.fromMap(trans);
    if (transaction.transactionType == TransactionType.customerInvoice.name ||
        transaction.transactionType == TransactionType.initialCredit.name) {
      invoices.add(transaction);
    } else if (transaction.transactionType == TransactionType.customerReceipt.name ||
        transaction.transactionType == TransactionType.customerReturn.name) {
      receipts.add(transaction);
    }
  }

  // Sort invoices and receipts by date
  invoices.sort((a, b) => a.date.compareTo(b.date));
  receipts.sort((a, b) => a.date.compareTo(b.date));

  List<InvoiceInfo> result = [];
  double remainingAmount = 0;
  List<ReceiptUsed> usedReceipts = [];
  int receiptIndex = 0;

  for (var invoice in invoices) {
    remainingAmount = invoice.totalAmount;
    usedReceipts = [];
    DateTime lastReceiptDate = invoice.date; // Initialize to the invoice date

    while (remainingAmount > 0 && receiptIndex < receipts.length) {
      var receipt = receipts[receiptIndex];

      if (receipt.totalAmount > 0) {
        double amountToUse =
            (receipt.totalAmount >= remainingAmount) ? remainingAmount : receipt.totalAmount;

        // Create a ReceiptUsed instance for the amount being used
        usedReceipts.add(ReceiptUsed(receipt.transactionType, receipt.number.toString(),
            receipt.date, receipt.totalAmount, amountToUse));

        // Deduct the amount used from the receipt and the invoice
        remainingAmount -= amountToUse;
        receipt.totalAmount -= amountToUse;

        // Update the last receipt date
        lastReceiptDate = receipt.date;

        // If the receipt is fully used, move to the next receipt
        if (receipt.totalAmount <= 0) {
          receiptIndex++;
        }
      } else {
        // Move to the next receipt if the current one is fully used
        receiptIndex++;
      }
    }

    // Determine status and amount left
    String status = remainingAmount > 0 ? 'open' : 'closed';
    double amountLeft = remainingAmount > 0 ? remainingAmount : 0;

    // Calculate duration to close
    Duration durationToClose = status == 'closed'
        ? lastReceiptDate.difference(invoice.date)
        : DateTime.now().difference(invoice.date);

    result.add(InvoiceInfo(invoice.transactionType, invoice.number.toString(), invoice.date,
        invoice.totalAmount, amountLeft, status, usedReceipts, durationToClose));
  }

  return result;
}

List<List<dynamic>> getCustomerInvoicesStatus(
    BuildContext context, List<Map<String, dynamic>> transactions, Customer customer) {
  List<List<dynamic>> invoicesStatus = [];
  List<InvoiceInfo> processedInvoices = processTransactions(transactions);
  for (var invoice in processedInvoices) {
    double amountLeft = invoice.totalAmount;
    String receiptInfo = '';
    if (invoice.status == InvoiceStatus.open.name &&
        invoice.durationToClose > Duration(days: customer.paymentDurationLimit as int)) {
      invoice.status = InvoiceStatus.due.name;
    }
    String status = translateDbTextToScreenText(context, invoice.status);
    for (var i = 0; i < invoice.receiptsUsed.length; i++) {
      final receipt = invoice.receiptsUsed[i];
      final receiptType = translateDbTextToScreenText(context, receipt.type);
      final receiptDate = formatDate(receipt.date);
      amountLeft -= receipt.amountUsed;
      receiptInfo =
          '$receiptInfo $receiptType (${receipt.number}) $receiptDate (${receipt.amountUsed}) ';
      // add line only if there are more receipts to be added
      if (i + 1 < invoice.receiptsUsed.length) {
        receiptInfo = '$receiptInfo \n';
      }
    }
    invoicesStatus.add([
      invoice.type == TransactionType.initialCredit.name ? '' : invoice.number,
      invoice.date,
      invoice.totalAmount,
      receiptInfo,
      status,
      invoice.durationToClose.inDays,
      amountLeft
    ]);
  }
  return sortByDate(invoicesStatus, 1);
}
