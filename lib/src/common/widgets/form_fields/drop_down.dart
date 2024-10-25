import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:tablets/generated/l10n.dart';
import 'package:tablets/src/common/functions/form_validation.dart';
import 'package:tablets/src/common/functions/utils.dart' as utils;

class DropDownListFormField extends StatelessWidget {
  const DropDownListFormField(
      {required this.onSaveFn,
      required this.formData,
      required this.label,
      required this.itemList,
      required this.name,
      super.key});
  final String name;
  final List<String> itemList;
  final String label;
  final void Function({required String key, required dynamic value}) onSaveFn;
  final Map<String, dynamic> formData;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: FormBuilderDropdown(
          initialValue: formData[name],
          decoration: utils.formFieldDecoration(label: label),
          validator: (value) => validateStringField(
                fieldValue: value.toString(),
                errorMessage: S.of(context).input_validation_error_message_for_strings,
              ),
          onSaved: (newValue) => onSaveFn(key: name, value: newValue!.toString()),
          name: name,
          items: itemList
              .map((item) => DropdownMenuItem(
                    alignment: AlignmentDirectional.center,
                    value: item,
                    child: Text(item),
                  ))
              .toList()),
    );
  }
}
