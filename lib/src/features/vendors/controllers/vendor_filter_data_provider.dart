import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tablets/src/features/vendors/controllers/vendor_filtered_list.dart';

final vendorFiltersProvider =
    StateNotifierProvider<VendorFiltersNotifier, Map<String, Map<String, dynamic>>>((ref) {
  return VendorFiltersNotifier({});
});
