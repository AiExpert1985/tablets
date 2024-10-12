import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tablets/src/features/products/database_controllers/product_repository_provider.dart';
import 'package:tablets/src/utils/utils.dart' as utils;

final productsStreamProvider = StreamProvider.autoDispose<List<Map<String, dynamic>>>((ref) {
  utils.CustomDebug.tempPrint('Streamer is started');
  ref.onDispose(() => utils.CustomDebug.tempPrint('Streamer was disconnected'));
  final productsRepository = ref.watch(productsRepositoryProvider);
  return productsRepository.watchProductsList();
});
