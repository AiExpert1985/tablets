import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tablets/generated/l10n.dart';
import 'package:tablets/src/common/providers/background_color.dart';
import 'package:tablets/src/common/values/constants.dart';
import 'package:tablets/src/features/transactions/repository/transaction_repository_provider.dart';
import 'package:tablets/src/features/transactions/view/transaction_show_form_utils.dart';
import 'package:tablets/src/common/providers/image_picker_provider.dart';
import 'package:tablets/src/common/providers/text_editing_controllers_provider.dart';
import 'package:tablets/src/features/transactions/controllers/transaction_form_controller.dart';

class TransactionTypeSelection extends ConsumerWidget {
  const TransactionTypeSelection(this.groupName, {super.key});
  final String groupName;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final transactionsProvider = ref.read(transactionRepositoryProvider);
    final group = {
      'customer': {
        'names': [
          S.of(context).transaction_type_customer_invoice,
          S.of(context).transaction_type_customer_receipt,
          S.of(context).transaction_type_customer_return,
          S.of(context).transaction_type_gifts,
        ],
        'formTypes': [
          TransactionType.customerInvoice.name,
          TransactionType.customerReceipt.name,
          TransactionType.customerReturn.name,
          TransactionType.gifts.name,
        ]
      },
      'vendor': {
        'names': [
          S.of(context).transaction_type_vender_invoice,
          S.of(context).transaction_type_vendor_receipt,
          S.of(context).transaction_type_vender_return,
        ],
        'formTypes': [
          TransactionType.vendorInvoice.name,
          TransactionType.vendorReceipt.name,
          TransactionType.vendorReturn.name,
        ]
      },
      'internal': {
        'names': [
          S.of(context).transaction_type_expenditures,
          S.of(context).transaction_type_damaged_items,
        ],
        'formTypes': [
          TransactionType.expenditures.name,
          TransactionType.damagedItems.name,
        ]
      },
    };
    // Define the form types and corresponding names
    final List<String> names = group[groupName]!['names']!;

    final List<String> formTypes = group[groupName]!['formTypes']!;

    final textEditingNotifier = ref.read(textFieldsControllerProvider.notifier);
    final imagePickerNotifier = ref.read(imagePickerProvider.notifier);
    final formDataNotifier = ref.read(transactionFormDataProvider.notifier);
    final backgroundColorNofifier = ref.read(backgroundColorProvider.notifier);

    return AlertDialog(
      alignment: Alignment.center,
      scrollable: true,
      content: Container(
        padding: const EdgeInsets.all(25),
        width: 300,
        height: names.length * 185,
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 1, // Number of columns
            childAspectRatio: 1.5, // Aspect ratio of each card
          ),
          itemCount: names.length,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () async {
                Navigator.of(context).pop();
                final transactions = await transactionsProvider.fetchItemListAsMaps();
                if (context.mounted) {
                  TransactionShowFormUtils.showForm(
                    context,
                    imagePickerNotifier,
                    formDataNotifier,
                    textEditingNotifier,
                    transactions,
                    backgroundColorNofifier,
                    formType: formTypes[index], // Use the corresponding form type
                  );
                }
              },
              child: Card(
                elevation: 4,
                margin: const EdgeInsets.all(16),
                child: SizedBox(
                  height: 40, // Reduced height for the card
                  child: Center(
                    child: Text(
                      names[index], // Use the corresponding name
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
