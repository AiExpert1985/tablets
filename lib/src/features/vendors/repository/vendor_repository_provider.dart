import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tablets/src/common/classes/db_repository.dart';

final vendorRepositoryProvider = Provider<DbRepository>((ref) {
  return DbRepository('vendors');
});

final vendorStreamProvider = StreamProvider.autoDispose<List<Map<String, dynamic>>>((ref) {
  final vendorRepository = ref.watch(vendorRepositoryProvider);
  return vendorRepository.watchItemListAsMaps();
});
