import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tablets/src/features/customers/repository/customer_db_cache_provider.dart';
import 'package:tablets/src/features/customers/repository/customer_repository_provider.dart';
import 'package:tablets/src/features/transactions/controllers/transaction_db_cache_provider.dart';
import 'package:tablets/src/features/transactions/repository/transaction_repository_provider.dart';

//! Important note
//! setting the values in the dbCache is done only once for each feature
//! when we load data from database (firebase) for the first time, that means, whenever a
//! change happened to a feature (add, update, delete), we update the cache and
//! database with same data (whether create, update or delete), so there will be no need to fetch
//! from database again

Future<void> initializeCustomerDbCache(BuildContext context, WidgetRef ref) async {
  final customerDbCache = ref.read(customerDbCacheProvider.notifier);
  if (customerDbCache.data.isEmpty) {
    final customerData = await ref.read(customerRepositoryProvider).fetchItemListAsMaps();
    customerDbCache.set(customerData);
  }
}

Future<void> initializeTransactionDbCache(BuildContext context, WidgetRef ref) async {
  final transactionDbCach = ref.read(transactionDbCacheProvider.notifier);
  if (transactionDbCach.data.isEmpty) {
    final transactionData = await ref.read(transactionRepositoryProvider).fetchItemListAsMaps();
    transactionDbCach.set(transactionData);
  }
}

// /// set properties & types of summary
// /// do the calculations (using screenControllerProvider) and use them to create the data
// Future<void> initializeScreenDataNotifier(BuildContext context, WidgetRef ref) async {
//   Map<String, dynamic> summaryTypes = {
//     totalDebtKey: 'sum',
//     openInvoicesKey: 'sum',
//     dueInvoicesKey: 'sum',
//     dueDebtKey: 'sum',
//     avgClosingDaysKey: 'avg',
//     invoicesProfitKey: 'sum',
//     giftsKey: 'sum',
//   };
//   final screenDataNotifier = ref.read(customerScreenDataProvider.notifier);
//   if (screenDataNotifier.data.isNotEmpty) return;
//   screenDataNotifier.initialize(summaryTypes);
//   // finally, we use the screenController wich internally updates the screenDataNotifier that
//   //will be used by the screen List widget (which will display UI to the user)
//   final customerDbCache = ref.read(customerDbCacheProvider.notifier);
//   final customers = customerDbCache.data;
//   final screenController = ref.read(customerScreenControllerProvider);
//   if (context.mounted) {
//     screenController.processCustomerTransactions(context, customers);
//   }
// }
