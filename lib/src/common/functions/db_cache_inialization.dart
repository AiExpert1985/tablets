import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tablets/src/features/categories/repository/category_db_cache_provider.dart';
import 'package:tablets/src/features/categories/repository/category_repository_provider.dart';
import 'package:tablets/src/features/customers/repository/customer_db_cache_provider.dart';
import 'package:tablets/src/features/customers/repository/customer_repository_provider.dart';
import 'package:tablets/src/features/products/repository/product_db_cache_provider.dart';
import 'package:tablets/src/features/products/repository/product_repository_provider.dart';
import 'package:tablets/src/features/regions/model/region_db_cache_provider.dart';
import 'package:tablets/src/features/regions/repository/region_repository_provider.dart';
import 'package:tablets/src/features/salesmen/repository/salesman_db_cache_provider.dart';
import 'package:tablets/src/features/salesmen/repository/salesman_repository_provider.dart';
import 'package:tablets/src/features/settings/repository/settings_db_cache_provider.dart';
import 'package:tablets/src/features/settings/repository/settings_repository_provider.dart';
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

Future<void> initializeAllDbCaches(BuildContext context, WidgetRef ref) async {
  if (context.mounted) {
    await _initializeTransactionDbCache(context, ref);
  }
  // initialize related dbCaches
  if (context.mounted) {
    await _initializeCustomerDbCache(context, ref);
  }
  if (context.mounted) {
    await _initializeProductDbCache(context, ref);
  }
  if (context.mounted) {
    await _initializeVendorDbCache(context, ref);
  }
  if (context.mounted) {
    await _initializeSalesmanDbCache(context, ref);
  }
  if (context.mounted) {
    await _initializeCategoriesDbCache(context, ref);
  }
  if (context.mounted) {
    await _initializeRegionsDbCache(context, ref);
  }
  if (context.mounted) {
    await _initializeSettingsDbCache(context, ref);
  }
}

Future<void> _initializeCustomerDbCache(BuildContext context, WidgetRef ref) async {
  final customerDbCache = ref.read(customerDbCacheProvider.notifier);
  if (customerDbCache.data.isEmpty) {
    final customerData = await ref.read(customerRepositoryProvider).fetchItemListAsMaps();
    customerDbCache.set(customerData);
  }
}

Future<void> _initializeTransactionDbCache(BuildContext context, WidgetRef ref) async {
  final transactionDbCach = ref.read(transactionDbCacheProvider.notifier);
  if (transactionDbCach.data.isEmpty) {
    final transactionData = await ref.read(transactionRepositoryProvider).fetchItemListAsMaps();
    transactionDbCach.set(transactionData);
  }
}

Future<void> _initializeProductDbCache(BuildContext context, WidgetRef ref) async {
  final productDbCach = ref.read(productDbCacheProvider.notifier);
  if (productDbCach.data.isEmpty) {
    final productData = await ref.read(productRepositoryProvider).fetchItemListAsMaps();
    productDbCach.set(productData);
  }
}

Future<void> _initializeVendorDbCache(BuildContext context, WidgetRef ref) async {
  final vendorDbCach = ref.read(vendorDbCacheProvider.notifier);
  if (vendorDbCach.data.isEmpty) {
    final vendorData = await ref.read(vendorRepositoryProvider).fetchItemListAsMaps();
    vendorDbCach.set(vendorData);
  }
}

Future<void> _initializeSalesmanDbCache(BuildContext context, WidgetRef ref) async {
  final salesmanDbCach = ref.read(salesmanDbCacheProvider.notifier);
  if (salesmanDbCach.data.isEmpty) {
    final salesmanData = await ref.read(salesmanRepositoryProvider).fetchItemListAsMaps();
    salesmanDbCach.set(salesmanData);
  }
}

Future<void> _initializeCategoriesDbCache(BuildContext context, WidgetRef ref) async {
  final categoriesDbCach = ref.read(categoryDbCacheProvider.notifier);
  if (categoriesDbCach.data.isEmpty) {
    final salesmanData = await ref.read(categoryRepositoryProvider).fetchItemListAsMaps();
    categoriesDbCach.set(salesmanData);
  }
}

Future<void> _initializeRegionsDbCache(BuildContext context, WidgetRef ref) async {
  final regionDbCach = ref.read(regionDbCacheProvider.notifier);
  if (regionDbCach.data.isEmpty) {
    final salesmanData = await ref.read(regionRepositoryProvider).fetchItemListAsMaps();
    regionDbCach.set(salesmanData);
  }
}

Future<void> _initializeSettingsDbCache(BuildContext context, WidgetRef ref) async {
  final settingsDbCache = ref.read(settingsDbCacheProvider.notifier);
  if (settingsDbCache.data.isEmpty) {
    final settingsData = await ref.read(settingsRepositoryProvider).fetchItemListAsMaps();
    settingsDbCache.set(settingsData);
  }
}

List<Map<String, dynamic>> getTransactionDbCacheData(WidgetRef ref) {
  final transactionsDbCache = ref.read(transactionDbCacheProvider.notifier);
  return transactionsDbCache.data;
}

List<Map<String, dynamic>> getProductsDbCacheData(WidgetRef ref) {
  final dbCache = ref.read(productDbCacheProvider.notifier);
  return dbCache.data;
}

List<Map<String, dynamic>> getCategoriesDbCacheData(WidgetRef ref) {
  final dbCache = ref.read(categoryDbCacheProvider.notifier);
  return dbCache.data;
}

List<Map<String, dynamic>> getVendorsDbCacheData(WidgetRef ref) {
  final dbCache = ref.read(vendorDbCacheProvider.notifier);
  return dbCache.data;
}

List<Map<String, dynamic>> getSalesmenDbCacheData(WidgetRef ref) {
  final dbCache = ref.read(salesmanDbCacheProvider.notifier);
  return dbCache.data;
}

List<Map<String, dynamic>> getCustomersDbCacheData(WidgetRef ref) {
  final dbCache = ref.read(customerDbCacheProvider.notifier);
  return dbCache.data;
}

List<Map<String, dynamic>> getRegionsDbCacheData(WidgetRef ref) {
  final dbCache = ref.read(regionDbCacheProvider.notifier);
  return dbCache.data;
}

List<Map<String, dynamic>> getSettingsDbCacheData(WidgetRef ref) {
  final dbCache = ref.read(settingsDbCacheProvider.notifier);
  return dbCache.data;
}
