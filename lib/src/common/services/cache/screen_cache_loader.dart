import 'package:tablets/src/common/classes/db_repository.dart';
import 'package:tablets/src/common/services/cache/screen_cache_service.dart';
import 'package:tablets/src/common/services/cache/transaction_enrichment_helper.dart';

class ScreenCacheLoader {
  final ScreenCacheService _cacheService;
  final TransactionEnrichmentHelper _enrichmentHelper;

  ScreenCacheLoader(this._cacheService, this._enrichmentHelper);

  Future<List<Map<String, dynamic>>> loadCustomerScreenData({
    required Future<List<Map<String, dynamic>>> Function() calculateIfMissing,
  }) async {
    return _loadData(
      _cacheService.customerScreenRepo,
      calculateIfMissing,
    );
  }

  Future<List<Map<String, dynamic>>> loadProductScreenData({
    required Future<List<Map<String, dynamic>>> Function() calculateIfMissing,
  }) async {
    return _loadData(
      _cacheService.productScreenRepo,
      calculateIfMissing,
    );
  }

  Future<List<Map<String, dynamic>>> loadSalesmanScreenData({
    required Future<List<Map<String, dynamic>>> Function() calculateIfMissing,
  }) async {
    return _loadData(
      _cacheService.salesmanScreenRepo,
      calculateIfMissing,
    );
  }

  Future<List<Map<String, dynamic>>> _loadData(
    DbRepository repo,
    Future<List<Map<String, dynamic>>> Function() calculateIfMissing,
  ) async {
    // 1. Try to fetch from cache
    List<Map<String, dynamic>> cachedData = await repo.fetchItemListAsMaps();

    if (cachedData.isNotEmpty) {
      // Enrich data
      // We need to iterate over the list and enrich each map
      return cachedData.map((data) {
        return _enrichmentHelper.enrichDataWithTransactions(data);
      }).toList();
    }

    // 2. Cache Miss: Calculate data
    final calculatedData = await calculateIfMissing();

    // 3. Save to cache (Convert -> Save)
    // We convert the Calculated Data (which has full Transactions) to DbRefs
    for (var item in calculatedData) {
      final dataToSave = _enrichmentHelper.convertTransactionsToDbRefs(item);
      // We use 'dbRef' as the document ID if available, otherwise DbRepository might need help.
      // Assuming 'dbRef' key exists in screen data (it should, as per existing controllers).
      final docId = dataToSave['dbRef'] as String?;
      if (docId != null) {
        await repo.setDoc(docId, dataToSave);
      } else {
        // Fallback or log error? Most entities have dbRef.
        // For screen data derived from entities, dbRef should be there.
      }
    }

    return calculatedData;
  }
}
