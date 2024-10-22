import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tablets/src/common/classes/item_form_controller.dart';
import 'package:tablets/src/common/classes/item_form_data.dart';
import 'package:tablets/src/features/customers/repository/customer_repository_provider.dart';

final customerFormDataProvider = StateNotifierProvider<ItemFormData, Map<String, dynamic>>((ref) => ItemFormData({}));

final customerFormControllerProvider = Provider<ItemFormController>((ref) {
  final repository = ref.read(customerRepositoryProvider);
  return ItemFormController(repository);
});
