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
      {required this.title,
      required this.dbItemFetchFn,
      required this.dbListFetchFn,
      required this.onSaveFn,
      required this.formData,
      super.key});
  final String title;
  final Map<String, dynamic> formData;
  final void Function({required String key, required dynamic value}) onSaveFn;
  final Future<Map<String, dynamic>> Function({String? filterKey, String? filterValue}) dbItemFetchFn;
  final Future<List<Map<String, dynamic>>> Function({String? filterKey, String? filterValue}) dbListFetchFn;

  @override
  State<DropDownWithSearchFormField> createState() => _DropDownWithSearchFormFieldState();
}

class _DropDownWithSearchFormFieldState extends State<DropDownWithSearchFormField> {
  final Map<String, dynamic> initialValue = {};

  void setInitialValue(formData) async {
    if (formData['category'] != null) {
      Map<String, dynamic> categoryMap =
          await widget.dbItemFetchFn(filterKey: 'dbKey', filterValue: formData['category']);
      if (mounted) {
        setState(() {
          initialValue.addAll(categoryMap); // Store the fetched data
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    setInitialValue(widget.formData);
    return Expanded(
      child: DropdownSearch<Map<String, dynamic>>(
          mode: Mode.form,
          decoratorProps: DropDownDecoratorProps(
            decoration: utils.formFieldDecoration(label: S.of(context).category),
          ),
          selectedItem: initialValue.keys.isNotEmpty && initialValue['name'] != null ? initialValue : null,
          items: (filter, t) => widget.dbListFetchFn(filterKey: 'name', filterValue: filter),
          compareFn: (i, s) => i == s,
          popupProps: PopupProps.dialog(
            title: Padding(
              padding: const EdgeInsets.all(12),
              child: Text(
                widget.title,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
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
            widget.onSaveFn(key: 'category', value: item?['dbKey']);
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
