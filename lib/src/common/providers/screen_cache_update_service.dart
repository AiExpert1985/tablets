import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tablets/src/common/classes/db_repository.dart';
import 'package:tablets/src/common/classes/screen_cache_item.dart';
import 'package:tablets/src/common/functions/debug_print.dart';
import 'package:tablets/src/common/functions/screen_cache_helper.dart';
import 'package:tablets/src/common/providers/screen_cache_repository_providers.dart';
import 'package:tablets/src/common/values/constants.dart';
import 'package:tablets/src/features/customers/controllers/customer_screen_controller.dart';
import 'package:tablets/src/features/customers/controllers/customer_screen_data_notifier.dart';
import 'package:tablets/src/features/customers/repository/customer_db_cache_provider.dart';
import 'package:tablets/src/features/products/controllers/product_screen_controller.dart';
import 'package:tablets/src/features/products/controllers/product_screen_data_notifier.dart';
import 'package:tablets/src/features/products/repository/product_db_cache_provider.dart';
import 'package:tablets/src/features/salesmen/controllers/salesman_screen_data_notifier.dart';
import 'package:tablets/src/features/salesmen/repository/salesman_db_cache_provider.dart';
import 'package:tablets/src/features/transactions/repository/transaction_db_cache_provider.dart';
import 'package:tablets/src/common/values/features_keys.dart';

/// Provider for the ScreenCacheUpdateService
final screenCacheUpdateServiceProvider = Provider<ScreenCacheUpdateService>((ref) {
  return ScreenCacheUpdateService(ref);
});

/// Enum for transaction operation types
enum TransactionOperation { add, edit, delete }

/// Service that handles updating screen cache when transactions change
class ScreenCacheUpdateService {
  ScreenCacheUpdateService(this._ref);

  final Ref _ref;

