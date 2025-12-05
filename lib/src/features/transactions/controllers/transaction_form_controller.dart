import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tablets/src/common/classes/item_form_controller.dart';
import 'package:tablets/src/features/transactions/repository/transaction_repository_provider.dart';
import 'package:tablets/src/features/transactions/model/transaction.dart';
import 'package:tablets/src/common/services/cache/screen_cache_service.dart';
import 'package:tablets/src/features/transactions/repository/transaction_db_cache_provider.dart';

final transactionFormControllerProvider = Provider<ItemFormController>((ref) {
  final repository = ref.read(transactionRepositoryProvider);
  final updateService = ref.read(screenCacheUpdateServiceProvider);
  final transactionDbCache = ref.read(transactionDbCacheProvider.notifier);

  Transaction? oldTxn;

  return ItemFormController(
    repository,
    onBeforeSave: (item, isEdit) async {
      // Capture old transaction state before saving
      if (isEdit && item is Transaction) {
        // We look up the *current* version in cache before it gets updated
        // DbRepository updates usually happen after this callback
        // But DbCache might be updated by DbRepository?
        // ItemFormController calls onBeforeSave, then updateItem.
        // DbRepository.updateItem updates Firestore.
        // So DbCache (live listener?) might update later.
        // However, we want the IN-MEMORY old state.
        final oldData = transactionDbCache.getItemByDbRef(item.dbRef);
        if (oldData.isNotEmpty) {
          oldTxn = Transaction.fromMap(oldData);
        }
      } else {
        oldTxn = null;
      }
    },
    onAfterSave: (item, isEdit) async {
      if (item is Transaction) {
        // Fire and forget cache update
        updateService.onTransactionChanged(oldTxn, item);
      }
    },
    onAfterDelete: (item) async {
      if (item is Transaction) {
        updateService.onTransactionChanged(item, null);
      }
    },
  );
});
