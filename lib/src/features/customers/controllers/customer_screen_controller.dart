import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tablets/generated/l10n.dart';
import 'package:tablets/src/common/functions/debug_print.dart';
import 'package:tablets/src/common/functions/utils.dart';
import 'package:tablets/src/common/values/constants.dart';
import 'package:tablets/src/features/customers/controllers/customer_screen_data_notifier.dart';
import 'package:tablets/src/features/customers/utils/customer_map_keys.dart';
import 'package:tablets/src/features/transactions/controllers/transaction_db_cache_provider.dart';
import 'package:tablets/src/features/transactions/model/transaction.dart';
import 'package:tablets/src/features/customers/model/customer.dart';

final customerScreenControllerProvider = Provider<CustomerScreenController>((ref) {
  final screenDataNotifier = ref.read(customerScreenDataProvider.notifier);
  final transactionDataNotifier = ref.read(transactionDbCacheProvider.notifier);
  final transactionData = transactionDataNotifier.data;
  return CustomerScreenController(screenDataNotifier, transactionData);
});

class CustomerScreenController {
  CustomerScreenController(
    this._screenDataNotifier,
    this._allTransactions,
  );
  final ScreenDataNotifier _screenDataNotifier;
  final List<Map<String, dynamic>> _allTransactions;

  /// go through the customer transactions, and create screen data (data will be displayed in
  /// customer screen) and load the created data (dataRows and columnSummary) to
  /// customerScreenDataNotifier which will be accessed by screen widget
  void processCustomerTransactions(BuildContext context, List<Map<String, dynamic>> customers) {
    List<Map<String, dynamic>> dataRows = [];
    for (var customerData in customers) {
      final customer = Customer.fromMap(customerData);
      Map<String, dynamic> newDataRow = {};
      newDataRow[customerKey] = {'value': customer};
      newDataRow[nameKey] = {'value': customer.name};
      newDataRow[salesmanKey] = {'value': customer.salesman};
      final customerTransactions = getCustomerTransactions(_allTransactions, customer.dbRef);
      // if customer has initial credit, it should be added to the tansactions, so, we add
      // it here and give it transaction type 'initialCredit'
      if (customer.initialCredit > 0) {
        customerTransactions.add(Transaction(
          dbRef: 'na',
          name: customer.name,
          imageUrls: ['na'],
          number: 1000001,
          date: customer.initialDate,
          currency: 'na',
          transactionType: TransactionType.initialCredit.name,
          totalAmount: customer.initialCredit,
        ).toMap());
      }
      final processedInvoices =
          getCustomerProcessedInvoices(context, customerTransactions, customer);
      final openInvoices = getOpenInvoices(context, processedInvoices, 5);
      newDataRow[openInvoicesKey] = {'value': openInvoices.length, 'details': openInvoices};
      final matchingList = customerMatching(customerTransactions, customer, context);
      final totalDebt = getTotalDebt(matchingList, 4);
      newDataRow[totalDebtKey] = {'value': totalDebt, 'details': matchingList};
      final invoicesWithProfit = getInvoicesWithProfit(processedInvoices);
      final totalProfit = getTotalProfit(invoicesWithProfit, 5);
      newDataRow[invoicesProfitKey] = {'value': totalProfit, 'details': invoicesWithProfit};
      final closedInvoices = getClosedInvoices(context, processedInvoices, 5);
      final averageClosingDays = calculateAverageClosingDays(closedInvoices, 6);
      newDataRow[avgClosingDaysKey] = {'value': averageClosingDays, 'details': closedInvoices};
      final dueInvoices = getDueInvoices(context, openInvoices, 5);
      final dueDebt = getDueDebt(dueInvoices, 7);
      newDataRow[dueDebtKey] = {'value': dueDebt, 'details': dueInvoices};
      final giftTransactions = getGiftsAndDiscounts(context, customerTransactions);
      final totalGiftsAmount = getTotalGiftsAndDiscounts(giftTransactions, 4);
      newDataRow[giftsKey] = {'value': totalGiftsAmount, 'details': giftTransactions};
      dataRows.add(newDataRow);
    }
    _screenDataNotifier.setRowData(dataRows);
  }

  /// takes dataRows and returns a map of summaries for desired properties
  /// sumProperties are properties that will store sum
  /// avgProperties are properties that avgProperties are properties that will store average
  Map<String, dynamic> sumProperties(
      List<Map<String, dynamic>> list, List<String> sumProperties, List<String> avgProperties) {
    Map<String, dynamic> result = {};
    for (var property in sumProperties) {
      result[property] = 0;
      for (var item in list) {
        if (item.containsKey(property) && item[property] is num) {
          result[property] += item[property];
        }
      }
    }
    return result;
  }

