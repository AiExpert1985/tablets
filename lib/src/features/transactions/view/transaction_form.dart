import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tablets/generated/l10n.dart';
import 'package:tablets/src/common/classes/item_form_controller.dart';
import 'package:tablets/src/common/classes/item_form_data.dart';
import 'package:tablets/src/common/functions/utils.dart';
import 'package:tablets/src/common/providers/image_picker_provider.dart';
import 'package:tablets/src/common/values/constants.dart';
import 'package:tablets/src/common/widgets/dialog_delete_confirmation.dart';
import 'package:tablets/src/common/widgets/form_frame.dart';
import 'package:tablets/src/common/widgets/custom_icons.dart';
import 'package:tablets/src/common/values/form_dimenssions.dart';
import 'package:tablets/src/features/transactions/controllers/transaction_form_controller.dart';
import 'package:tablets/src/features/transactions/model/transaction.dart';
import 'package:tablets/src/features/transactions/view/forms/invoice_form.dart';

class TransactionForm extends ConsumerWidget {
  const TransactionForm(this.isEditMode, this.transactionType, {super.key});
  final bool isEditMode; // used by formController to decide whether to save or update in db
  final String transactionType;

  Widget _getFormWidget(BuildContext context, String transactionType) {
    final titles = {
      TransactionType.customerInvoice.name: S.of(context).transaction_type_customer_invoice,
      TransactionType.vendorInvoice.name: S.of(context).transaction_type_vender_invoice,
      TransactionType.customerReturn.name: S.of(context).transaction_type_customer_return,
      TransactionType.vendorReturn.name: S.of(context).transaction_type_vender_return,
      TransactionType.customerReceipt.name: S.of(context).transaction_type_customer_receipt,
      TransactionType.vendorReceipt.name: S.of(context).transaction_type_vendor_receipt,
      TransactionType.gifts.name: S.of(context).transaction_type_gifts,
      TransactionType.expenditures.name: S.of(context).transaction_type_expenditures,
      TransactionType.damagedItems.name: S.of(context).transaction_type_damaged_items,
    };
    if (transactionType == TransactionType.customerInvoice.name) {
      return InvoiceForm(titles[transactionType]!, includeSalesman: true, includeGifts: true);
    }
    if (transactionType == TransactionType.vendorInvoice.name) {
      return InvoiceForm(titles[transactionType]!);
    }
    if (transactionType == TransactionType.customerReturn.name) {
      return InvoiceForm(titles[transactionType]!, includeSalesman: true);
    }
    if (transactionType == TransactionType.vendorReturn.name) {
      return InvoiceForm(titles[transactionType]!);
    }
    return const Center(child: Text('Error happend while loading transaction form'));
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formController = ref.read(transactionFormControllerProvider);
    final formDataNotifier = ref.read(transactionFormDataProvider.notifier);
    final formImagesNotifier = ref.read(imagePickerProvider.notifier);
    ref.watch(imagePickerProvider);
    return FormFrame(
      formKey: formController.formKey,
      fields: _getFormWidget(context, transactionType),
      buttons: _actionButtons(context, formController, formDataNotifier, formImagesNotifier),
      width: transactionFormDimenssions[transactionType]['width'],
      height: transactionFormDimenssions[transactionType]['height'],
    );
  }

  List<Widget> _actionButtons(BuildContext context, ItemFormController formController,
      ItemFormData formDataNotifier, ImageSliderNotifier formImagesNotifier) {
    return [
      IconButton(
        onPressed: () =>
            _onSavePressed(context, formController, formDataNotifier, formImagesNotifier),
        icon: const SaveIcon(),
      ),
      IconButton(
        onPressed: () => Navigator.of(context).pop(),
        icon: const CancelIcon(),
      ),
      if (isEditMode)
        IconButton(
          onPressed: () =>
              _onDeletePressed(context, formDataNotifier, formImagesNotifier, formController),
          icon: const DeleteIcon(),
        ),
    ];
  }

  void _onSavePressed(BuildContext context, ItemFormController formController,
      ItemFormData formDataNotifier, ImageSliderNotifier formImagesNotifier) {
    if (!formController.validateData()) return;
    formController.submitData();
    final updateFormData = formDataNotifier.data;
    final imageUrls = formImagesNotifier.saveChanges();
    final transaction = Transaction.fromMap({...updateFormData, 'imageUrls': imageUrls});
    formController.saveItemToDb(context, transaction, isEditMode);
  }

  Future<void> _onDeletePressed(BuildContext context, ItemFormData formDataNotifier,
      ImageSliderNotifier formImagesNotifier, ItemFormController formController) async {
    final message = translateDbString(context, formDataNotifier.data['name']);
    final confirmation = await showDeleteConfirmationDialog(context: context, message: message);
    if (confirmation != null) {
      final imageUrls = formImagesNotifier.saveChanges();
      final transaction = Transaction.fromMap({...formDataNotifier.data, 'imageUrls': imageUrls});
      // ignore: use_build_context_synchronously
      formController.deleteItemFromDb(context, transaction);
    }
  }
}
