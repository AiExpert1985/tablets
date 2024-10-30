import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tablets/generated/l10n.dart';
import 'package:tablets/src/common/providers/text_editing_controllers_provider.dart';
import 'package:tablets/src/common/values/form_dimenssions.dart';
import 'package:tablets/src/features/transactions/controllers/transaction_form_controller.dart';
import 'package:tablets/src/features/transactions/view/forms/item_cell.dart';

class CustomerInvoiceItemTitles extends ConsumerWidget {
  const CustomerInvoiceItemTitles({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formController = ref.read(transactionFormDataProvider.notifier);
    final textEditingNotifier = ref.read(textFieldsControllerProvider.notifier);

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        ItemDataCell(
          isTitle: true,
          isFirst: true,
          width: customerInvoiceSequenceWidth,
          cell: IconButton(
            // alignment: Alignment.topCenter,
            onPressed: () {
              // add controller to the price text field
              textEditingNotifier.addControllerToList(fieldName: 'items');
              // add new empty Map to the list of items property in formData, which will be
              // used to generate a row of fields, these fields will add data to the empty Map
              formController.updateSubProperties(property: 'items', subProperties: {});
            },
            icon: const Icon(Icons.add, color: Colors.green),
          ),
        ),
        ItemDataCell(
            isTitle: true, width: customerInvoiceNameWidth, cell: Text(S.of(context).item_name)),
        ItemDataCell(
            isTitle: true, width: customerInvoicePriceWidth, cell: Text(S.of(context).item_price)),
        ItemDataCell(
            isTitle: true,
            width: customerInvoiceSoldQuantityWidth,
            cell: Text(S.of(context).item_sold_quantity)),
        ItemDataCell(
            isTitle: true,
            width: customerInvoiceGiftQantityWidth,
            cell: Text(S.of(context).item_gifts_quantity)),
        ItemDataCell(
            isTitle: true,
            isLast: true,
            width: customerInvoiceSoldTotalAmountWidth,
            cell: Text(S.of(context).item_total_price)),
      ],
    );
  }
}

// I made a design decision to make the width variable based on the size of the container
const double customerInvoiceSequenceWidth = customerInvoiceFormWidth * 0.055;
const double customerInvoiceNameWidth = customerInvoiceFormWidth * 0.345;
const double customerInvoicePriceWidth = customerInvoiceFormWidth * 0.16;
const double customerInvoiceSoldQuantityWidth = customerInvoiceFormWidth * 0.1;
const double customerInvoiceGiftQantityWidth = customerInvoiceFormWidth * 0.1;
const double customerInvoiceSoldTotalAmountWidth = customerInvoiceFormWidth * 0.17;
