import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tablets/src/features/category/repository/category_repository_provider.dart';

final categoriesStreamProvider = StreamProvider.autoDispose<List<Map<String, dynamic>>>((ref) {
  final categoriesRepository = ref.watch(categoriesRepositoryProvider);
  return categoriesRepository.watchMapList();
});
