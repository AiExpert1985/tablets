import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tablets/src/common/functions/utils.dart' as utils;

enum FilterCriteria { contains, equals, lessThanOrEqual, lessThan, moreThanOrEqual, moreThan }

enum DataTypes { int, double, string }

/// add filter to filtersMap
/// if value is empty, then the filter is removed from filtersMap
Map<String, Map<String, dynamic>> updateFilters({
  required Map<String, Map<String, dynamic>> filters,
  required String dataType,
  required String key,
  required dynamic value,
  required String filterCriteria,
}) {
  if (value == null || value.isEmpty) {
    filters.remove(key);
    return filters;
  }
  if (dataType == DataTypes.int.name) {
    value = int.parse(value);
  }
  if (dataType == DataTypes.double.name) {
    value = double.parse(value);
  }
  filters[key] = {
    'value': value,
    'criteria': filterCriteria,
  };
  return filters;
}

/// filters should have these keys {'xxx':{'criteria': xxx, 'value': xxx}}
AsyncValue<List<Map<String, dynamic>>> applyListFilter({
  required AsyncValue<List<Map<String, dynamic>>> listValue,
  required Map<String, Map<String, dynamic>> filters,
}) {
  List<Map<String, dynamic>> filteredList = utils.convertAsyncValueListToList(listValue);
  filters.forEach((key, filter) {
    String criteria = filter['criteria'];
    dynamic value = filter['value'];
    if (criteria == FilterCriteria.contains.name) {
      filteredList = filteredList.where((item) => item[key].contains(value)).toList();
      return;
    }
    if (criteria == FilterCriteria.equals.name) {
      filteredList = filteredList.where((product) => product[key] == value).toList();
      return;
    }
  });
  return AsyncValue.data(filteredList);
}
