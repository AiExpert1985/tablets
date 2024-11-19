import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tablets/src/common/classes/screen_data.dart';

final productScreenDataProvider = Provider<ScreenData>((ref) {
  final data = <Map<String, dynamic>>[];
  return ScreenData(data);
});
