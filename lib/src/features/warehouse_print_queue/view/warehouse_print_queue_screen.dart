import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tablets/generated/l10n.dart';
import 'package:tablets/src/features/warehouse_print_queue/controllers/warehouse_print_job_cache.dart';
import 'package:tablets/src/features/warehouse_print_queue/controllers/warehouse_print_queue_providers.dart';
import 'package:tablets/src/features/warehouse_print_queue/widgets/warehouse_print_job_tile.dart';

class WarehousePrintQueueScreen extends ConsumerWidget {
  const WarehousePrintQueueScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final jobsAsync = ref.watch(pendingWarehouseJobsProvider);
    final cache = ref.read(warehousePrintJobCacheProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).warehouse_print_queue_title),
      ),
      body: jobsAsync.when(
        data: (jobs) {
          for (final job in jobs) {
            cache.prefetch(job);
          }
          if (jobs.isEmpty) {
            return Center(
              child: Text(S.of(context).warehouse_print_queue_empty),
            );
          }
          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: jobs.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final job = jobs[index];
              return WarehousePrintJobTile(job: job);
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => Center(
          child: Text(S.of(context).warehouse_print_queue_error),
        ),
      ),
    );
  }
}
