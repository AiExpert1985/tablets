import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tablets/src/features/regions/controllers/region_filtered_list.dart';

final regionFiltersProvider = StateNotifierProvider<RegionFiltersNotifier, Map<String, Map<String, dynamic>>>((ref) {
  return RegionFiltersNotifier({});
});
