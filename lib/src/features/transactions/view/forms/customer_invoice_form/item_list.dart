import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tablets/src/common/classes/item_form_data.dart';
import 'package:tablets/src/common/functions/debug_print.dart';
import 'package:tablets/src/common/providers/text_editing_controllers_provider.dart';
import 'package:tablets/src/features/transactions/controllers/transaction_form_controller.dart';
import 'package:tablets/src/features/transactions/view/forms/customer_invoice_form/item_data_row.dart';
import 'package:tablets/src/features/transactions/view/forms/customer_invoice_form/item_titles_row.dart';

class CustomerInvoiceItemList extends ConsumerWidget {
  const CustomerInvoiceItemList({super.key});

  List<Widget> createItemWidgets(ItemFormData formDataNotifier, Map<String, dynamic> textEditingControllers) {
    List<Widget> rows = [];
    if (!formDataNotifier.data.containsKey('items') || formDataNotifier.data['items'] is! List) {
      return rows;
    }
    final items = formDataNotifier.data['items'] as List<Map<String, dynamic>>;
    for (var i = 0; i < items.length; i++) {
      if (!textEditingControllers.containsKey('items') || textEditingControllers['items']!.length <= i) {
        errorPrint(message: 'Warning: Missing TextEditingController for item index: $i');
        continue;
      }
      rows.add(CustomerInvoiceItemDataRow(index: i));
    }
    return rows;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(transactionFormDataProvider);
    final formDataNotifier = ref.read(transactionFormDataProvider.notifier);
    final textFieldsControllers = ref.read(textFieldsControllerProvider);
    final itemWidgets = createItemWidgets(formDataNotifier, textFieldsControllers);
    return Container(
      height: 350,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black38, width: 1.0),
        borderRadius: BorderRadius.circular(8.0),
      ),
      padding: const EdgeInsets.all(12),
      child: Column(
        children: [
          const CustomerInvoiceItemTitles(),
          ...itemWidgets,
        ],
      ),
    );
  }
}
