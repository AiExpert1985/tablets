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

  static const String itemsKey = 'items';

  List<Widget> _buildItemRows(
      ItemFormData formDataNotifier, Map<String, dynamic> textEditingControllers) {
    if (!formDataNotifier.data.containsKey(itemsKey) || formDataNotifier.data[itemsKey] is! List) {
      return const [Center(child: Text('No items added yet'))];
    }
    final items = formDataNotifier.data[itemsKey] as List<Map<String, dynamic>>;
    return List.generate(items.length, (index) {
      if (!textEditingControllers.containsKey(itemsKey) ||
          textEditingControllers[itemsKey]!.length <= index) {
        errorPrint('Warning: Missing TextEditingController for item index: $index');
        return const SizedBox.shrink(); // Return an empty widget if the controller is missing
      }
      return CustomerInvoiceItemDataRow(index);
    });
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(transactionFormDataProvider);
    final formDataNotifier = ref.read(transactionFormDataProvider.notifier);
    final textEditingNotifier = ref.read(textFieldsControllerProvider.notifier);

    return Container(
      height: 350,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black38, width: 1.0),
        borderRadius: BorderRadius.circular(8.0),
      ),
      padding: const EdgeInsets.all(12),
      child: Column(
        children: [
          Stack(children: [
            const CustomerInvoiceItemTitles(),
            Positioned(
              top: 0,
              right: 0,
              child: IconButton(
                onPressed: () {
                  textEditingNotifier.addControllerToList(itemsKey);
                  formDataNotifier.updateSubProperties(itemsKey, {});
                },
                icon: const Icon(Icons.add, color: Colors.green),
              ),
            ),
          ]),
          ..._buildItemRows(formDataNotifier, textEditingNotifier.data),
        ],
      ),
    );
  }
}
