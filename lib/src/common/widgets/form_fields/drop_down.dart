import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:tablets/generated/l10n.dart';
import 'package:tablets/src/common/functions/form_validation.dart';
import 'package:tablets/src/common/functions/utils.dart' as utils;

class DropDownListFormField extends StatelessWidget {
  const DropDownListFormField(
      {this.initialValue,
      required this.onChangedFn,
      this.label,
      required this.name,
      required this.itemList,
      this.isRequired = true,
      this.hideBorders = false,
      super.key});
  final String? initialValue;
  final String name;
  final List<String> itemList;
  final String? label;
  final void Function(String?) onChangedFn;
  final bool hideBorders; // hide borders in decoration, used if the field in sub list
  final bool isRequired; // if isRequired = false, then the field will not be validated

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: FormBuilderDropdown(
          initialValue: initialValue,
          decoration: hideBorders
              ? utils.formFieldDecoration(label: label, hideBorders: true)
              : utils.formFieldDecoration(label: label),
          validator: isRequired
              ? (value) => validateStringField(
                    fieldValue: value.toString(),
                    errorMessage: S.of(context).input_validation_error_message_for_strings,
                  )
              : null,
          onChanged: (value) {
            if (value == null) return;
            onChangedFn(value);
          },
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
