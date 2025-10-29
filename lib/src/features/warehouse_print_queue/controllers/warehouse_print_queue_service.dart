import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tablets/src/common/functions/debug_print.dart';
import 'package:tablets/src/common/printing/print_document.dart';
import 'package:tablets/src/common/values/constants.dart';
import 'package:tablets/src/common/values/transactions_common_values.dart';
import 'package:tablets/src/features/authentication/model/user_account.dart';
import 'package:tablets/src/features/warehouse_print_queue/model/warehouse_print_job.dart';
import 'package:tablets/src/features/warehouse_print_queue/repository/warehouse_print_queue_repository.dart';

class WarehousePrintQueueService {
  WarehousePrintQueueService(this._repository);

  final WarehousePrintQueueRepository _repository;

  Future<WarehousePrintJob> enqueueInvoice({
    required BuildContext context,
    required WidgetRef ref,
    required Map<String, dynamic> transactionData,
    required UserAccount user,
  }) async {
    final type = transactionData[transactionTypeKey];
    if (type != TransactionType.customerInvoice.name) {
      throw const WarehouseEnqueueException(WarehouseEnqueueFailure.unsupportedType);
    }

    final name = (transactionData[nameKey] as String? ?? '').trim();
    if (name.isEmpty) {
      throw const WarehouseEnqueueException(WarehouseEnqueueFailure.missingClientName);
    }

    final invoiceId = transactionData[dbRefKey] as String?;
    if (invoiceId == null || invoiceId.isEmpty) {
      throw const WarehouseEnqueueException(WarehouseEnqueueFailure.missingInvoiceId);
    }

    final invoiceDateRaw = transactionData[dateKey];
    final DateTime invoiceDate;
    if (invoiceDateRaw is DateTime) {
      invoiceDate = invoiceDateRaw;
    } else if (invoiceDateRaw is Timestamp) {
      invoiceDate = invoiceDateRaw.toDate();
    } else {
      invoiceDate = DateTime.now();
    }

    final items = (transactionData[itemsKey] as List<dynamic>? ?? [])
        .cast<Map<String, dynamic>>();
    final int itemCount = items.fold(0, (previousValue, item) {
      final sold = (item[itemSoldQuantityKey] as num?)?.toInt() ?? 0;
      final gift = (item[itemGiftQuantityKey] as num?)?.toInt() ?? 0;
      return previousValue + sold + gift;
    });

    final totalAmount = (transactionData[totalAmountKey] as num?)?.toDouble() ?? 0;
    final invoiceNumber = transactionData[numberKey]?.toString() ?? '';

    final job = WarehousePrintJob(
      invoiceId: invoiceId,
      invoiceNumber: invoiceNumber,
      clientName: name,
      invoiceDate: invoiceDate,
      itemCount: max(itemCount, items.length),
      totalPrice: totalAmount,
      storagePath: 'warehouse_invoices/$invoiceId.pdf',
      status: WarehousePrintJob.pendingStatus,
      createdAt: DateTime.now(),
      createdById: user.dbRef,
      createdByName: user.name,
      version: 0,
    );

    try {
      final pdfBytes = await buildTransactionPdfBytes(context, ref, transactionData);
      try {
        await _repository.uploadInvoice(job, pdfBytes);
        return job;
      } on FirebaseException catch (error, stackTrace) {
        errorPrint('Failed to upload invoice ${job.invoiceId} for warehouse - ${error.message ?? error.code}',
            stackTrace: stackTrace);
        throw WarehouseEnqueueException(WarehouseEnqueueFailure.uploadFailed, details: error);
      } catch (error, stackTrace) {
        errorPrint('Failed to upload invoice ${job.invoiceId} for warehouse - $error',
            stackTrace: stackTrace);
        throw WarehouseEnqueueException(WarehouseEnqueueFailure.uploadFailed, details: error);
      }
    } catch (error, stackTrace) {
      errorPrint('Failed to build invoice ${job.invoiceId} pdf for warehouse - $error',
          stackTrace: stackTrace);
      throw WarehouseEnqueueException(WarehouseEnqueueFailure.pdfGenerationFailed, details: error);
    }
  }
}

final warehousePrintQueueServiceProvider = Provider<WarehousePrintQueueService>((ref) {
  final repository = ref.read(warehousePrintQueueRepositoryProvider);
  return WarehousePrintQueueService(repository);
});

class WarehouseEnqueueException implements Exception {
  const WarehouseEnqueueException(this.reason, {this.details});

  final WarehouseEnqueueFailure reason;
  final Object? details;
}

enum WarehouseEnqueueFailure {
  unsupportedType,
  missingClientName,
  missingInvoiceId,
  uploadFailed,
  pdfGenerationFailed,
}
