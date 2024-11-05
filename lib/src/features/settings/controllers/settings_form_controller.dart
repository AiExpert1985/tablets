import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tablets/src/common/classes/item_form_controller.dart';
import 'package:tablets/src/common/classes/item_form_data.dart';
import 'package:tablets/src/features/settings/repository/settings_repository_provider.dart';

final settingsFormDataProvider = StateNotifierProvider<ItemFormData, Map<String, dynamic>>((ref) => ItemFormData({}));

final settingsFormControllerProvider = Provider<ItemFormController>((ref) {
  final repository = ref.read(settingsRepositoryProvider);
  return ItemFormController(repository);
});
