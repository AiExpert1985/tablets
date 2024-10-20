import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tablets/src/common/classes/item_form_controller.dart';
import 'package:tablets/src/features/products/repository/product_repository_provider.dart';
import 'package:tablets/src/common/classes/item_form_data.dart';

final transactionFormDataProvider =
    StateNotifierProvider<ItemFormData, Map<String, dynamic>>((ref) => ItemFormData({}));

final transactionFormControllerProvider = Provider<ItemFormController>((ref) {
  final repository = ref.read(productRepositoryProvider);
  return ItemFormController(repository);
});