  /// Called when a transaction is added, edited, or deleted
  /// This runs asynchronously in the background
  Future<void> onTransactionChanged(
    BuildContext context,
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

      // 1. Update affected products
      for (var productDbRef in affectedEntities.productDbRefs) {
        await _updateProductCache(context, productDbRef);
      }

      // 2. Update affected customers
      for (var customerDbRef in affectedEntities.customerDbRefs) {
        await _updateCustomerCache(context, customerDbRef);
      }

      // 3. Update affected salesmen (depends on customer data)
      for (var salesmanDbRef in affectedEntities.salesmanDbRefs) {
        await _updateSalesmanCache(context, salesmanDbRef);
      }

      // 4. Refresh ScreenDataNotifiers if screens are currently displayed
      await _refreshScreenDataNotifiers(context, affectedEntities);

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

  /// Update a single product's cache
  Future<void> _updateProductCache(BuildContext context, String productDbRef) async {
    try {
      final productDbCache = _ref.read(productDbCacheProvider.notifier);
      final productController = _ref.read(productScreenControllerProvider);
      final repository = _ref.read(productScreenCacheRepositoryProvider);

      // Get product data from cache
      final productData = productDbCache.getItemByDbRef(productDbRef);
      if (productData.isEmpty) {
        debugLog('Product not found for dbRef: $productDbRef');
        return;
      }

      // Calculate screen data for this product
      final screenData = productController.getItemScreenData(context, productData);

      // Convert and save to cache
      await _saveItemToCache(screenData, repository);

      debugLog('Updated product cache: $productDbRef');
    } catch (e) {
      errorPrint('Error updating product cache for $productDbRef: $e');
    }
  }

  /// Update a single customer's cache
  Future<void> _updateCustomerCache(BuildContext context, String customerDbRef) async {
    try {
      final customerDbCache = _ref.read(customerDbCacheProvider.notifier);
      final customerController = _ref.read(customerScreenControllerProvider);
      final repository = _ref.read(customerScreenCacheRepositoryProvider);

      // Get customer data from cache
      final customerData = customerDbCache.getItemByDbRef(customerDbRef);
      if (customerData.isEmpty) {
        debugLog('Customer not found for dbRef: $customerDbRef');
        return;
      }

      // Calculate screen data for this customer
      final screenData = customerController.getItemScreenData(context, customerData);

      // Convert and save to cache
      await _saveItemToCache(screenData, repository);

      debugLog('Updated customer cache: $customerDbRef');
    } catch (e) {
      errorPrint('Error updating customer cache for $customerDbRef: $e');
    }
  }

  /// Update a single salesman's cache
  /// This uses customer_screen_data from cache and transaction data
  Future<void> _updateSalesmanCache(BuildContext context, String salesmanDbRef) async {
    try {
      final salesmanDbCache = _ref.read(salesmanDbCacheProvider.notifier);
      final customerDbCache = _ref.read(customerDbCacheProvider.notifier);
      final transactionDbCache = _ref.read(transactionDbCacheProvider.notifier);
      final customerCacheRepository = _ref.read(customerScreenCacheRepositoryProvider);
      final salesmanCacheRepository = _ref.read(salesmanScreenCacheRepositoryProvider);
      final customerScreenDataNotifier = _ref.read(customerScreenDataNotifier.notifier);

      // Get salesman data
      final salesmanData = salesmanDbCache.getItemByDbRef(salesmanDbRef);
      if (salesmanData.isEmpty) {
        debugLog('Salesman not found for dbRef: $salesmanDbRef');
        return;
      }

      // Get all customers belonging to this salesman
      final allCustomers = customerDbCache.data;
      final salesmanCustomerDbRefs = allCustomers
          .where((c) => c['salesmanDbRef'] == salesmanDbRef)
          .map((c) => c['dbRef'] as String)
          .toList();

      // Fetch customer screen data from cache for these customers
      final customerCacheData = await customerCacheRepository.fetchItemListAsMaps();

      // Calculate salesman totals from customer cache data
      double totalDebts = 0;
      double dueDebts = 0;
      int openInvoices = 0;
      int dueInvoices = 0;
      final List<List<dynamic>> debtsDetails = [];
      final List<List<dynamic>> openInvoicesDetails = [];

      for (var customerDbRef in salesmanCustomerDbRefs) {
        final customerCache = customerCacheData.firstWhere(
          (c) => c['dbRef'] == customerDbRef,
          orElse: () => {},
        );

        if (customerCache.isNotEmpty) {
          final customerName = customerCache['name'] ?? '';
          final customerDebt = (customerCache['totalDebt'] ?? 0).toDouble();
          final customerDueDebt = (customerCache['dueDebt'] ?? 0).toDouble();
          final customerOpenInvoices = customerCache['openInvoices'] ?? 0;
          final customerDueInvoices = customerCache['dueInvoices'] ?? 0;

          totalDebts += customerDebt;
          dueDebts += customerDueDebt;
          openInvoices += customerOpenInvoices as int;
          dueInvoices += customerDueInvoices as int;
          debtsDetails.add([customerName, customerDebt, customerDueDebt]);
          openInvoicesDetails.add([customerName, customerOpenInvoices, customerDueInvoices]);
        }
      }

      // Get salesman's transactions for commission calculation
      final allTransactions = transactionDbCache.data;
      final salesmanTransactions = allTransactions
          .where((t) => t['salesmanDbRef'] == salesmanDbRef)
          .toList();

      // Calculate commission and profit
      double totalCommission = 0;
      double totalProfit = 0;
      int numInvoices = 0;
      int numReceipts = 0;
      int numReturns = 0;
      double invoicesAmount = 0;
      double receiptsAmount = 0;
      double returnsAmount = 0;
      final List<List<dynamic>> commissionDetails = [];
      final List<List<dynamic>> profitDetails = [];
      final List<List<dynamic>> invoicesDetails = [];
      final List<List<dynamic>> receiptsDetails = [];
      final List<List<dynamic>> returnsDetails = [];

      for (var t in salesmanTransactions) {
        final type = t['transactionType'] as String;
        final amount = (t['totalAmount'] ?? 0).toDouble();
        final profit = (t['transactionTotalProfit'] ?? 0).toDouble();
        final commission = (t['salesmanTransactionComssion'] ?? 0).toDouble();

        if (type == TransactionType.customerInvoice.name) {
          numInvoices++;
          invoicesAmount += amount;
          totalProfit += profit;
          totalCommission += commission;
          invoicesDetails.add([t, type, t['date'], t['name'], t['number'], amount]);
          profitDetails.add([t, type, t['date'], t['name'], t['number'], profit]);
          commissionDetails.add([t, type, t['date'], t['name'], t['number'], commission]);
        } else if (type == TransactionType.customerReceipt.name) {
          numReceipts++;
          receiptsAmount += amount;
          receiptsDetails.add([t, type, t['date'], t['name'], t['number'], amount]);
        } else if (type == TransactionType.customerReturn.name) {
          numReturns++;
          returnsAmount += amount;
          totalProfit -= profit;
          totalCommission -= commission;
          returnsDetails.add([t, type, t['date'], t['name'], t['number'], amount]);
          profitDetails.add([t, type, t['date'], t['name'], t['number'], -profit]);
          commissionDetails.add([t, type, t['date'], t['name'], t['number'], -commission]);
        }
      }

      // Build salesman screen data
      final screenData = {
        'dbRef': salesmanDbRef,
        'name': salesmanData['name'],
        'commission': totalCommission,
        'salaryDetails': commissionDetails,
        'customers': salesmanCustomerDbRefs.length,
        'customersDetails': [],
        'debts': totalDebts,
        'dueDebts': dueDebts,
        'totalDebtDetails': debtsDetails,
        'openInvoices': openInvoices,
        'openInvoicesDetails': openInvoicesDetails,
        'dueInvoices': dueInvoices,
        'profit': totalProfit,
        'profitDetails': profitDetails,
        'numInvoices': numInvoices,
        'numInvoicesDetails': invoicesDetails,
        'numReceipts': numReceipts,
        'numReceiptsDetails': receiptsDetails,
        'numReturns': numReturns,
        'numReturnsDetails': returnsDetails,
        'invoicesAmount': invoicesAmount,
        'receiptsAmount': receiptsAmount,
        'returnsAmount': returnsAmount,
      };

      // Convert and save to cache
      await _saveItemToCache(screenData, salesmanCacheRepository);

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

  /// Refresh ScreenDataNotifiers after cache update
  Future<void> _refreshScreenDataNotifiers(
    BuildContext context,
    _AffectedEntities affectedEntities,
  ) async {
    final transactionDbCache = _ref.read(transactionDbCacheProvider);

    // Refresh customer notifier if customers were affected
    if (affectedEntities.customerDbRefs.isNotEmpty) {
      final customerRepository = _ref.read(customerScreenCacheRepositoryProvider);
      final customerNotifier = _ref.read(customerScreenDataNotifier.notifier);

      final cachedData = await customerRepository.fetchItemListAsMaps();
      if (cachedData.isNotEmpty) {
        final enrichedData = enrichScreenDataList(cachedData, transactionDbCache);
        customerNotifier.initialize({
          'totalDebt': 'sum',
          'openInvoices': 'sum',
          'dueInvoices': 'sum',
          'dueDebt': 'sum',
          'avgClosingDays': 'avg',
          'invoicesProfit': 'sum',
          'gifts': 'sum',
        });
        customerNotifier.set(enrichedData);
      }
    }

    // Refresh product notifier if products were affected
    if (affectedEntities.productDbRefs.isNotEmpty) {
      final productRepository = _ref.read(productScreenCacheRepositoryProvider);
      final productNotifier = _ref.read(productScreenDataNotifier.notifier);

      final cachedData = await productRepository.fetchItemListAsMaps();
      if (cachedData.isNotEmpty) {
        final enrichedData = enrichScreenDataList(cachedData, transactionDbCache);
        productNotifier.initialize({productTotalStockPriceKey: 'sum'});
        productNotifier.set(enrichedData);
      }
    }

    // Refresh salesman notifier if salesmen were affected
    if (affectedEntities.salesmanDbRefs.isNotEmpty) {
      final salesmanRepository = _ref.read(salesmanScreenCacheRepositoryProvider);
      final salesmanNotifier = _ref.read(salesmanScreenDataNotifier.notifier);

      final cachedData = await salesmanRepository.fetchItemListAsMaps();
      if (cachedData.isNotEmpty) {
        final enrichedData = enrichScreenDataList(cachedData, transactionDbCache);
        salesmanNotifier.initialize({'commission': 'sum', 'profit': 'sum'});
        salesmanNotifier.set(enrichedData);
      }
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
