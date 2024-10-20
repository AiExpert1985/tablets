import 'package:flutter/material.dart';
import 'package:tablets/generated/l10n.dart';
import 'package:tablets/src/common/classes/db_repository.dart';
import 'package:tablets/src/common/interfaces/base_item.dart';
import 'package:tablets/src/common/functions/user_messages.dart' as toast;

class ItemFormController {
  ItemFormController(
    this._repository,
  );
  final DbRepository _repository;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  bool validateForm() {
    final isValid = formKey.currentState!.validate();
    if (!isValid) return false;
    formKey.currentState!.save();
    return true;
  }

  void saveItemToDb(BuildContext context, BaseItem item, bool isEditMode) async {
    final success =
        isEditMode ? await _repository.updateItem(item) : await _repository.addItem(item);
    if (!context.mounted) return; // just for protection in async functions
    success
        ? toast.success(context: context, message: S.of(context).db_success_saving_doc)
        : toast.failure(context: context, message: S.of(context).db_error_saving_doc);
    _closeForm(context);
  }

  void deleteItemFromDb(BuildContext context, BaseItem item) async {
    final successful = await _repository.deleteItem(item);
    if (!context.mounted) return;
    successful
        ? toast.success(context: context, message: S.of(context).db_success_deleting_doc)
        : toast.failure(context: context, message: S.of(context).db_error_deleting_doc);
    _closeForm(context);
  }

  void _closeForm(BuildContext context) {
    Navigator.of(context).pop();
  }
}
