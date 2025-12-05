import 'package:flutter/material.dart';
import 'package:tablets/src/common/classes/db_repository.dart';
import 'package:tablets/src/common/interfaces/base_item.dart';

class ItemFormController {
  ItemFormController(
    this._repository, {
    this.onBeforeSave,
    this.onAfterSave,
    this.onAfterDelete,
  });
  final DbRepository _repository;
  final Future<void> Function(BaseItem item, bool isEditMode)? onBeforeSave;
  final Future<void> Function(BaseItem item, bool isEditMode)? onAfterSave;
  final Future<void> Function(BaseItem item)? onAfterDelete;

  // final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  // bool validateData() => formKey.currentState!.validate();

  // void submitData() => formKey.currentState!.save();

  void saveItemToDb(BuildContext context, BaseItem item, bool isEditMode,
      {bool keepDialogOpen = false}) async {
    if (onBeforeSave != null) {
      await onBeforeSave!(item, isEditMode);
    }
    await (isEditMode
        ? _repository.updateItem(item)
        : _repository.addItem(item));
    if (onAfterSave != null) {
      // Fire and forget after save? Or await?
      // Plan says "async, non-blocking".
      onAfterSave!(item, isEditMode);
    }
    if (!keepDialogOpen && context.mounted) {
      _closeForm(context);
    }
  }

  void deleteItemFromDb(BuildContext context, BaseItem item,
      {bool keepDialogOpen = false}) async {
    await _repository.deleteItem(item);
    if (onAfterDelete != null) {
      onAfterDelete!(item);
    }
    if (!keepDialogOpen && context.mounted) {
      _closeForm(context);
    }
  }

  void _closeForm(BuildContext context) {
    Navigator.of(context).pop();
  }
}
