import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:tablets/generated/l10n.dart';
import 'package:tablets/src/common_widgets/form/field_box_decoration.dart';
import 'package:tablets/src/constants/constants.dart';
import 'package:tablets/src/utils/utils.dart' as utils;

class ProductSearchForm extends StatelessWidget {
  const ProductSearchForm({super.key});

  @override
  Widget build(BuildContext context) {
    return FormBuilder(
        child: Padding(
      padding: const EdgeInsets.all(30.0),
      child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            IntSearchField(name: 'code', displayedTitle: S.of(context).product_code),
            FormGap.vertical,
            TextSearchField(name: 'name', displayedTitle: S.of(context).product_name),
          ]),
    ));
  }
}

class IntSearchField extends StatelessWidget {
  const IntSearchField({
    required this.name,
    required this.displayedTitle,
    super.key,
  });

  final String name;
  final String displayedTitle;

  @override
  Widget build(BuildContext context) {
    return FormBuilderTextField(
      name: name,
      decoration: formFieldDecoration(displayedTitle),
      onChanged: (value) {
        try {
          int.parse(value!);
          utils.CustomDebug.tempPrint(value);
        } catch (e) {
          utils.CustomDebug.tempPrint(
              'value ($value) entered in product search field ($name) is not a integer number');
        }
      },
    );
  }
}

class TextSearchField extends StatelessWidget {
  const TextSearchField({
    required this.name,
    required this.displayedTitle,
    super.key,
  });

  final String name;
  final String displayedTitle;

  @override
  Widget build(BuildContext context) {
    return FormBuilderTextField(
      name: name,
      decoration: formFieldDecoration(displayedTitle),
      onChanged: (value) {
        if (value != null && value.isNotEmpty) {
          utils.CustomDebug.tempPrint(value);
        }
      },
    );
  }
}

class DoubleSearchField extends StatelessWidget {
  const DoubleSearchField({
    required this.name,
    required this.displayedTitle,
    super.key,
  });

  final String name;
  final String displayedTitle;

  @override
  Widget build(BuildContext context) {
    return FormBuilderTextField(
      name: name,
      decoration: formFieldDecoration(displayedTitle),
      onChanged: (value) {
        try {
          double.parse(value!);
          utils.CustomDebug.tempPrint(value);
        } catch (e) {
          utils.CustomDebug.tempPrint(
              'value ($value) entered in product search field ($name) is not a integer number');
        }
      },
    );
  }
}
