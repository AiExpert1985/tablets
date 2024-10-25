import 'package:cached_network_image/cached_network_image.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:tablets/generated/l10n.dart';
import 'package:tablets/src/common/functions/utils.dart' as utils;
import 'package:tablets/src/common/functions/form_validation.dart' as validation;

/// I used Stateful widget because it is the the best way I found to make the initial value visible
/// after it is being fetched from DB, I didn't want to use riverpod providers because it lead to
/// unnecessary complications
class DropDownWithSearchFormField extends StatefulWidget {
  const DropDownWithSearchFormField(
      {required this.formDataPropertyName,
      required this.dbItemFetchFn,
      required this.dbListFetchFn,
      required this.onSaveFn,
      required this.formData,
      this.selectedItemPropertyName = 'dbKey',
      this.label,
      super.key});
  // formDataPropertyName: the key of formData that we want to
  //used selected item to add/update its value, item formData[formDataPropertyName]
  final String formDataPropertyName;
  // selectedItemPropertyName: the name of the property of the selected item which is will be stored
  // in formData[formDataPropertyName] or used to fetch initial value from db.
  // if no value provided, then dbKey will be used because all items have dbKey property
  final String selectedItemPropertyName;
  final String? label; // label shown on the cell
  final Map<String, dynamic> formData; // used to fetch initial data & to store selected item
  // onSaveFn: used to store selected item in formData
  final void Function({required String key, required dynamic value}) onSaveFn;
  // dbItemFetchFn: fetch initial value from db
  final Future<Map<String, dynamic>> Function({String? filterKey, String? filterValue})
      dbItemFetchFn;
  // dbItemFetchFn: fetch selection list of value form db.
  final Future<List<Map<String, dynamic>>> Function({String? filterKey, String? filterValue})
      dbListFetchFn;

  @override
  State<DropDownWithSearchFormField> createState() => _DropDownWithSearchFormFieldState();
}

class _DropDownWithSearchFormFieldState extends State<DropDownWithSearchFormField> {
  final Map<String, dynamic> initialValue = {};

  void setInitialValue(formData, nameKey, selectedItemPropertyName) async {
    if (formData[nameKey] != null) {
      Map<String, dynamic> itemMap = await widget.dbItemFetchFn(
          filterKey: selectedItemPropertyName, filterValue: formData[nameKey]);
      if (mounted) {
        setState(() {
          initialValue.addAll(itemMap); // Store the fetched data
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final formDataPropertyName = widget.formDataPropertyName;
    final label = widget.label;
    final selectedItemPropertyName = widget.selectedItemPropertyName;
    final formData = widget.formData;
    setInitialValue(formData, formDataPropertyName, selectedItemPropertyName);
    return Expanded(
      child: DropdownSearch<Map<String, dynamic>>(
          mode: Mode.form,
          decoratorProps: DropDownDecoratorProps(
            decoration: utils.formFieldDecoration(label: label),
          ),
          selectedItem:
              initialValue.keys.isNotEmpty && initialValue['name'] != null ? initialValue : null,
          items: (filter, t) => widget.dbListFetchFn(filterKey: 'name', filterValue: filter),
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
          onSaved: (item) {
            widget.onSaveFn(key: formDataPropertyName, value: item?[selectedItemPropertyName]);
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
