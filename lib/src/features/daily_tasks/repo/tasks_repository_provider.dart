import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tablets/src/common/classes/db_repository.dart';

final tasksRepositoryProvider = Provider<DbRepository>((ref) => DbRepository('tasks'));

final tasksStreamProvider = StreamProvider.autoDispose<List<Map<String, dynamic>>>((ref) {
  final transactionRepository = ref.watch(tasksRepositoryProvider);
  return transactionRepository.watchItemListAsMaps();
});
