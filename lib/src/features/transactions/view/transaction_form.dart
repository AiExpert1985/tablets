import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tablets/generated/l10n.dart';
import 'package:tablets/src/common/classes/db_cache.dart';
import 'package:tablets/src/common/classes/item_form_controller.dart';
import 'package:tablets/src/common/classes/item_form_data.dart';
import 'package:tablets/src/common/functions/utils.dart';
import 'package:tablets/src/common/providers/background_color.dart';
import 'package:tablets/src/common/providers/image_picker_provider.dart';
import 'package:tablets/src/common/values/constants.dart';
import 'package:tablets/src/common/widgets/dialog_delete_confirmation.dart';
import 'package:tablets/src/common/widgets/form_frame.dart';
import 'package:tablets/src/common/widgets/custom_icons.dart';
import 'package:tablets/src/common/values/form_dimenssions.dart';
import 'package:tablets/src/features/transactions/controllers/transaction_db_cache_provider.dart';
import 'package:tablets/src/features/transactions/controllers/transaction_form_controller.dart';
import 'package:tablets/src/features/transactions/model/transaction.dart';
import 'package:tablets/src/features/transactions/view/forms/expenditure_form.dart';
import 'package:tablets/src/features/transactions/view/forms/invoice_form.dart';
import 'package:tablets/src/features/transactions/view/forms/receipt_form.dart';
import 'package:tablets/src/features/transactions/view/forms/statement_form.dart';

class TransactionForm extends ConsumerWidget {
  const TransactionForm(this.isEditMode, this.transactionType, {super.key});
  final bool isEditMode; // used by formController to decide whether to save or update in db
  final String transactionType;
  // used to validate wether customer can buy new invoice (if he didn't exceed limits)

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
      return InvoiceForm(titles[transactionType]!, transactionType, hideGifts: false);
    }
    if (transactionType == TransactionType.vendorInvoice.name) {
      return InvoiceForm(titles[transactionType]!, transactionType, isVendor: true);
    }
    if (transactionType == TransactionType.customerReturn.name) {
      return InvoiceForm(titles[transactionType]!, transactionType);
    }
    if (transactionType == TransactionType.vendorReturn.name) {
      return InvoiceForm(titles[transactionType]!, transactionType, isVendor: true);
    }
    if (transactionType == TransactionType.customerReceipt.name) {
      return ReceiptForm(titles[transactionType]!);
    }
    if (transactionType == TransactionType.vendorReceipt.name) {
      return ReceiptForm(titles[transactionType]!, isVendor: true);
    }
    if (transactionType == TransactionType.gifts.name) {
      return StatementForm(titles[transactionType]!, isGift: true);
    }
    if (transactionType == TransactionType.damagedItems.name) {
      return StatementForm(titles[transactionType]!);
    }
    if (transactionType == TransactionType.expenditures.name) {
      return ExpenditureForm(titles[transactionType]!);
    }
    return const Center(child: Text('Error happend while loading transaction form'));
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formController = ref.read(transactionFormControllerProvider);
    final formDataNotifier = ref.read(transactionFormDataProvider.notifier);
    final formImagesNotifier = ref.read(imagePickerProvider.notifier);
    final backgroundColor = ref.watch(backgroundColorProvider);
    final transactionDbCache = ref.read(transactionDbCacheProvider.notifier);

    ref.watch(imagePickerProvider);
    return FormFrame(
      backgroundColor: backgroundColor,
      formKey: formController.formKey,
      fields: _getFormWidget(context, transactionType),
      buttons: _actionButtons(
          context, formController, formDataNotifier, formImagesNotifier, transactionDbCache),
      width: transactionFormDimenssions[transactionType]['width'],
      height: transactionFormDimenssions[transactionType]['height'],
    );
  }

  List<Widget> _actionButtons(
    BuildContext context,
    ItemFormController formController,
    ItemFormData formDataNotifier,
    ImageSliderNotifier formImagesNotifier,
    DbCache transactionDbCache,
  ) {
    return [
      IconButton(
        onPressed: () {
          _onSavePressed(
              context, formController, formDataNotifier, formImagesNotifier, transactionDbCache);
        },
        icon: const SaveIcon(),
      ),
      // IconButton(
      //   onPressed: () => Navigator.of(context).pop(),
      //   icon: const CancelIcon(),
      // ),
      if (isEditMode)
        IconButton(
          onPressed: () {
            _onDeletePressed(
                context, formDataNotifier, formImagesNotifier, formController, transactionDbCache);
          },
          icon: const DeleteIcon(),
        ),
    ];
  }

  void _onSavePressed(
      BuildContext context,
      ItemFormController formController,
      ItemFormData formDataNotifier,
      ImageSliderNotifier formImagesNotifier,
      DbCache transactionDbCache) {
    if (!formController.validateData()) return;
    formController.submitData();
    final formData = formDataNotifier.data;
    final imageUrls = formImagesNotifier.saveChanges();
    final transaction = Transaction.fromMap({...formData, 'imageUrls': imageUrls});
    formController.saveItemToDb(context, transaction, isEditMode);
    // update the bdCache (database mirror) so that we don't need to fetch data from db
    final operationType = isEditMode ? DbCacheOperationTypes.edit : DbCacheOperationTypes.add;
    transactionDbCache.update(formData, operationType);
  }

  Future<void> _onDeletePressed(
      BuildContext context,
      ItemFormData formDataNotifier,
      ImageSliderNotifier formImagesNotifier,
      ItemFormController formController,
      DbCache transactionDbCache) async {
    final message = translateDbTextToScreenText(context, formDataNotifier.data['name']);
    final confirmation = await showDeleteConfirmationDialog(context: context, message: message);
    final formData = formDataNotifier.data;
    if (confirmation != null) {
      final imageUrls = formImagesNotifier.saveChanges();
      final transaction = Transaction.fromMap({...formData, 'imageUrls': imageUrls});
      // ignore: use_build_context_synchronously
      formController.deleteItemFromDb(context, transaction);
      // // update the bdCache (database mirror) so that we don't need to fetch data from db
      // const operationType = DbCacheOperationTypes.delete;
      // transactionDbCache.update(formData, operationType);
    }
  }
}
