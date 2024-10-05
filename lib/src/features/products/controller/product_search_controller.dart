import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProductSearch {
  String product = '';
}

class ProductSearchNotifier extends StateNotifier<ProductSearch> {
  ProductSearchNotifier(super.state);
}

final productSearchNotifierProvider =
    StateNotifierProvider<ProductSearchNotifier, ProductSearch>((ref) {
  return ProductSearchNotifier(ProductSearch());
});
