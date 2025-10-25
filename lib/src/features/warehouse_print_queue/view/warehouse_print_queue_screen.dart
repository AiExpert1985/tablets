import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tablets/generated/l10n.dart';
import 'package:tablets/src/common/providers/page_title_provider.dart';
import 'package:tablets/src/common/widgets/empty_screen.dart';
import 'package:tablets/src/common/widgets/main_frame.dart';
import 'package:tablets/src/common/widgets/page_loading.dart';
import 'package:tablets/src/features/warehouse_print_queue/controllers/warehouse_print_job_cache.dart';
import 'package:tablets/src/features/warehouse_print_queue/controllers/warehouse_print_queue_providers.dart';
import 'package:tablets/src/features/warehouse_print_queue/widgets/warehouse_print_job_tile.dart';

class WarehousePrintQueueScreen extends ConsumerStatefulWidget {
  const WarehousePrintQueueScreen({super.key});

  @override
  ConsumerState<WarehousePrintQueueScreen> createState() =>
      _WarehousePrintQueueScreenState();
}

class _WarehousePrintQueueScreenState
    extends ConsumerState<WarehousePrintQueueScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final notifier = ref.read(pageTitleProvider.notifier);
      notifier.state = S.of(context).warehouse_print_queue_title;
    });
  }

  @override
  Widget build(BuildContext context) {
    final jobsAsync = ref.watch(pendingWarehouseJobsProvider);
    final cacheNotifier = ref.read(warehousePrintJobCacheProvider.notifier);
    final cache = ref.watch(warehousePrintJobCacheProvider);

    final content = jobsAsync.when(
      data: (jobs) {
        if (jobs.isEmpty) {
          return const EmptyPage();
        }
        return ListView.separated(
          itemBuilder: (context, index) {
            final job = jobs[index];
            unawaited(cacheNotifier.prefetch(job));
            final pdfBytes = cache[job.invoiceId];
            return WarehousePrintJobTile(job: job, cachedPdf: pdfBytes);
          },
          separatorBuilder: (context, index) => const SizedBox(height: 12),
          itemCount: jobs.length,
        );
      },
      loading: () => const PageLoading(),
      error: (error, stackTrace) => Center(
        child: Text(
          S.of(context).warehouse_print_queue_error,
          textAlign: TextAlign.center,
        ),
      ),
    );

    return AppScreenFrame(
      Padding(
        padding: const EdgeInsets.all(16),
        child: content,
      ),
    );
  }
}
