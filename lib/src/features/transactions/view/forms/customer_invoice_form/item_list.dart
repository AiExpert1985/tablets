import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tablets/src/features/products/repository/product_repository_provider.dart';
import 'package:tablets/src/features/transactions/controllers/transaction_form_controller.dart';
import 'package:tablets/src/features/transactions/view/forms/customer_invoice_form/item_data_row.dart';
import 'package:tablets/src/features/transactions/view/forms/customer_invoice_form/item_titles_row.dart';

class CustomerInvoiceItemList extends ConsumerWidget {
  const CustomerInvoiceItemList({super.key});

  List<Widget> createItemWidgets(formController, repository) {
    List<Widget> rows = [];
    final Map<String, dynamic> formData = formController.data;
    if (!formData.containsKey('items')) return rows;
    for (var i = 0; i < formController.data['items'].length; i++) {
      rows.add(
        CustomerInvoiceItemDataRow(
            sequence: i,
            dbListFetchFn: repository.fetchItemListAsMaps,
            formData: formController.data,
            onChangedFn: formController.update),
      );
    }
    return rows;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(transactionFormDataProvider);
    final formController = ref.read(transactionFormDataProvider.notifier);
    final repository = ref.read(productRepositoryProvider);
    final itemWidgets = createItemWidgets(formController, repository);
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
