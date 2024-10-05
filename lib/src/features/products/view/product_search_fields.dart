import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tablets/generated/l10n.dart';
import 'package:tablets/src/common_widgets/form/field_box_decoration.dart';
import 'package:tablets/src/constants/constants.dart';
import 'package:tablets/src/features/products/controller/product_search_provider.dart';
import 'package:tablets/src/utils/utils.dart' as utils;

enum FieldDataTypes { int, double, string }

class ProductSearchForm extends ConsumerWidget {
  const ProductSearchForm({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productSearch = ref.watch(productsSearchProvider);
    return FormBuilder(
        child: Padding(
      padding: const EdgeInsets.all(30.0),
      child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            GeneralSearchField(
              dataType: FieldDataTypes.int.name,
              name: 'code',
              displayedTitle: S.of(context).product_code,
              productSearch: productSearch,
            ),
            FormGap.vertical,
            GeneralSearchField(
              dataType: FieldDataTypes.string.name,
              name: 'name',
              displayedTitle: S.of(context).product_name,
              productSearch: productSearch,
            ),
            FormGap.vertical,
            GeneralSearchField(
              dataType: FieldDataTypes.double.name,
              name: 'commission',
              displayedTitle: S.of(context).product_salesman_comission,
              productSearch: productSearch,
            ),
            Offstage(
              offstage: !productSearch.isSearchOn,
              child: IconButton(
                onPressed: () => productSearch.resetFieldValues(),
                icon: const Icon(Icons.search_off),
              ),
            )
          ]),
    ));
  }
}

class GeneralSearchField extends StatelessWidget {
  const GeneralSearchField({
    required this.dataType,
    required this.name,
    required this.displayedTitle,
    required this.productSearch,
    super.key,
  });

  final String dataType;
  final String name;
  final String displayedTitle;
  final ProductSearch productSearch;

  @override
  Widget build(BuildContext context) {
    return FormBuilderTextField(
        name: name,
        decoration: formFieldDecoration(displayedTitle),
        onChanged: (value) =>
            productSearch.updateValue(key: name, value: value, dataType: dataType));
  }
}
