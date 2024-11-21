import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tablets/src/common/classes/db_cache.dart';
import 'package:tablets/src/common/classes/screen_data.dart';
import 'package:tablets/src/features/salesmen/controllers/salesman_screen_data_provider.dart';
import 'package:tablets/src/features/transactions/repository/transaction_db_cache_provider.dart';

final salesmanScreenControllerProvider = Provider<SalesmanScreenController>((ref) {
  final transactionDbCache = ref.read(transactionDbCacheProvider.notifier);
  final screenDataProvider = ref.read(salesmanScreenDataProvider);
  return SalesmanScreenController(screenDataProvider, transactionDbCache);
});

class SalesmanScreenController {
  SalesmanScreenController(
    this._screenDataProvider,
    this._transactionDbCache,
  );

  final ScreenData _screenDataProvider;
  final DbCache _transactionDbCache;
}
