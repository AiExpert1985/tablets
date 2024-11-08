import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tablets/src/common/classes/db_repository.dart';

final settingsRepositoryProvider = Provider<DbRepository>((ref) {
  return DbRepository('settings');
});

final settingsStreamProvider = StreamProvider.autoDispose<List<Map<String, dynamic>>>((ref) {
  final settingsRepository = ref.watch(settingsRepositoryProvider);
  return settingsRepository.watchItemListAsMaps();
});
