import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tablets/src/features/products/repository/product_repository_provider.dart';

final productsStreamProvider = StreamProvider.autoDispose<List<Map<String, dynamic>>>((ref) {
  final productsRepository = ref.watch(productsRepositoryProvider);
  return productsRepository.watchProductsList();
});
