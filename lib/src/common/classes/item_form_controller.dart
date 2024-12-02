import 'package:flutter/material.dart';
import 'package:tablets/src/common/classes/db_repository.dart';
import 'package:tablets/src/common/interfaces/base_item.dart';

class ItemFormController {
  ItemFormController(
    this._repository,
  );
  final DbRepository _repository;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  bool validateData() => formKey.currentState!.validate();

  void submitData() => formKey.currentState!.save();

  void saveItemToDb(BuildContext context, BaseItem item, bool isEditMode) async {
    isEditMode ? _repository.updateItem(item) : _repository.addItem(item);
    _closeForm(context);

    //// below code was used before I update the add & updates methods for using offline firestore
    //// and not waiting in the case of offline, where functions would not return the status
    // final success =
    //     isEditMode ? await _repository.updateItem(item) : await _repository.addItem(item);
    // if (!context.mounted) return; // just for protection in async functions
    // success
    //     ? success(context, S.of(context).db_success_saving_doc)
    //     : failure(context, S.of(context).db_error_saving_doc);
    // _closeForm(context);
  }

  void deleteItemFromDb(BuildContext context, BaseItem item) async {
    _repository.deleteItem(item);
    _closeForm(context);

    //// below code was used before I update the add & updates methods for using offline firestore
    //// and not waiting in the case of offline, where functions would not return the status
    // final successful = await _repository.deleteItem(item);
    // if (!context.mounted) return;
    // successful
    //     ? success(context, S.of(context).db_success_deleting_doc)
    //     : failure(context, S.of(context).db_error_deleting_doc);
    // _closeForm(context);
  }

  void _closeForm(BuildContext context) {
    Navigator.of(context).pop();
  }
}
