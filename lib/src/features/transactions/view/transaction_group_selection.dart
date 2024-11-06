import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tablets/generated/l10n.dart';
import 'package:tablets/src/features/transactions/view/transaction_new_form_dialog.dart';

class TransactionGroupSelection extends ConsumerWidget {
  const TransactionGroupSelection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final List<String> names = [
      S.of(context).customer,
      S.of(context).vendor,
      S.of(context).internal_transaction,
    ];

    final List<String> formTypes = [
      "customer",
      "vendor",
      "internal",
    ];

    return AlertDialog(
      alignment: Alignment.center,
      scrollable: true,
      content: Container(
        padding: const EdgeInsets.all(25),
        width: 800,
        height: 560,
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3, // Number of columns
            childAspectRatio: 1.5, // Aspect ratio of each card
          ),
          itemCount: names.length,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                TransactionTypeSelection(formTypes[index]);
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
