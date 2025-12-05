import 'package:tablets/src/common/classes/db_repository.dart';
import 'package:tablets/src/common/functions/debug_print.dart';
import 'package:tablets/src/common/services/cache/screen_cache_service.dart';
import 'package:tablets/src/features/transactions/model/transaction.dart';

class ScreenCacheUpdateService {
  final ScreenCacheService _cacheService;

  ScreenCacheUpdateService(this._cacheService);

  // Functional interfaces
  Future<Map<String, dynamic>> Function(String dbRef)? _getCustomerScreenData;
  Future<Map<String, dynamic>> Function(String dbRef)? _getProductScreenData;
  Future<Map<String, dynamic>> Function(String dbRef)? _getSalesmanScreenData;

  // Iterators for reconciliation
  List<String> Function()? _getAllCustomerDbRefs;
  List<String> Function()? _getAllProductDbRefs;
  List<String> Function()? _getAllSalesmanDbRefs;

  void setCalculators({
    Future<Map<String, dynamic>> Function(String)? getCustomerScreenData,
    Future<Map<String, dynamic>> Function(String)? getProductScreenData,
    Future<Map<String, dynamic>> Function(String)? getSalesmanScreenData,
  }) {
    _getCustomerScreenData = getCustomerScreenData;
    _getProductScreenData = getProductScreenData;
    _getSalesmanScreenData = getSalesmanScreenData;
  }

  void setIterators({
    List<String> Function()? getAllCustomerDbRefs,
    List<String> Function()? getAllProductDbRefs,
    List<String> Function()? getAllSalesmanDbRefs,
  }) {
    _getAllCustomerDbRefs = getAllCustomerDbRefs;
    _getAllProductDbRefs = getAllProductDbRefs;
    _getAllSalesmanDbRefs = getAllSalesmanDbRefs;
  }

  Future<void> onTransactionChanged(
      Transaction? oldTxn, Transaction? newTxn) async {
    // 1. Identify Affected Entities
    Set<String> affectedCustomers = {};
    Set<String> affectedProducts = {};
    Set<String> affectedSalesmen = {};

    if (oldTxn != null) {
      if (oldTxn.nameDbRef != null) affectedCustomers.add(oldTxn.nameDbRef!);
      if (oldTxn.salesmanDbRef != null) {
        affectedSalesmen.add(oldTxn.salesmanDbRef!);
      }
      if (oldTxn.items != null) {
        for (var item in oldTxn.items!) {
          if (item['dbRef'] != null) affectedProducts.add(item['dbRef']);
        }
      }
    }

    if (newTxn != null) {
      if (newTxn.nameDbRef != null) affectedCustomers.add(newTxn.nameDbRef!);
      if (newTxn.salesmanDbRef != null) {
        affectedSalesmen.add(newTxn.salesmanDbRef!);
      }
      if (newTxn.items != null) {
        for (var item in newTxn.items!) {
          if (item['dbRef'] != null) affectedProducts.add(item['dbRef']);
        }
      }
    }

    // 2. Update Caches (Sequential to avoid race conditions if needed, but parallel is fine for diverse entities)

    // Update Products
    for (var prodDbRef in affectedProducts) {
      if (_getProductScreenData != null) {
        await _updateEntityCache(
            prodDbRef, _getProductScreenData!, _cacheService.productScreenRepo);
      }
    }

    // Update Customers
    for (var custDbRef in affectedCustomers) {
      if (_getCustomerScreenData != null) {
        await _updateEntityCache(custDbRef, _getCustomerScreenData!,
            _cacheService.customerScreenRepo);
      }
    }

    // Update Salesmen
    for (var salesDbRef in affectedSalesmen) {
      if (_getSalesmanScreenData != null) {
        await _updateEntityCache(salesDbRef, _getSalesmanScreenData!,
            _cacheService.salesmanScreenRepo);
      }
    }
  }

  Future<void> reconcileAll() async {
    // 1. Update Products
    if (_getAllProductDbRefs != null && _getProductScreenData != null) {
      final productDbRefs = _getAllProductDbRefs!();
      for (var dbRef in productDbRefs) {
        await _updateEntityCache(
            dbRef, _getProductScreenData!, _cacheService.productScreenRepo);
      }
    }

    // 2. Update Customers
    if (_getAllCustomerDbRefs != null && _getCustomerScreenData != null) {
      final customerDbRefs = _getAllCustomerDbRefs!();
      for (var dbRef in customerDbRefs) {
        await _updateEntityCache(
            dbRef, _getCustomerScreenData!, _cacheService.customerScreenRepo);
      }
    }

    // 3. Update Salesmen
    if (_getAllSalesmanDbRefs != null && _getSalesmanScreenData != null) {
      final salesmanDbRefs = _getAllSalesmanDbRefs!();
      for (var dbRef in salesmanDbRefs) {
        await _updateEntityCache(
            dbRef, _getSalesmanScreenData!, _cacheService.salesmanScreenRepo);
      }
    }
  }

  Future<void> _updateEntityCache(
      String dbRef,
      Future<Map<String, dynamic>> Function(String) getScreenData,
      DbRepository repo) async {
    try {
      // 1. Calculate new data
      final newData = await getScreenData(dbRef);

      // 2. Convert to DbRef
      if (_cacheService.enrichmentHelper != null) {
        final dataToSave = _cacheService.enrichmentHelper!
            .convertTransactionsToDbRefs(newData);
        // We assume the document ID is the dbRef
        await repo.setDoc(dbRef, dataToSave);
      }
    } catch (e) {
      tempPrint('Error updating cache for $dbRef: $e');
    }
  }
}
