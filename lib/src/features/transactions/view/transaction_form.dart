import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tablets/src/common/functions/debug_print.dart';
import 'package:tablets/src/common/functions/utils.dart' as utils;
import 'package:tablets/src/common/providers/image_picker_provider.dart';
import 'package:tablets/src/common/widgets/dialog_delete_confirmation.dart';
import 'package:tablets/src/common/widgets/form_frame.dart';
import 'package:tablets/src/common/widgets/custom_icons.dart';
import 'package:tablets/src/common/values/form_dimenssions.dart';
import 'package:tablets/src/features/transactions/controllers/transaction_form_controller.dart';
import 'package:tablets/src/features/transactions/model/transaction.dart';
import 'package:tablets/src/features/transactions/view/forms/customer_invoice_form/form.dart';

class TransactionForm extends ConsumerWidget {
  const TransactionForm({this.isEditMode = false, super.key});
  final bool isEditMode;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formController = ref.read(transactionFormControllerProvider);
    final formData = ref.read(transactionFormDataProvider);
    final formDataNotifier = ref.read(transactionFormDataProvider.notifier);
    final formImagesNotifier = ref.read(imagePickerProvider.notifier);
    ref.watch(imagePickerProvider);
    return FormFrame(
      formKey: formController.formKey,
      fields: const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          CustomerInvoiceForm(),
        ],
      ),
      buttons: [
        IconButton(
          onPressed: () {
            tempPrint('before saving');
            tempPrint(formDataNotifier.data);
            tempPrint(formDataNotifier.getFormDataTypes());

            if (!formController.validateData()) return;
            formController.submitData();
            final updateFormData = formDataNotifier.data;
            final imageUrls = formImagesNotifier.saveChanges();
            final transaction = Transaction.fromMap({...updateFormData, 'imageUrls': imageUrls});
            formController.saveItemToDb(context, transaction, isEditMode);
          },
          icon: const SaveIcon(),
        ),
        IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const CancelIcon(),
        ),
        Visibility(
          visible: isEditMode,
          child: IconButton(
              onPressed: () async {
                final message = utils.transactionTypeDbNameToScreenName(context: context, dbName: formData['name']);
                bool? confiramtion = await showDeleteConfirmationDialog(context: context, message: message);
                if (confiramtion != null) {
                  final updateFormData = formDataNotifier.data;
                  final imageUrls = formImagesNotifier.saveChanges();
                  final transaction = Transaction.fromMap({...updateFormData, 'imageUrls': imageUrls});
                  // ignore: use_build_context_synchronously
                  formController.deleteItemFromDb(context, transaction);
                }
              },
              icon: const DeleteIcon()),
        )
      ],
      width: customerInvoiceFormWidth,
      height: customerInvoiceFormHeight,
    );
  }
}
