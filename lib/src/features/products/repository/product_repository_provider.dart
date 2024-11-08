import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tablets/src/common/classes/db_repository.dart';

final productRepositoryProvider = Provider<DbRepository>((ref) => DbRepository('products'));

final productStreamProvider = StreamProvider.autoDispose<List<Map<String, dynamic>>>((ref) {
  final productRepository = ref.watch(productRepositoryProvider);
  return productRepository.watchItemListAsMaps();
});
