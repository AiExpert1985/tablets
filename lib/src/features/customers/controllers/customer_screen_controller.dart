import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tablets/generated/l10n.dart';
import 'package:tablets/src/common/classes/db_cache.dart';
import 'package:tablets/src/common/classes/screen_data.dart';
import 'package:tablets/src/common/functions/utils.dart';
import 'package:tablets/src/common/values/constants.dart';
import 'package:tablets/src/features/customers/controllers/customer_screen_data_provider.dart';
import 'package:tablets/src/features/transactions/repository/transaction_db_cache_provider.dart';
import 'package:tablets/src/features/transactions/model/transaction.dart';
import 'package:tablets/src/features/customers/model/customer.dart';

const customerDbRefKey = 'dbRef';
const customerNameKey = 'name';
const customerSalesmanKey = 'salesman';
const totalDebtKey = 'totalDebt';
const totalDebtDetailsKey = 'totalDebtDetails';
const openInvoicesKey = 'openInvoices';
const openInvoicesDetailsKey = 'openInvoicesDetails';
const dueInvoicesKey = 'dueInvoices';
const dueDebtKey = 'dueDebt';
const dueDebtDetailsKey = 'dueDebtDetails';
const avgClosingDaysKey = 'avgClosingDays';
const avgClosingDaysDetailsKey = 'avgClosingDaysDetails';
const invoicesProfitKey = 'invoicesProfit';
const invoicesProfitDetailsKey = 'invoicesProfitDetails';
const giftsKey = 'gifts';
const giftsDetailsKey = 'giftsDetails';
const inValidKey = 'inValid';

final customerScreenControllerProvider = Provider<CustomerScreenController>((ref) {
  final transactionDbCache = ref.read(transactionDbCacheProvider.notifier);
  final screenDataProvider = ref.read(customerScreenDataProvider);
  return CustomerScreenController(screenDataProvider, transactionDbCache);
});

class CustomerScreenController {
  CustomerScreenController(
    this._screenDataProvider,
    this._transactionDbCache,
  );
  final ScreenData _screenDataProvider;
  final DbCache _transactionDbCache;

  void createCustomerScreenData(BuildContext context, Map<String, dynamic> customerData) {
    final customer = Customer.fromMap(customerData);
    final customerTransactions = getCustomerTransactions(customer.dbRef);
    if (customer.initialCredit > 0) {
      customerTransactions.add(_createInitialDebtTransaction(customer));
    }
    final processedInvoices = getCustomerProcessedInvoices(context, customerTransactions, customer);
    final openInvoices = _getOpenInvoices(context, processedInvoices, 5);
    final matchingList = customerMatching(context, customerTransactions);
    final totalDebt = _getTotalDebt(matchingList, 4);
    final invoicesWithProfit = _getInvoicesWithProfit(processedInvoices);
    final totalProfit = _getTotalProfit(invoicesWithProfit, 5);
    final closedInvoices = _getClosedInvoices(context, processedInvoices, 5);
    final averageClosingDays = _calculateAverageClosingDays(closedInvoices, 6);
    final dueInvoices = _getDueInvoices(context, openInvoices, 5);
    final numDueInvoices = dueInvoices.length;
    final dueDebt = _getDueDebt(dueInvoices, 7);
    final giftTransactions = _getGiftsAndDiscounts(context, customerTransactions);
    final totalGiftsAmount = _getTotalGiftsAndDiscounts(giftTransactions, 4);
    bool inValidCustomer = _inValidCustomer(dueDebt, totalDebt, customer);

    Map<String, dynamic> newDataRow = {
      openInvoicesKey: openInvoices.length,
      openInvoicesDetailsKey: openInvoices,
      dueInvoicesKey: numDueInvoices,
      totalDebtKey: totalDebt,
      totalDebtDetailsKey: matchingList,
      invoicesProfitKey: totalProfit,
      invoicesProfitDetailsKey: invoicesWithProfit,
      avgClosingDaysKey: averageClosingDays,
      avgClosingDaysDetailsKey: closedInvoices,
      dueDebtKey: dueDebt,
      dueDebtDetailsKey: dueInvoices,
      giftsKey: totalGiftsAmount,
      giftsDetailsKey: giftTransactions,
      inValidKey: inValidCustomer,
      customerDbRefKey: customer.dbRef,
      customerNameKey: customer.name,
      customerSalesmanKey: customer.salesman,
    };
    _screenDataProvider.addData(newDataRow);
  }

  /// creates a temp transaction using customer initial debt, the transaction is used in the
  /// calculation of customer debt
  Map<String, dynamic> _createInitialDebtTransaction(Customer customer) {
    return Transaction(
      dbRef: 'na',
      name: customer.name,
      imageUrls: ['na'],
      number: 1000001,
      date: customer.initialDate,
      currency: 'na',
      transactionType: TransactionType.initialCredit.name,
      totalAmount: customer.initialCredit,
      transactionTotalProfit: 0,
    ).toMap();
  }

  /// we stop transactions if customer either exceeded limit of debt, or has dueDebt
  /// which is transactions that are not closed within allowed time (for example 20 days)
  bool _inValidCustomer(double dueDebt, double totalDebt, Customer customer) {
    return totalDebt > customer.creditLimit || dueDebt > 0;
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

  List<Map<String, dynamic>> getCustomerTransactions(String dbRef) {
    // Filter transactions for the given database reference
    final allTransactions = _transactionDbCache.data;
    List<Map<String, dynamic>> customerTransactions =
        allTransactions.where((item) => item['nameDbRef'] == dbRef).toList();

    sortListOfMapsByDate(customerTransactions, 'date');
    return customerTransactions;
  }

  List<List<dynamic>> customerMatching(
      BuildContext context, List<Map<String, dynamic>> customerTransactions) {
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

  List<List<dynamic>> _getOpenInvoices(
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

  List<List<dynamic>> _getDueInvoices(
      BuildContext context, List<List<dynamic>> openInvoicesWithoutProfit, int statusIndex) {
    if (openInvoicesWithoutProfit.isEmpty) return [];
    String dueStatus = S.of(context).invoice_status_due;
    return openInvoicesWithoutProfit.where((item) => item[statusIndex] == dueStatus).toList();
  }

  List<List<dynamic>> _getClosedInvoices(
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

  double _getTotalDebt(List<List<dynamic>> matchingList, int amountIndex) {
    if (matchingList.isEmpty) return 0;
    return matchingList.map((item) => item[amountIndex] as double).reduce((a, b) => a + b);
  }

  double _getDueDebt(List<List<dynamic>> dueInvoices, int amountIndex) {
    if (dueInvoices.isEmpty) return 0;
    return dueInvoices.map((item) => item[amountIndex] as double).reduce((a, b) => a + b);
  }

  List<List<dynamic>> _getInvoicesWithProfit(List<List<dynamic>> processedInvoices) {
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

  double _getTotalProfit(List<List<dynamic>> invoicesWithProfit, int profitIndex) {
    if (invoicesWithProfit.isEmpty) return 0;
    return invoicesWithProfit.map((item) => item[profitIndex] as double).reduce((a, b) => a + b);
  }

  int _calculateAverageClosingDays(List<List<dynamic>> processedInvoices, int daysIndex) {
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
  List<List<dynamic>> _getGiftsAndDiscounts(
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
          transaction.transactionTotalProfit,
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

    return sortListOfListsByDate(giftsAndDiscounts, 3);
  }

  double _getTotalGiftsAndDiscounts(List<List<dynamic>> giftsList, int amountIndex) {
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
    final profit = invoice.transactionTotalProfit;
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
  return sortListOfListsByDate(invoicesStatus, 2);
}
