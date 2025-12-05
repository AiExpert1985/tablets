import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tablets/src/common/classes/db_repository.dart';
import 'package:tablets/src/common/services/cache/transaction_enrichment_helper.dart';
import 'package:tablets/src/features/transactions/repository/transaction_db_cache_provider.dart';
import 'package:tablets/src/common/services/cache/screen_cache_update_service.dart';
import 'package:tablets/src/common/services/cache/screen_cache_loader.dart';
import 'package:tablets/src/common/services/cache/daily_reconciliation_service.dart';
import 'package:tablets/src/features/customers/controllers/customer_screen_controller.dart';
import 'package:tablets/src/features/customers/repository/customer_db_cache_provider.dart';
import 'package:tablets/src/features/products/controllers/product_screen_controller.dart';
import 'package:tablets/src/features/products/repository/product_db_cache_provider.dart';
import 'package:tablets/src/features/salesmen/controllers/salesman_screen_controller.dart';
import 'package:tablets/src/features/salesmen/repository/salesman_db_cache_provider.dart';

class ScreenCacheService {
  final DbRepository _customerScreenRepo = DbRepository('customer_screen_data');
  final DbRepository _productScreenRepo = DbRepository('product_screen_data');
  final DbRepository _salesmanScreenRepo = DbRepository('salesman_screen_data');

  TransactionEnrichmentHelper? _enrichmentHelper;

  void setEnrichmentHelper(TransactionEnrichmentHelper helper) {
    _enrichmentHelper = helper;
  }

  TransactionEnrichmentHelper? get enrichmentHelper => _enrichmentHelper;

  // Exposed Repositories
  DbRepository get customerScreenRepo => _customerScreenRepo;
  DbRepository get productScreenRepo => _productScreenRepo;
  DbRepository get salesmanScreenRepo => _salesmanScreenRepo;
}

// Providers

final screenCacheServiceProvider = Provider((ref) => ScreenCacheService());

final transactionEnrichmentHelperProvider = Provider((ref) {
  final dbCache = ref.read(transactionDbCacheProvider.notifier);
  return TransactionEnrichmentHelper(dbCache);
});

final screenCacheLoaderProvider = Provider((ref) {
  final service = ref.watch(screenCacheServiceProvider);
  final helper = ref.watch(transactionEnrichmentHelperProvider);
  // Ensure service has helper
  service.setEnrichmentHelper(helper);
  return ScreenCacheLoader(service, helper);
});

final screenCacheUpdateServiceProvider =
    Provider<ScreenCacheUpdateService>((ref) {
  final service = ref.watch(screenCacheServiceProvider);
  // Ensure helper is set if possibly accessed via service
  final helper = ref.watch(transactionEnrichmentHelperProvider);
  service.setEnrichmentHelper(helper);

  final updateService = ScreenCacheUpdateService(service);

  // Controllers
  final customerController = ref.read(customerScreenControllerProvider);
  final productController = ref.read(productScreenControllerProvider);
  final salesmanController = ref.read(salesmanScreenControllerProvider);

  // DbCaches
  final customerDbCache = ref.read(customerDbCacheProvider.notifier);
  final productDbCache = ref.read(productDbCacheProvider.notifier);
  final salesmanDbCache = ref.read(salesmanDbCacheProvider.notifier);

  updateService.setCalculators(
    getCustomerScreenData: (dbRef) async {
      return customerController.getItemScreenData(
          null, customerDbCache.getItemByDbRef(dbRef));
    },
    getProductScreenData: (dbRef) async {
      return productController.getItemScreenData(
          null, productDbCache.getItemByDbRef(dbRef));
    },
    getSalesmanScreenData: (dbRef) async {
      return salesmanController.getItemScreenData(
          null, salesmanDbCache.getItemByDbRef(dbRef));
    },
  );

  updateService.setIterators(
    getAllCustomerDbRefs: () =>
        customerDbCache.data.map((e) => e['dbRef'] as String).toList(),
    getAllProductDbRefs: () =>
        productDbCache.data.map((e) => e['dbRef'] as String).toList(),
    getAllSalesmanDbRefs: () =>
        salesmanDbCache.data.map((e) => e['dbRef'] as String).toList(),
  );

  return updateService;
});

final dailyReconciliationServiceProvider = Provider((ref) {
  final updateService = ref.watch(screenCacheUpdateServiceProvider);
  return DailyReconciliationService(updateService);
});
