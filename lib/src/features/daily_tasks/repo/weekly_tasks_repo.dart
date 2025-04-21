import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tablets/src/common/classes/db_repository.dart';
import 'package:tablets/src/features/daily_tasks/controllers/selected_date_provider.dart';

final weeklyTasksRepositoryProvider = Provider<DbRepository>((ref) => DbRepository('weekly-tasks'));

final weeklyTasksStreamProvider = StreamProvider.autoDispose<List<Map<String, dynamic>>>((ref) {
  final transactionRepository = ref.watch(weeklyTasksRepositoryProvider);
  final selectedDate = ref.watch(selectedDateProvider) ?? DateTime.now();
  return transactionRepository.watchItemListAsFilteredDateMaps('date', selectedDate);
});
