import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:tablets/generated/l10n.dart';
import 'package:tablets/src/common/values/constants.dart';
import 'package:tablets/src/common/providers/image_picker_provider.dart';
import 'package:tablets/src/features/products/controllers/product_drawer_provider.dart';
import 'package:tablets/src/features/transactions/controllers/transaction_form_controller.dart';
import 'package:tablets/src/features/transactions/view/transaction_form.dart';

class TransactionsFloatingButtons extends ConsumerWidget {
  const TransactionsFloatingButtons({super.key});

  void showAddInvoiceForm(BuildContext context, WidgetRef ref, {String? formType}) {
    final imagePicker = ref.read(imagePickerProvider.notifier);
    imagePicker.initialize();
    final formController = ref.read(transactionFormDataProvider.notifier);
    formController.initialize();
    // give defaults values for drop down lists based on codition represents the transaction type
    if (formType != null && formType == TransactionTypes.customerInvoice.name) {
      formController.update({
        'currency': S.of(context).transaction_payment_Dinar,
        'paymentType': S.of(context).transaction_payment_credit,
        'discount': 0,
        'name': formType,
        'date': DateTime.now(),
      });
    }
    showDialog(
      context: context,
      builder: (BuildContext ctx) => const TransactionForm(),
    ).whenComplete(imagePicker.close);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final drawerController = ref.watch(productsDrawerControllerProvider);
    const iconsColor = Color.fromARGB(255, 126, 106, 211);
    return SpeedDial(
      direction: SpeedDialDirection.up,
      switchLabelPosition: false,
      animatedIcon: AnimatedIcons.menu_close,
      spaceBetweenChildren: 10,
      animatedIconTheme: const IconThemeData(size: 28.0),
      visible: true,
      curve: Curves.bounceInOut,
      children: [
        SpeedDialChild(
          child: const Icon(Icons.pie_chart, color: Colors.white),
          backgroundColor: iconsColor,
          onTap: () => drawerController.showReports(context),
        ),
        SpeedDialChild(
          child: const Icon(Icons.search, color: Colors.white),
          backgroundColor: iconsColor,
          onTap: () => drawerController.showSearchForm(context),
        ),
        SpeedDialChild(
          child: const Icon(Icons.add, color: Colors.white),
          backgroundColor: iconsColor,
          onTap: () =>
              showAddInvoiceForm(context, ref, formType: TransactionTypes.customerInvoice.name),
        ),
      ],
    );
  }
}
