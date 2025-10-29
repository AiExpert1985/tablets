import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tablets/src/features/warehouse_print_queue/model/warehouse_print_job.dart';
import 'package:tablets/src/features/warehouse_print_queue/repository/warehouse_print_queue_repository.dart';

final warehouseJobStreamProvider =
    StreamProvider.family.autoDispose<WarehousePrintJob?, String>((ref, invoiceId) {
  final repository = ref.read(warehousePrintQueueRepositoryProvider);
  return repository.watchJob(invoiceId);
});

final pendingWarehouseJobsProvider =
    StreamProvider.autoDispose<List<WarehousePrintJob>>((ref) {
  final repository = ref.read(warehousePrintQueueRepositoryProvider);
  return repository.watchPendingJobs();
});
