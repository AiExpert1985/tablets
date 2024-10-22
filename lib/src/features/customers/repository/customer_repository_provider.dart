import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tablets/src/common/classes/db_repository.dart';

final customerRepositoryProvider = Provider<DbRepository>((ref) {
  return DbRepository('customers');
});

final customerStreamProvider = StreamProvider.autoDispose<List<Map<String, dynamic>>>((ref) {
  final customerRepository = ref.watch(customerRepositoryProvider);
  return customerRepository.watchItemAsMaps();
});
