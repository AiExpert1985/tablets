import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tablets/src/features/categories/controllers/category_filter_controllers.dart';

final categoryFiltersProvider =
    StateNotifierProvider<CategoryFiltersNotifier, Map<String, Map<String, dynamic>>>((ref) {
  return CategoryFiltersNotifier({});
});
