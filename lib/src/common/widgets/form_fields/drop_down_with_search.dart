import 'package:cached_network_image/cached_network_image.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tablets/generated/l10n.dart';
import 'package:tablets/src/common/functions/debug_print.dart';
import 'package:tablets/src/common/functions/utils.dart' as utils;
import 'package:tablets/src/common/functions/form_validation.dart' as validation;

/// I used Stateful widget because it is the the best way I found to make the initial value visible
/// after it is being fetched from DB, I didn't want to use riverpod providers because it lead to
/// unnecessary complications
/// note that, each item displayed must have property named 'name' because this property is used to
/// fetch items from database, and also to be displayed in the drop down list
class DropDownWithSearchFormField extends ConsumerWidget {
  const DropDownWithSearchFormField(
      {required this.formData,
      required this.onChangedFn, //used to store selected item in formData
      this.relatedProperties,
      this.label,
      // the name of property in formData Map<String, dynamic>
      required this.property,
      this.relatedSubProperties,
      this.subProperty,
      required this.dbListFetchFn,
      this.isRequired = true,
      this.hideBorders = false,
      this.subPropertyIndex, // the sequence of item in the list of main form property,
      // a map for all properties of formData, and the corresponding properties in the targeted item
      // example {'price':'sellWholePrice'} means that the value of sellWholePrice property
      // in Product will be stored under the 'price' property in formData
      // required this.targetProperties,
      this.updateReletedFieldFn,
      super.key});
  // formDataPropertyName: the key of formData that we want to
  //used selected item to add/update its value, item formData[formDataPropertyName]
  final String property;
  // selectedItemPropertyName: the name of the property of the selected item which is will be stored
  // in formData[formDataPropertyName] or used to fetch initial value from db.
  final String? label; // label shown on the cell
  final Map<String, dynamic> formData; // used to fetch initial data & to store selected item

  final void Function(Map<String, dynamic>) onChangedFn;
  final Future<List<Map<String, dynamic>>> Function({String? filterKey, String? filterValue}) dbListFetchFn;
  final bool hideBorders; // hide borders in decoration, used if the field in sub list
  final bool isRequired; // if isRequired = false, then the field will not be validated
  final String? subProperty;
  final int? subPropertyIndex;
  final Map<String, String>? relatedSubProperties;
  final Map<String, String>? relatedProperties;
  // this is the only way I found to use dropdwon field to update the TextEditingController of adjacent text field
  // the idea is to pass a function and it runs, it is not optimal, but it is the best I found so far
  final VoidCallback? updateReletedFieldFn;

  Map<String, dynamic>? setInitialValue() {
    if (formData[property] == null) return null;

    if (subPropertyIndex == null) {
      return {'name': formData[property]};
    }
    if (formData[property][subPropertyIndex]['name'] != null) {
      return formData[property][subPropertyIndex];
    }
    return null;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final initialValue = setInitialValue();
    return Expanded(
      child: DropdownSearch<Map<String, dynamic>>(
          mode: Mode.form,
          decoratorProps: DropDownDecoratorProps(
            textAlign: TextAlign.center,
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
                      label!,
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
          validator: (item) => isRequired
              ? validation.validateStringField(
                  fieldValue: item?['name'],
                  errorMessage: S.of(context).input_validation_error_message_for_strings,
                )
              : null,
          itemAsString: (item) {
            return item['name'];
          },
          onChanged: (item) {
            if (item == null) return;
            if (subPropertyIndex == null) {
              formData[property] = item['name'];
              relatedProperties?.forEach((formKey, itemKey) {
                formData[formKey] = item[itemKey];
              });
              onChangedFn(formData);
              return;
            }
            formData[property][subPropertyIndex][subProperty] = item['name'];
            relatedSubProperties?.forEach((formKey, itemKey) {
              formData[property][subPropertyIndex][formKey] = item[itemKey];
            });
            if (updateReletedFieldFn != null) {
              updateReletedFieldFn!();
            }

            onChangedFn(formData);
          }),
    );
  }
}

Widget popUpItem(BuildContext context, Map<String, dynamic> item, bool isDisabled, bool isSelected) {
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
          foregroundImage: CachedNetworkImageProvider(item['imageUrls'][item['imageUrls'].length - 1]),
        ),
      ),
    ),
  );
}
