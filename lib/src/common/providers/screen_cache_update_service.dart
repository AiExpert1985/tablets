import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tablets/src/common/classes/db_repository.dart';
import 'package:tablets/src/common/classes/screen_cache_item.dart';
import 'package:tablets/src/common/functions/debug_print.dart';
import 'package:tablets/src/common/functions/screen_cache_helper.dart';
import 'package:tablets/src/common/providers/screen_cache_repository_providers.dart';
import 'package:tablets/src/common/values/constants.dart';
import 'package:tablets/src/features/customers/controllers/customer_screen_controller.dart';
import 'package:tablets/src/features/customers/repository/customer_db_cache_provider.dart';
import 'package:tablets/src/features/products/controllers/product_screen_controller.dart';
import 'package:tablets/src/features/products/repository/product_db_cache_provider.dart';
import 'package:tablets/src/features/salesmen/controllers/salesman_screen_controller.dart';
import 'package:tablets/src/features/salesmen/repository/salesman_db_cache_provider.dart';

/// Provider for the ScreenCacheUpdateService
final screenCacheUpdateServiceProvider =
    Provider<ScreenCacheUpdateService>((ref) {
  return ScreenCacheUpdateService(ref);
});

/// Enum for transaction operation types
enum TransactionOperation { add, edit, delete }

/// Service that handles updating screen cache when transactions change
///
/// This service recalculates affected entities' screen data using the
/// getItemScreenData() method from each screen controller, then saves
/// the result to Firebase cache.
class ScreenCacheUpdateService {
  ScreenCacheUpdateService(this._ref);

  final Ref _ref;

  /// Called when a transaction is added, edited, or deleted
  /// This runs asynchronously in the background
  /// Requires BuildContext for translations in getItemScreenData
  Future<void> onTransactionChanged(
    BuildContext context,
    Map<String, dynamic>? oldTransaction,
    Map<String, dynamic>? newTransaction,
    TransactionOperation operation,
  ) async {
    try {
      debugLog('Screen cache update triggered: $operation');

      // Get all affected entities from both old and new transaction
      final affectedEntities =
          _getAffectedEntities(oldTransaction, newTransaction);

      // Update cache collections sequentially: Products -> Customers -> Salesmen
      // (Salesman depends on customer data)

      // 1. Update affected products in Firebase cache
      for (var productDbRef in affectedEntities.productDbRefs) {
        if (!context.mounted) return;
        await _updateProductCache(context, productDbRef);
      }

      // 2. Update affected customers in Firebase cache
      for (var customerDbRef in affectedEntities.customerDbRefs) {
        if (!context.mounted) return;
        await _updateCustomerCache(context, customerDbRef);
      }

      // 3. Update affected salesmen in Firebase cache
      for (var salesmanDbRef in affectedEntities.salesmanDbRefs) {
        if (!context.mounted) return;
        await _updateSalesmanCache(context, salesmanDbRef);
      }

      debugLog('Screen cache update completed');
    } catch (e) {
      errorPrint('Error updating screen cache: $e');
    }
  }

  /// Get all entities affected by transaction change
  _AffectedEntities _getAffectedEntities(
    Map<String, dynamic>? oldTransaction,
    Map<String, dynamic>? newTransaction,
  ) {
    final Set<String> customerDbRefs = {};
    final Set<String> salesmanDbRefs = {};
    final Set<String> productDbRefs = {};

    // Extract from old transaction
    if (oldTransaction != null) {
      _extractEntitiesFromTransaction(
        oldTransaction,
        customerDbRefs,
        salesmanDbRefs,
        productDbRefs,
      );
    }

    // Extract from new transaction
    if (newTransaction != null) {
      _extractEntitiesFromTransaction(
        newTransaction,
        customerDbRefs,
        salesmanDbRefs,
        productDbRefs,
      );
    }

    return _AffectedEntities(
      customerDbRefs: customerDbRefs,
      salesmanDbRefs: salesmanDbRefs,
      productDbRefs: productDbRefs,
    );
  }

  /// Extract entity dbRefs from a transaction
  void _extractEntitiesFromTransaction(
    Map<String, dynamic> transaction,
    Set<String> customerDbRefs,
    Set<String> salesmanDbRefs,
    Set<String> productDbRefs,
  ) {
    final type = transaction['transactionType'] as String?;

    // Customer transactions have nameDbRef pointing to customer
    if (type != null && _isCustomerTransaction(type)) {
      final nameDbRef = transaction['nameDbRef'] as String?;
      if (nameDbRef != null && nameDbRef.isNotEmpty) {
        customerDbRefs.add(nameDbRef);
      }
    }

    // Salesman dbRef
    final salesmanDbRef = transaction['salesmanDbRef'] as String?;
    if (salesmanDbRef != null && salesmanDbRef.isNotEmpty) {
      salesmanDbRefs.add(salesmanDbRef);
    }

    // Product dbRefs from items
    final items = transaction['items'] as List<dynamic>?;
    if (items != null) {
      for (var item in items) {
        if (item is Map) {
          final productDbRef = item['dbRef'] as String?;
          if (productDbRef != null && productDbRef.isNotEmpty) {
            productDbRefs.add(productDbRef);
          }
        }
      }
    }
  }

