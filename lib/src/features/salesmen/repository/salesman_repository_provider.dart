import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tablets/src/common/classes/db_repository.dart';

final salesmanRepositoryProvider = Provider<DbRepository>((ref) {
  return DbRepository('categories');
});

final salesmanStreamProvider = StreamProvider.autoDispose<List<Map<String, dynamic>>>((ref) {
  final salesmanRepository = ref.watch(salesmanRepositoryProvider);
  return salesmanRepository.watchItemAsMaps();
});
