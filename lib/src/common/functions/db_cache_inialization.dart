import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tablets/src/features/customers/repository/customer_db_cache_provider.dart';
import 'package:tablets/src/features/customers/repository/customer_repository_provider.dart';
import 'package:tablets/src/features/products/repository/product_db_cache_provider.dart';
import 'package:tablets/src/features/products/repository/product_repository_provider.dart';
import 'package:tablets/src/features/salesmen/repository/salesman_db_cache_provider.dart';
import 'package:tablets/src/features/salesmen/repository/salesman_repository_provider.dart';
import 'package:tablets/src/features/transactions/repository/transaction_db_cache_provider.dart';
import 'package:tablets/src/features/transactions/repository/transaction_repository_provider.dart';
import 'package:tablets/src/features/vendors/repository/vendor_db_cache_provider.dart';
import 'package:tablets/src/features/vendors/repository/vendor_repository_provider.dart';

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

Future<void> initializeProductDbCache(BuildContext context, WidgetRef ref) async {
  final productDbCach = ref.read(productDbCacheProvider.notifier);
  if (productDbCach.data.isEmpty) {
    final productData = await ref.read(productRepositoryProvider).fetchItemListAsMaps();
    productDbCach.set(productData);
  }
}

Future<void> initializeVendorDbCache(BuildContext context, WidgetRef ref) async {
  final vendorDbCach = ref.read(vendorDbCacheProvider.notifier);
  if (vendorDbCach.data.isEmpty) {
    final vendorData = await ref.read(vendorRepositoryProvider).fetchItemListAsMaps();
    vendorDbCach.set(vendorData);
  }
}

Future<void> initializeSalesmanDbCache(BuildContext context, WidgetRef ref) async {
  final salesmanDbCach = ref.read(salesmanDbCacheProvider.notifier);
  if (salesmanDbCach.data.isEmpty) {
    final salesmanData = await ref.read(salesmanRepositoryProvider).fetchItemListAsMaps();
    salesmanDbCach.set(salesmanData);
  }
}
