import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tablets/generated/l10n.dart';
import 'package:tablets/src/common/values/constants.dart';
import 'package:tablets/src/features/transactions/view/forms/common_utils/transaction_show_form_utils.dart';
import 'package:tablets/src/common/providers/image_picker_provider.dart';
import 'package:tablets/src/common/providers/text_editing_controllers_provider.dart';
import 'package:tablets/src/features/transactions/controllers/transaction_form_controller.dart';

class TransactionTypeSelection extends ConsumerWidget {
  const TransactionTypeSelection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Define the form types and corresponding names
    final List<String> items = [
      S.of(context).transaction_type_customer_invoice,
      S.of(context).transaction_type_vender_invoice,
      S.of(context).transaction_type_customer_receipt,
      S.of(context).transaction_type_vendor_receipt,
      S.of(context).transaction_type_expenditures,
      S.of(context).transaction_type_gifts,
      S.of(context).transaction_type_customer_return,
      S.of(context).transaction_type_vender_return,
    ];

    final List<String> formTypes = [
      TransactionType.customerInvoice.name,
      TransactionType.venderInvoice.name,
      TransactionType.customerReceipt.name,
      TransactionType.vendorReceipt.name,
      TransactionType.expenditures.name,
      TransactionType.gifts.name,
      TransactionType.customerReturn.name,
      TransactionType.venderReturn.name,
    ];

    final textEditingNotifier = ref.read(textFieldsControllerProvider.notifier);
    final imagePickerNotifier = ref.read(imagePickerProvider.notifier);
    final formDataNotifier = ref.read(transactionFormDataProvider.notifier);

    return AlertDialog(
      alignment: Alignment.center,
      scrollable: true,
      content: Container(
        padding: const EdgeInsets.all(25),
        width: 750,
        height: 750,
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, // Number of columns
            childAspectRatio: 2, // Aspect ratio of each card
          ),
          itemCount: items.length,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                Navigator.pop(context);
                TransactionShowFormUtils.showForm(
                  context,
                  imagePickerNotifier,
                  formDataNotifier,
                  textEditingNotifier,
                  formType: formTypes[index], // Use the corresponding form type
                );
              },
              child: Card(
                elevation: 4,
                margin: const EdgeInsets.all(16),
                child: SizedBox(
                  height: 40, // Reduced height for the card
                  child: Center(
                    child: Text(
                      items[index], // Use the corresponding name
                      style: const TextStyle(fontSize: 18),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
