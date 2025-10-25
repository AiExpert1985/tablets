import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tablets/generated/l10n.dart';
import 'package:tablets/src/common/functions/user_messages.dart';
import 'package:tablets/src/common/printing/print_document.dart';
import 'package:tablets/src/common/providers/user_info_provider.dart';
import 'package:tablets/src/common/values/constants.dart';
import 'package:tablets/src/common/values/transactions_common_values.dart';
import 'package:tablets/src/features/warehouse_print_queue/model/warehouse_print_job.dart';
import 'package:tablets/src/features/warehouse_print_queue/repository/warehouse_print_queue_repository.dart';

class WarehousePrintQueueService {
  WarehousePrintQueueService(this._repository);

  final WarehousePrintQueueRepository _repository;

  Future<void> enqueueInvoice(
    BuildContext context,
    WidgetRef ref,
    Map<String, dynamic> transactionData,
  ) async {
    final type = transactionData[transactionTypeKey];
    if (type != TransactionType.customerInvoice.name) {
      infoUserMessage(context, S.of(context).warehouse_print_queue_only_invoices);
      return;
    }

    final name = transactionData[nameKey] as String? ?? '';
    if (name.isEmpty) {
      failureUserMessage(context, S.of(context).warehouse_print_queue_missing_name);
      return;
    }

    final invoiceId = transactionData[dbRefKey] as String?;
    if (invoiceId == null || invoiceId.isEmpty) {
      failureUserMessage(context, S.of(context).warehouse_print_queue_missing_id);
      return;
    }

    final user = ref.read(userInfoProvider);
    if (user == null) {
      failureUserMessage(context, S.of(context).warehouse_print_queue_missing_user);
      return;
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
      await _repository.uploadInvoice(job, pdfBytes);
      successUserMessage(context, S.of(context).warehouse_print_queue_sent);
    } on FirebaseException catch (error, stackTrace) {
      failureUserMessage(
          context, error.message ?? S.of(context).warehouse_print_queue_send_error);
      debugPrint('Failed to send invoice to warehouse: ${error.message ?? error.code}');
      debugPrintStack(stackTrace: stackTrace);
    } catch (error, stackTrace) {
      failureUserMessage(context, S.of(context).warehouse_print_queue_send_error);
      debugPrint('Failed to send invoice to warehouse: $error');
      debugPrintStack(stackTrace: stackTrace);
    }
  }
}

final warehousePrintQueueServiceProvider = Provider<WarehousePrintQueueService>((ref) {
  final repository = ref.read(warehousePrintQueueRepositoryProvider);
  return WarehousePrintQueueService(repository);
});