  List<Map<String, dynamic>> getCustomerTransactions(
      List<Map<String, dynamic>> transactions, String dbRef) {
    // Filter transactions for the given database reference
    List<Map<String, dynamic>> customerTransactions =
        transactions.where((item) => item['nameDbRef'] == dbRef).toList();

    // Sort the transactions in descending order based on the transaction date
    return customerTransactions
      ..sort((a, b) {
        final dateA = a['date'];
        final dateB = b['date'];
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
        transaction,
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

  double getTotalDebt(List<List<dynamic>> matchingList, int amountIndex) {
    if (matchingList.isEmpty) return 0;
    return matchingList.map((item) => item[amountIndex] as double).reduce((a, b) => a + b);
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

  int calculateAverageClosingDays(List<List<dynamic>> processedInvoices, int daysIndex) {
    List<double> values = processedInvoices
        .where((innerList) => innerList.length > daysIndex && innerList[daysIndex] is num)
        .map((innerList) => innerList[daysIndex] as double)
        .toList();
    double average = values.isNotEmpty
        ? values.reduce((a, b) => a + b) / values.length
        : 0.0; // Avoid division by zero
    // by rounding to int, I sacrifice some accuracy for earsier understanding
    // I think for user it is more understandable to see 15 days to close a transaction, than 15.73
    // .73 doesn't make any effect on the result the user needs from this info
    // since he just needs to know whether client is fast to payback or not
    return average.round();
  }

// filter transactions and keep only gifts and customerInvoices that contains a discount
// or gift items and return it in a list of lists, where each list contains
// [Transaction, num, type, date, amount]
  List<List<dynamic>> getGiftsAndDiscounts(
      BuildContext context, List<Map<String, dynamic>> customerTransactions) {
    List<List<dynamic>> giftsAndDiscounts = [];
    for (var transactionMap in customerTransactions) {
      if (transactionMap['transactionType'] == TransactionType.gifts.name) {
        final transaction = Transaction.fromMap(transactionMap);
        giftsAndDiscounts.add([
          transaction,
          transaction.number,
          translateDbTextToScreenText(context, transaction.transactionType),
          transaction.date,
          -(transaction.transactionTotalProfit ?? 0),
        ]);
      } else if (transactionMap['transactionType'] == TransactionType.customerInvoice.name) {
        final transaction = Transaction.fromMap(transactionMap);
        final items = transaction.items;
        final discount = transaction.discount ?? 0;
        double giftItemsAmount = 0;
        for (var item in items ?? []) {
          giftItemsAmount += item['giftQuantity'] * item['buyingPrice'];
        }
        if (giftItemsAmount > 0 || discount > 0) {
          giftsAndDiscounts.add([
            transaction,
            transaction.number,
            translateDbTextToScreenText(context, transaction.transactionType),
            transaction.date,
            giftItemsAmount + discount,
          ]);
        }
      }
    }

    return sortByDate(giftsAndDiscounts, 3);
  }

  double getTotalGiftsAndDiscounts(List<List<dynamic>> giftsList, int amountIndex) {
    if (giftsList.isEmpty) return 0;
    return giftsList.map((item) => item[amountIndex] as double).reduce((a, b) => a + b);
  }
}

// ----------------------------------------------------------------------
// below is a full code that process invoices & compares them to receipts
// it was generated by AI, I need to check it later
// ---------------------------------------------------------------------

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
  double profit;
  // store a copy of orignal tranasction to be used later to display a read only version of
  // the transaction
  Transaction originalTransaction;

  InvoiceInfo(this.type, this.number, this.date, this.totalAmount, this.amountLeft, this.status,
      this.receiptsUsed, this.durationToClose, this.profit, this.originalTransaction);
}

List<InvoiceInfo> processTransactions(List<Map<String, dynamic>> transactions) {
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
    final profit = invoice.transactionTotalProfit ?? 0;
    while (remainingAmount > 0 && receiptIndex < receipts.length) {
      var receipt = receipts[receiptIndex];
      if (receipt.totalAmount > 0) {
        double amountToUse =
            (receipt.totalAmount >= remainingAmount) ? remainingAmount : receipt.totalAmount;
        usedReceipts.add(ReceiptUsed(receipt.transactionType, receipt.number.toString(),
            receipt.date, receipt.totalAmount, amountToUse));
        remainingAmount -= amountToUse;
        receipt.totalAmount -= amountToUse;
        lastReceiptDate = receipt.date;
        if (receipt.totalAmount <= 0) {
          receiptIndex++;
        }
      } else {
        receiptIndex++;
      }
    }
    String status = remainingAmount > 0 ? 'open' : 'closed';
    double amountLeft = remainingAmount > 0 ? remainingAmount : 0;
    Duration durationToClose = status == 'closed'
        ? lastReceiptDate.difference(invoice.date)
        : DateTime.now().difference(invoice.date);
    result.add(InvoiceInfo(invoice.transactionType, invoice.number.toString(), invoice.date,
        invoice.totalAmount, amountLeft, status, usedReceipts, durationToClose, profit, invoice));
  }
  return result;
}

List<List<dynamic>> getCustomerProcessedInvoices(
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
      invoice.originalTransaction,
      invoice.type == TransactionType.initialCredit.name ? '' : invoice.number,
      invoice.date,
      invoice.totalAmount,
      receiptInfo,
      status,
      invoice.durationToClose.inDays,
      amountLeft,
      invoice.profit,
    ]);
  }
  return sortByDate(invoicesStatus, 2);
}
