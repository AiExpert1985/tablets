import 'dart:typed_data';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:printing/printing.dart';
import 'package:tablets/generated/l10n.dart';
import 'package:tablets/src/common/functions/user_messages.dart';
import 'package:tablets/src/common/providers/user_info_provider.dart';
import 'package:tablets/src/common/values/gaps.dart';
import 'package:tablets/src/features/warehouse_print_queue/controllers/warehouse_print_job_cache.dart';
import 'package:tablets/src/features/warehouse_print_queue/model/warehouse_print_job.dart';
import 'package:tablets/src/features/warehouse_print_queue/repository/warehouse_print_queue_repository.dart';

class WarehousePrintJobTile extends ConsumerStatefulWidget {
  const WarehousePrintJobTile({required this.job, this.cachedPdf, super.key});

  final WarehousePrintJob job;
  final Uint8List? cachedPdf;

  @override
  ConsumerState<WarehousePrintJobTile> createState() => _WarehousePrintJobTileState();
}

class _WarehousePrintJobTileState extends ConsumerState<WarehousePrintJobTile> {
  bool _isPrinting = false;

  @override
  Widget build(BuildContext context) {
    final job = widget.job;
    final user = ref.watch(userInfoProvider);
    final cacheNotifier = ref.read(warehousePrintJobCacheProvider.notifier);
    final repository = ref.read(warehousePrintQueueRepositoryProvider);

    return Card(
      elevation: 1,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  S.of(context).warehouse_print_job_title(job.invoiceNumber),
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                ElevatedButton.icon(
                  onPressed: _isPrinting
                      ? null
                      : () => _printJob(
                            context,
                            repository,
                            cacheNotifier,
                            user?.dbRef,
                            user?.name,
                          ),
                  icon: _isPrinting
                      ? const SizedBox(
                          height: 18,
                          width: 18,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.print),
                  label: Text(S.of(context).warehouse_print_queue_print),
                ),
              ],
            ),
            VerticalGap.m,
            Wrap(
              spacing: 16,
              runSpacing: 8,
              children: [
                _InfoChip(
                  label: S.of(context).warehouse_print_queue_client,
                  value: job.clientName,
                ),
                _InfoChip(
                  label: S.of(context).warehouse_print_queue_date,
                  value: _formatDate(job.invoiceDate),
                ),
                _InfoChip(
                  label: S.of(context).warehouse_print_queue_created,
                  value: _formatDate(job.createdAt),
                ),
                _InfoChip(
                  label: S.of(context).warehouse_print_queue_items,
                  value: job.itemCount.toString(),
                ),
                _InfoChip(
                  label: S.of(context).warehouse_print_queue_total,
                  value: job.totalPrice.toStringAsFixed(2),
                ),
                _InfoChip(
                  label: S.of(context).warehouse_print_queue_created_by,
                  value: job.createdByName,
                ),
              ],
            ),
            if (job.printedByName != null) ...[
              VerticalGap.s,
              Text(
                S.of(context).warehouse_print_queue_already_printed(
                      job.printedByName!,
                      _formatDate(job.printedAt ?? DateTime.now()),
                    ),
                style: const TextStyle(color: Colors.red),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Future<void> _printJob(
    BuildContext context,
    WarehousePrintQueueRepository repository,
    WarehousePrintJobCacheNotifier cacheNotifier,
    String? userId,
    String? userName,
  ) async {
    if (userId == null || userName == null) {
      failureUserMessage(context, S.of(context).warehouse_print_queue_missing_user);
      return;
    }
    setState(() => _isPrinting = true);
    try {
      final pdfBytes = widget.cachedPdf ?? await cacheNotifier.ensurePdf(widget.job);
      await Printing.layoutPdf(onLayout: (_) async => pdfBytes);
      await repository.markAsPrinted(
        job: widget.job,
        printedById: userId,
        printedByName: userName,
      );
      cacheNotifier.remove(widget.job.invoiceId);
      if (context.mounted) {
        successUserMessage(context, S.of(context).warehouse_print_queue_printed);
      }
    } on FirebaseException catch (error, stackTrace) {
      if (context.mounted) {
        failureUserMessage(context, error.message ?? error.code);
      }
      debugPrint('Warehouse print failed: ${error.code}');
      debugPrintStack(stackTrace: stackTrace);
    } catch (error, stackTrace) {
      if (context.mounted) {
        failureUserMessage(context, S.of(context).warehouse_print_queue_print_error);
      }
      debugPrint('Warehouse print failed: $error');
      debugPrintStack(stackTrace: stackTrace);
    } finally {
      if (mounted) {
        setState(() => _isPrinting = false);
      }
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }
}

class _InfoChip extends StatelessWidget {
  const _InfoChip({required this.label, required this.value});
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Chip(
      label: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
          Text(value),
        ],
      ),
    );
  }
}
