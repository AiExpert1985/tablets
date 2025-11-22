import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tablets/src/common/values/constants.dart';
import 'package:tablets/src/features/counters/repository/counter_repository_provider.dart';
import 'package:tablets/src/features/transactions/repository/transaction_repository_provider.dart';
import 'package:tablets/src/common/functions/debug_print.dart';
import 'package:tablets/src/features/transactions/view/transaction_show_form.dart';

// Service to migrate existing transaction data to use Firestore counters
class CounterMigrationService {
  // Initialize all transaction counters based on existing data
  Future<void> initializeAllCounters(BuildContext context, WidgetRef ref) async {
    tempPrint('Starting counter initialization...');

    final transactionTypes = [
      TransactionType.customerInvoice.name,
      TransactionType.vendorInvoice.name,
      TransactionType.customerReceipt.name,
      TransactionType.vendorReceipt.name,
      TransactionType.customerReturn.name,
      TransactionType.vendorReturn.name,
      TransactionType.expenditures.name,
      TransactionType.gifts.name,
      TransactionType.damagedItems.name,
    ];

    for (final transactionType in transactionTypes) {
      await initializeCounterForType(context, transactionType, ref);
    }

    tempPrint('Counter initialization completed!');
  }

  // Initialize counter for a specific transaction type
  // Always recalculates and overwrites existing counter based on highest transaction number
  Future<void> initializeCounterForType(BuildContext context, String transactionType, WidgetRef ref) async {
    try {
      final counterRepository = ref.read(counterRepositoryProvider);

      // Get all transactions data
      final transactionRepository = ref.read(transactionRepositoryProvider);
      final transactions = await transactionRepository.fetchItemListAsMaps();

      if (!context.mounted) return;

      // Use the tested methods from TransactionShowForm to calculate the next number
      // This includes both regular and deleted transactions
      final nextNumber = TransactionShowForm.getNextTransactionNumberFromLocalData(
          context, transactions, transactionType, ref);

      // Always overwrite the counter with the recalculated value
      await counterRepository.initializeCounter(transactionType, nextNumber);

      tempPrint(
          'Counter for $transactionType recalculated and set to: nextNumber = $nextNumber');
    } catch (e) {
      errorPrint('Error initializing counter for $transactionType: $e');
    }
  }
}

final counterMigrationServiceProvider = Provider<CounterMigrationService>((ref) {
  return CounterMigrationService();
});
