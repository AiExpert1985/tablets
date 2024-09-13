import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProductsController {
  void submitForm() {}
}

final productRepositoryProvider = Provider<ProductsController>((ref) {
  return ProductsController();
});
