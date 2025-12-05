import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tablets/src/common/classes/db_repository.dart';
import 'package:tablets/src/common/classes/screen_cache_item.dart';
import 'package:tablets/src/common/functions/debug_print.dart';
import 'package:tablets/src/common/functions/screen_cache_helper.dart';
import 'package:tablets/src/common/providers/screen_cache_repository_providers.dart';
import 'package:tablets/src/common/values/constants.dart';
import 'package:tablets/src/features/customers/controllers/customer_screen_data_notifier.dart';
import 'package:tablets/src/features/products/controllers/product_screen_data_notifier.dart';
import 'package:tablets/src/features/salesmen/controllers/salesman_screen_data_notifier.dart';

/// Provider for the ScreenCacheUpdateService
final screenCacheUpdateServiceProvider = Provider<ScreenCacheUpdateService>((ref) {
  return ScreenCacheUpdateService(ref);
});

/// Enum for transaction operation types
enum TransactionOperation { add, edit, delete }

/// Service that handles updating screen cache when transactions change
///
/// Note: This service runs AFTER setFeatureScreenData() has been called,
/// so the ScreenDataNotifiers already have fresh data. This service just
/// saves the affected entities' data to Firebase cache.
class ScreenCacheUpdateService {
  ScreenCacheUpdateService(this._ref);

  final Ref _ref;

  /// Called when a transaction is added, edited, or deleted
  /// This runs asynchronously in the background
  /// No BuildContext needed - reads from already-updated notifiers
  Future<void> onTransactionChanged(
    Map<String, dynamic>? oldTransaction,
    Map<String, dynamic>? newTransaction,
    TransactionOperation operation,
  ) async {
    try {
      debugLog('Screen cache update triggered: $operation');

      // Get all affected entities from both old and new transaction
      final affectedEntities = _getAffectedEntities(oldTransaction, newTransaction);

      // Update cache collections sequentially: Products -> Customers -> Salesmen
      // (Salesman depends on customer data)

      // 1. Update affected products in Firebase cache
      for (var productDbRef in affectedEntities.productDbRefs) {
        await _updateProductCache(productDbRef);
      }

      // 2. Update affected customers in Firebase cache
      for (var customerDbRef in affectedEntities.customerDbRefs) {
        await _updateCustomerCache(customerDbRef);
      }

      // 3. Update affected salesmen in Firebase cache
      for (var salesmanDbRef in affectedEntities.salesmanDbRefs) {
        await _updateSalesmanCache(salesmanDbRef);
      }

      // Note: No need to refresh ScreenDataNotifiers - they were already
      // updated by setFeatureScreenData() before this method was called

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

  /// Update a single product's cache by reading from notifier
  Future<void> _updateProductCache(String productDbRef) async {
    try {
      final productNotifier = _ref.read(productScreenDataNotifier.notifier);
      final repository = _ref.read(productScreenCacheRepositoryProvider);

      // Get product screen data from the already-updated notifier
      final allProductData = productNotifier.data;
      final productData = allProductData.firstWhere(
        (p) => p['dbRef'] == productDbRef,
        orElse: () => <String, dynamic>{},
      );

      if (productData.isEmpty) {
        debugLog('Product not found in notifier for dbRef: $productDbRef');
        return;
      }

      // Convert and save to Firebase cache
      await _saveItemToCache(productData, repository);

      debugLog('Updated product cache: $productDbRef');
    } catch (e) {
      errorPrint('Error updating product cache for $productDbRef: $e');
    }
  }

  /// Update a single customer's cache by reading from notifier
  Future<void> _updateCustomerCache(String customerDbRef) async {
    try {
      final customerNotifier = _ref.read(customerScreenDataNotifier.notifier);
      final repository = _ref.read(customerScreenCacheRepositoryProvider);

      // Get customer screen data from the already-updated notifier
      final allCustomerData = customerNotifier.data;
      final customerData = allCustomerData.firstWhere(
        (c) => c['dbRef'] == customerDbRef,
        orElse: () => <String, dynamic>{},
      );

      if (customerData.isEmpty) {
        debugLog('Customer not found in notifier for dbRef: $customerDbRef');
        return;
      }

      // Convert and save to Firebase cache
      await _saveItemToCache(customerData, repository);

      debugLog('Updated customer cache: $customerDbRef');
    } catch (e) {
      errorPrint('Error updating customer cache for $customerDbRef: $e');
    }
  }

  /// Update a single salesman's cache by reading from notifier
  Future<void> _updateSalesmanCache(String salesmanDbRef) async {
    try {
      final salesmanNotifier = _ref.read(salesmanScreenDataNotifier.notifier);
      final repository = _ref.read(salesmanScreenCacheRepositoryProvider);

      // Get salesman screen data from the already-updated notifier
      final allSalesmanData = salesmanNotifier.data;
      final salesmanData = allSalesmanData.firstWhere(
        (s) => s['dbRef'] == salesmanDbRef,
        orElse: () => <String, dynamic>{},
      );

      if (salesmanData.isEmpty) {
        debugLog('Salesman not found in notifier for dbRef: $salesmanDbRef');
        return;
      }

      // Convert and save to Firebase cache
      await _saveItemToCache(salesmanData, repository);

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

    // Try to update first, if not found, add new
    try {
      await repository.updateItem(screenCacheItem);
    } catch (e) {
      await repository.addItem(screenCacheItem);
    }
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
