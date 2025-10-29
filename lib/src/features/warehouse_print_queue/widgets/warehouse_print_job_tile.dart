import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:printing/printing.dart';
import 'package:tablets/generated/l10n.dart';
import 'package:tablets/src/common/functions/user_messages.dart';
import 'package:tablets/src/common/providers/user_info_provider.dart';
import 'package:tablets/src/features/warehouse_print_queue/controllers/warehouse_print_job_cache.dart';
import 'package:tablets/src/features/warehouse_print_queue/model/warehouse_print_job.dart';
import 'package:tablets/src/features/warehouse_print_queue/repository/warehouse_print_queue_repository.dart';

class WarehousePrintJobTile extends ConsumerWidget {
  const WarehousePrintJobTile({required this.job, super.key});

  final WarehousePrintJob job;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = S.of(context);
    final subtitle = _jobDetails(l10n);

    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              job.clientName,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            ...subtitle.map((line) => Text(line)).toList(),
            const SizedBox(height: 16),
            Align(
              alignment: Alignment.centerRight,
              child: FilledButton.icon(
                icon: const Icon(Icons.print_outlined),
                label: Text(l10n.print),
                onPressed: () => _onPrint(context, ref),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<String> _jobDetails(S l10n) {
    final formatter = DateFormat('dd/MM/yyyy HH:mm');
    final total = NumberFormat('#,##0.00').format(job.totalPrice);
    return [
      l10n.warehouse_print_queue_invoice(job.invoiceNumber),
      l10n.warehouse_print_queue_created(formatter.format(job.createdAt)),
      l10n.warehouse_print_queue_items(job.itemCount),
      l10n.warehouse_print_queue_total(total),
    ];
  }

  Future<void> _onPrint(BuildContext context, WidgetRef ref) async {
    final cache = ref.read(warehousePrintJobCacheProvider.notifier);
    final repository = ref.read(warehousePrintQueueRepositoryProvider);
    final user = ref.read(userInfoProvider);
    final l10n = S.of(context);

    if (user == null) {
      failureUserMessage(context, l10n.warehouse_print_queue_missing_user);
      return;
    }

    try {
      final Uint8List pdfBytes = await cache.ensurePdf(job);
      await Printing.layoutPdf(onLayout: (_) async => pdfBytes);
      if (!context.mounted) return;
      await repository.markAsPrinted(
        job: job,
        printedById: user.dbRef,
        printedByName: user.name,
      );
      cache.remove(job.invoiceId);
      if (!context.mounted) return;
      successUserMessage(context, l10n.warehouse_print_queue_marked_printed);
    } catch (error) {
      if (!context.mounted) return;
      failureUserMessage(context, l10n.warehouse_print_queue_print_error);
    }
  }
}
