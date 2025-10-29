import 'dart:typed_data';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tablets/src/common/functions/debug_print.dart';
import 'package:tablets/src/features/warehouse_print_queue/model/warehouse_print_job.dart';
import 'package:tablets/src/features/warehouse_print_queue/repository/warehouse_print_queue_repository.dart';

class WarehousePrintJobCacheNotifier extends StateNotifier<Map<String, Uint8List>> {
  WarehousePrintJobCacheNotifier(this._repository) : super(const {});

  final WarehousePrintQueueRepository _repository;

  Future<void> prefetch(WarehousePrintJob job) async {
    if (state.containsKey(job.invoiceId)) {
      return;
    }
    try {
      final data = await _repository.downloadPdf(job.invoiceId);
      state = {...state, job.invoiceId: data};
    } catch (error) {
      errorPrint('Failed to prefetch invoice ${job.invoiceId} - $error');
    }
  }

  Future<Uint8List> ensurePdf(WarehousePrintJob job) async {
    final existing = state[job.invoiceId];
    if (existing != null) {
      return existing;
    }
    final data = await _repository.downloadPdf(job.invoiceId);
    state = {...state, job.invoiceId: data};
    return data;
  }

  void remove(String invoiceId) {
    if (!state.containsKey(invoiceId)) {
      return;
    }
    final next = {...state};
    next.remove(invoiceId);
    state = next;
  }
}

final warehousePrintJobCacheProvider =
    StateNotifierProvider<WarehousePrintJobCacheNotifier, Map<String, Uint8List>>((ref) {
  final repository = ref.read(warehousePrintQueueRepositoryProvider);
  return WarehousePrintJobCacheNotifier(repository);
});
