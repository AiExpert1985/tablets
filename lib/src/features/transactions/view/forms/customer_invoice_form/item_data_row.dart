import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tablets/src/common/values/constants.dart' as constants;
import 'package:tablets/src/common/values/form_dimenssions.dart';
import 'package:tablets/src/common/widgets/form_fields/drop_down_with_search.dart';
import 'package:tablets/src/features/transactions/view/forms/item_cell.dart';
import 'package:tablets/src/features/transactions/view/forms/text_input_field.dart';

class CustomerInvoiceItemDataRow extends ConsumerWidget {
  const CustomerInvoiceItemDataRow(
      {required this.sequence,
      required this.dbListFetchFn,
      required this.onChangedFn,
      required this.formData,
      required this.priceTextEditingController,
      super.key});
  final int sequence;
  final Map<String, dynamic> formData;
  final void Function(Map<String, dynamic>) onChangedFn;
  final Future<List<Map<String, dynamic>>> Function({String? filterKey, String? filterValue})
      dbListFetchFn;
  final TextEditingController priceTextEditingController;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        ItemDataCell(isFirst: true, width: sequenceWidth, cell: Text((sequence + 1).toString())),
        ItemDataCell(
            width: nameWidth,
            cell: DropDownWithSearchFormField(
              formData: formData,
              property: 'items',
              subProperty: 'name',
              subPropertyIndex: sequence,
              relatedSubProperties: const {'price': 'sellWholePrice', 'weight': 'packageWeight'},
              dbListFetchFn: dbListFetchFn,
              onChangedFn: onChangedFn,
              hideBorders: true,
            )),
        ItemDataCell(
          width: priceWidth,
          cell: TransactionFormInputField(
            controller: priceTextEditingController,
            isRequired: false,
            subProperty: 'price',
            subPropertyIndex: sequence,
            hideBorders: true,
            dataType: constants.FieldDataTypes.double,
            property: 'items',
          ),
        ),
        const ItemDataCell(width: soldQuantityWidth, cell: Text('TempText')),
        const ItemDataCell(width: giftQantityWidth, cell: Text('tempText')),
        const ItemDataCell(isLast: true, width: soldTotalPriceWidth, cell: Text('tempText')),
      ],
    );
  }
}

// I made a design decision to make the width variable based on the size of the container
const double titleHeight = customerInvoiceFormHeight * 0.065;
const double itemHeight = customerInvoiceFormHeight * 0.05;
const double sequenceWidth = customerInvoiceFormWidth * 0.055;
const double nameWidth = customerInvoiceFormWidth * 0.345;
const double priceWidth = customerInvoiceFormWidth * 0.16;
const double soldQuantityWidth = customerInvoiceFormWidth * 0.1;
const double giftQantityWidth = customerInvoiceFormWidth * 0.1;
const double soldTotalPriceWidth = customerInvoiceFormWidth * 0.17;
