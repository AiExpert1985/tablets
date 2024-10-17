import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tablets/src/features/categories/controllers/category_filtered_list.dart';

final categoryFiltersProvider =
    StateNotifierProvider<CategoryFiltersNotifier, Map<String, Map<String, dynamic>>>((ref) {
  return CategoryFiltersNotifier({});
});