  /// Check if transaction type is customer-related
  bool _isCustomerTransaction(String type) {
    return type == TransactionType.customerInvoice.name ||
        type == TransactionType.customerReceipt.name ||
        type == TransactionType.customerReturn.name ||
        type == TransactionType.gifts.name ||
        type == TransactionType.initialCredit.name;
  }

  /// Update a single product's cache by recalculating using controller
  Future<void> _updateProductCache(
      BuildContext context, String productDbRef) async {
    try {
      final productDbCache = _ref.read(productDbCacheProvider.notifier);
      final productController = _ref.read(productScreenControllerProvider);
      final repository = _ref.read(productScreenCacheRepositoryProvider);

      // Get raw product data from dbCache
      final productData = productDbCache.getItemByDbRef(productDbRef);
      if (productData.isEmpty) {
        debugLog('Product not found in dbCache: $productDbRef');
        return;
      }

      // Recalculate screen data for this product using controller
      final screenData =
          productController.getItemScreenData(context, productData);

      // Convert and save to Firebase cache
      await _saveItemToCache(screenData, repository);

      debugLog('Updated product cache: $productDbRef');
    } catch (e) {
      errorPrint('Error updating product cache for $productDbRef: $e');
    }
  }

  /// Update a single customer's cache by recalculating using controller
  Future<void> _updateCustomerCache(
      BuildContext context, String customerDbRef) async {
    try {
      final customerDbCache = _ref.read(customerDbCacheProvider.notifier);
      final customerController = _ref.read(customerScreenControllerProvider);
      final repository = _ref.read(customerScreenCacheRepositoryProvider);

      // Get raw customer data from dbCache
      final customerData = customerDbCache.getItemByDbRef(customerDbRef);
      if (customerData.isEmpty) {
        debugLog('Customer not found in dbCache: $customerDbRef');
        return;
      }

      // Recalculate screen data for this customer using controller
      final screenData =
          customerController.getItemScreenData(context, customerData);

      // Convert and save to Firebase cache
      await _saveItemToCache(screenData, repository);

      debugLog('Updated customer cache: $customerDbRef');
    } catch (e) {
      errorPrint('Error updating customer cache for $customerDbRef: $e');
    }
  }

  /// Update a single salesman's cache by recalculating using controller
  Future<void> _updateSalesmanCache(
      BuildContext context, String salesmanDbRef) async {
    try {
      final salesmanDbCache = _ref.read(salesmanDbCacheProvider.notifier);
      final salesmanController = _ref.read(salesmanScreenControllerProvider);
      final repository = _ref.read(salesmanScreenCacheRepositoryProvider);

      // Get raw salesman data from dbCache
      final salesmanData = salesmanDbCache.getItemByDbRef(salesmanDbRef);
      if (salesmanData.isEmpty) {
        debugLog('Salesman not found in dbCache: $salesmanDbRef');
        return;
      }

      // Recalculate screen data for this salesman using controller
      final screenData =
          salesmanController.getItemScreenData(context, salesmanData);

      // Convert and save to Firebase cache
      await _saveItemToCache(screenData, repository);

      debugLog('Updated salesman cache: $salesmanDbRef');
    } catch (e) {
      errorPrint('Error updating salesman cache for $salesmanDbRef: $e');
    }
  }

  /// Save a single item to cache collection
  Future<void> _saveItemToCache(
    Map<String, dynamic> screenData,
    DbRepository repository,
  ) async {
    // Convert transactions to dbRefs for storage
    final cacheItem = convertForCacheSave(screenData);
    final screenCacheItem = ScreenCacheItem(cacheItem);

    // Use dbRef as document ID for consistent cache storage
    await repository.addOrUpdateItemWithRef(screenCacheItem);
  }
}

/// Helper class to hold affected entities
class _AffectedEntities {
  final Set<String> customerDbRefs;
  final Set<String> salesmanDbRefs;
  final Set<String> productDbRefs;

  _AffectedEntities({
    required this.customerDbRefs,
    required this.salesmanDbRefs,
    required this.productDbRefs,
  });
}
