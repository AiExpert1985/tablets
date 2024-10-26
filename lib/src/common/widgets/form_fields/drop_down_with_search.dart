import 'package:cached_network_image/cached_network_image.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:tablets/generated/l10n.dart';
import 'package:tablets/src/common/functions/utils.dart' as utils;
import 'package:tablets/src/common/functions/form_validation.dart' as validation;

/// I used Stateful widget because it is the the best way I found to make the initial value visible
/// after it is being fetched from DB, I didn't want to use riverpod providers because it lead to
/// unnecessary complications
/// note that, each item displayed must have property named 'name' because this property is used to
/// fetch items from database, and also to be displayed in the drop down list
class DropDownWithSearchFormField extends StatefulWidget {
  const DropDownWithSearchFormField(
      {required this.formData,
      required this.onChangedFn,
      this.label,
      required this.fieldName,
      // required this.dbItemFetchFn,
      required this.dbListFetchFn,
      this.isRequired = true,
      this.hideBorders = false,
      this.subItemSequence, // the sequence of item in the list of main form property,
      super.key});
  // formDataPropertyName: the key of formData that we want to
  //used selected item to add/update its value, item formData[formDataPropertyName]
  final String fieldName;
  // selectedItemPropertyName: the name of the property of the selected item which is will be stored
  // in formData[formDataPropertyName] or used to fetch initial value from db.
  final String? label; // label shown on the cell
  final Map<String, dynamic> formData; // used to fetch initial data & to store selected item
  // onSaveFn: used to store selected item in formData
  final void Function(Map<String, dynamic>) onChangedFn;
  final Future<List<Map<String, dynamic>>> Function({String? filterKey, String? filterValue})
      dbListFetchFn;
  final bool hideBorders; // hide borders in decoration, used if the field in sub list
  final bool isRequired; // if isRequired = false, then the field will not be validated
  final int? subItemSequence;

  @override
  State<DropDownWithSearchFormField> createState() => _DropDownWithSearchFormFieldState();
}

class _DropDownWithSearchFormFieldState extends State<DropDownWithSearchFormField> {
  Map<String, dynamic>? setInitialValue(formData, fieldName, subItemSequence) {
    Map<String, dynamic>? initialMap;
    if (formData[fieldName] != null) {
      if (subItemSequence != null) {
        if (formData[fieldName][subItemSequence]['name'] != null) {
          // here I made assumption that if we want to add anew sub item, then we should initial
          // an empty Map, so there is alway a Map in the subItemSequence

          initialMap = formData[fieldName][subItemSequence];
        } else {
          initialMap = null;
        }
      } else {
        initialMap = formData[fieldName];
      }
    } else {
      initialMap = null;
    }
    return initialMap;
  }

  @override
  Widget build(BuildContext context) {
    final onChangedFn = widget.onChangedFn;
    final dbListFetchFn = widget.dbListFetchFn;
    final label = widget.label;
    final formData = widget.formData;
    final hideBorders = widget.hideBorders;
    final fieldName = widget.fieldName;
    final subItemSequence = widget.subItemSequence;
    final initialValue = setInitialValue(formData, fieldName, subItemSequence);

    return Expanded(
      child: DropdownSearch<Map<String, dynamic>>(
          mode: Mode.form,
          decoratorProps: DropDownDecoratorProps(
            decoration: hideBorders
                ? utils.formFieldDecoration(label: label, hideBorders: true)
                : utils.formFieldDecoration(label: label),
          ),
          selectedItem: initialValue,
          items: (filter, t) => dbListFetchFn(filterKey: 'name', filterValue: filter),
          compareFn: (i, s) => i == s,
          popupProps: PopupProps.dialog(
            title: label != null
                ? Padding(
                    padding: const EdgeInsets.all(12),
                    child: Text(
                      label,
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  )
                : null,
            dialogProps: DialogProps(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            fit: FlexFit.tight,
            showSearchBox: true,
            itemBuilder: popUpItem,
            searchFieldProps: TextFieldProps(
              autofocus: true,
              textAlign: TextAlign.center,
              decoration: utils.formFieldDecoration(),
            ),
          ),
          validator: (item) => validation.validateStringField(
                fieldValue: item?['name'],
                errorMessage: S.of(context).input_validation_error_message_for_strings,
              ),
          itemAsString: (item) => item['name'],
          onChanged: (item) {
            if (item == null) return;
            if (subItemSequence == null) {
              formData[fieldName] = item;
            } else {
              formData[fieldName][subItemSequence] = item;
            }
            onChangedFn(formData);
          }),
    );
  }
}

Widget popUpItem(
    BuildContext context, Map<String, dynamic> item, bool isDisabled, bool isSelected) {
  return Container(
    margin: const EdgeInsets.symmetric(horizontal: 8),
    decoration: !isSelected
        ? null
        : BoxDecoration(
            border: Border.all(color: Theme.of(context).primaryColor),
            borderRadius: BorderRadius.circular(5),
            color: Colors.white,
          ),
    child: Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 15),
      child: ListTile(
        selected: isSelected,
        title: Text(item['name']),
        // subtitle: Text(item.code.toString()),
        leading: CircleAvatar(
          // radius: 70,
          backgroundColor: Colors.white,
          foregroundImage:
              CachedNetworkImageProvider(item['imageUrls'][item['imageUrls'].length - 1]),
        ),
      ),
    ),
  );
}
