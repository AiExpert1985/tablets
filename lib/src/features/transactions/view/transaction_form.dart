import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tablets/generated/l10n.dart';
import 'package:tablets/src/common/classes/db_cache.dart';
import 'package:tablets/src/common/classes/item_form_controller.dart';
import 'package:tablets/src/common/classes/item_form_data.dart';
import 'package:tablets/src/common/functions/debug_print.dart';
import 'package:tablets/src/common/functions/print_document.dart';
import 'package:tablets/src/common/functions/user_messages.dart';
import 'package:tablets/src/common/functions/utils.dart';
import 'package:tablets/src/common/providers/background_color.dart';
// import 'package:tablets/src/common/providers/background_color.dart';
import 'package:tablets/src/common/providers/image_picker_provider.dart';
import 'package:tablets/src/common/providers/text_editing_controllers_provider.dart';
import 'package:tablets/src/common/values/constants.dart';
import 'package:tablets/src/common/values/transactions_common_values.dart';
import 'package:tablets/src/common/widgets/custome_appbar_for_back_return.dart';
import 'package:tablets/src/common/widgets/dialog_delete_confirmation.dart';
import 'package:tablets/src/common/widgets/form_frame.dart';
import 'package:tablets/src/common/widgets/custom_icons.dart';
import 'package:tablets/src/common/values/form_dimenssions.dart';
import 'package:tablets/src/features/settings/controllers/settings_form_data_notifier.dart';
import 'package:tablets/src/features/transactions/controllers/form_navigator_provider.dart';
import 'package:tablets/src/features/transactions/controllers/transaction_screen_controller.dart';
import 'package:tablets/src/features/transactions/model/transaction.dart';
import 'package:tablets/src/features/transactions/repository/transaction_db_cache_provider.dart';
import 'package:tablets/src/features/transactions/controllers/transaction_form_controller.dart';
import 'package:tablets/src/features/transactions/controllers/transaction_form_data_notifier.dart';
import 'package:tablets/src/features/transactions/view/forms/expenditure_form.dart';
import 'package:tablets/src/features/transactions/view/forms/invoice_form.dart';
import 'package:tablets/src/features/transactions/view/forms/receipt_form.dart';
import 'package:tablets/src/features/transactions/view/forms/statement_form.dart';
import 'package:tablets/src/features/transactions/view/transaction_show_form.dart';
import 'package:tablets/src/routers/go_router_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart' as firebase;

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
      return StatementForm(titles[transactionType]!, transactionType, isGift: true);
    }
    if (transactionType == TransactionType.damagedItems.name) {
      return StatementForm(titles[transactionType]!, transactionType);
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
    final screenController = ref.read(transactionScreenControllerProvider);
    final dbCache = ref.read(transactionDbCacheProvider.notifier);
    final formNavigation = ref.read(formNavigatorProvider);
    formNavigation.initialize(transactionType, formDataNotifier.getProperty(dbRefKey));
    // final transactionTypeTranslated = translateScreenTextToDbText(context, transactionType);
    // final backgroundColor = ref.watch(backgroundColorProvider);
    ref.watch(imagePickerProvider);
    ref.watch(transactionFormDataProvider);
    ref.watch(textFieldsControllerProvider);
    final height = transactionFormDimenssions[transactionType]['height'];
    final width = transactionFormDimenssions[transactionType]['width'];

    return Scaffold(
      appBar: buildArabicAppBar(context, () async {
        await onReturn(context, ref, formImagesNotifier);
        if (context.mounted) {
          Navigator.pop(context);
        }
      }, () async {
        await onReturn(context, ref, formImagesNotifier);
        if (context.mounted) {
          context.goNamed(AppRoute.home.name);
        }
      }),
      body: FormFrame(
        // backgroundColor: backgroundColor,
        // formKey: formController.formKey,
        // formKey: GlobalKey<FormState>(),
        fields: _getFormWidget(context, transactionType),
        buttons: _actionButtons(context, formController, formDataNotifier, formImagesNotifier,
            dbCache, screenController, formNavigation, ref),
        width: width is double ? width : width.toDouble(),
        height: height is double ? height : height.toDouble(),
      ),
    );
  }

  List<Widget> _actionButtons(
    BuildContext context,
    ItemFormController formController,
    ItemFormData formDataNotifier,
    ImageSliderNotifier formImagesNotifier,
    DbCache transactionDbCache,
    TransactionScreenController screenController,
    FromNavigator formNavigation,
    WidgetRef ref,
  ) {
    return [
      IconButton(
        onPressed: () {
          final formData = formNavigation.first();
          onNavigationPressed(formDataNotifier, context, ref, formImagesNotifier,
              targetTransactionData: formData);
        },
        icon: const GoFirstIcon(),
      ),
      IconButton(
        onPressed: () {
          final formData = formNavigation.previous();
          onNavigationPressed(formDataNotifier, context, ref, formImagesNotifier,
              targetTransactionData: formData);
        },
        icon: const GoPreviousIcon(),
      ),
      const SizedBox(width: 250),
      IconButton(
        onPressed: () {
          deleteTransaction(context, ref, formDataNotifier, formImagesNotifier, formController,
              transactionDbCache, screenController,
              formNavigation: formNavigation);
        },
        icon: const DeleteIcon(),
      ),
      IconButton(
        onPressed: () {
          // _onSavePressed(context, ref, formController, formDataNotifier, formImagesNotifier,
          //     transactionDbCache, screenController,
          //     keepDialog: true);
          _onPrintPressed(context, ref, formDataNotifier);
        },
        icon: formDataNotifier.getProperty(isPrintedKey) ? const PrintedIcon() : const PrintIcon(),
      ),
      IconButton(
        onPressed: () {
          onNavigationPressed(formDataNotifier, context, ref, formImagesNotifier,
              isNewTransaction: true);
        },
        icon: const NewIemIcon(),
      ),
      const SizedBox(width: 250),
      IconButton(
        onPressed: () {
          final formData = formNavigation.next();
          onNavigationPressed(formDataNotifier, context, ref, formImagesNotifier,
              targetTransactionData: formData);
        },
        icon: const GoNextIcon(),
      ),
      IconButton(
        onPressed: () {
          final formData = formNavigation.last();
          onNavigationPressed(formDataNotifier, context, ref, formImagesNotifier,
              targetTransactionData: formData);
        },
        icon: const GoLastIcon(),
      ),
    ];
  }

  void _onPrintPressed(BuildContext context, WidgetRef ref, ItemFormData formDataNotifier) async {
    if (formDataNotifier.data[nameKey] == '') {
      failureUserMessage(context, S.of(context).no_name_print_error);
      return;
    }
    // first we need to save changes done to the form, then print, because if we don't save,
    // then the debt of customer will not accurately calculated
    saveTransaction(context, ref, formDataNotifier.data, true);
    printDocument(context, ref, formDataNotifier.data);
    formDataNotifier.updateProperties({isPrintedKey: true});
  }

  static void onNavigationPressed(ItemFormData formDataNotifier, BuildContext context,
      WidgetRef ref, ImageSliderNotifier formImagesNotifier,
      {Map<String, dynamic>? targetTransactionData,
      bool isNewTransaction = false,
      bool isDeleting = false}) {
    final settingsDataNotifier = ref.read(settingsFormDataProvider.notifier);
    final textEditingNotifier = ref.read(textFieldsControllerProvider.notifier);
    final imagePickerNotifier = ref.read(imagePickerProvider.notifier);

    final transactionDbCache = ref.read(transactionDbCacheProvider.notifier);

    final formType = formDataNotifier.getProperty(transactionTypeKey);
    // if we are navigating or creating new transaction, we save previous one, but if we are comming from
    // delete button inside the form, then we don't save
    if (!isDeleting) {
      // this step to save currently displayed transacton before moving to the navigated one
      saveTransaction(context, ref, formDataNotifier.data, true);
    }
    Navigator.of(context).pop();
    // now load the target transaction into the form, whether it is navigated or new transaction
    // note that navigatorFormData shouldn't be null if isNewTransaction is false
    if (isNewTransaction) {
      final backgroundColorNofifier = ref.read(backgroundColorProvider.notifier);
      backgroundColorNofifier.state = normalColor!;
      TransactionShowForm.showForm(
        context,
        ref,
        imagePickerNotifier,
        formDataNotifier,
        settingsDataNotifier,
        textEditingNotifier,
        formType: formType,
        transactionDbCache: transactionDbCache,
      );
    } else {
      if (targetTransactionData == null) {
        errorPrint('Navigating to a null transaction');
        return;
      }
      final imageUrls = formImagesNotifier.saveChanges();
      final itemData = {...targetTransactionData, 'imageUrls': imageUrls};
      final transaction = Transaction.fromMap(itemData);
      TransactionShowForm.showForm(
        context,
        ref,
        imagePickerNotifier,
        formDataNotifier,
        settingsDataNotifier,
        textEditingNotifier,
        transaction: transaction,
        formType: formType,
      );
    }
  }

  static Future<void> onReturn(
      BuildContext context, WidgetRef ref, ImageSliderNotifier formImagesNotifier) async {
    formImagesNotifier.close();
    final formDataNotifier = ref.read(transactionFormDataProvider.notifier);
    final dbCache = ref.read(transactionDbCacheProvider.notifier);
    if (context.mounted) {
      // we update item on close, unless the dialog were closed due to delete button
      // we need to check, if transaction is in dbCache it means dialog was not close
      // due to delete button, i.e. item was updated
      final transDbRef = formDataNotifier.data[dbRefKey];
      if (dbCache.getItemByDbRef(transDbRef).isNotEmpty) {
        if (context.mounted) {
          saveTransaction(context, ref, formDataNotifier.data, true);
        }
      }
    }
  }

  /// when delete transaction, we stay in the form but navigate to previous transaction
  static Future<bool> deleteTransaction(
      BuildContext context,
      WidgetRef ref,
      ItemFormData formDataNotifier,
      ImageSliderNotifier formImagesNotifier,
      ItemFormController formController,
      DbCache transactionDbCache,
      TransactionScreenController screenController,
      {FromNavigator? formNavigation}) async {
    final confirmation = await showDeleteConfirmationDialog(
        context: context,
        message:
            '${translateDbTextToScreenText(context, formDataNotifier.data[transTypeKey])}  ${formDataNotifier.data[numberKey]}');
    if (confirmation == null) return false;

    final formData = formDataNotifier.data;

    final imageUrls = formImagesNotifier.saveChanges();
    final itemData = {...formData, 'imageUrls': imageUrls};
    final transaction = Transaction.fromMap(itemData);
    if (context.mounted) {
      formController.deleteItemFromDb(context, transaction, keepDialogOpen: true);
    }
    // update the bdCache (database mirror) so that we don't need to fetch data from db
    const operationType = DbCacheOperationTypes.delete;
    transactionDbCache.update(itemData, operationType);
    // redo screenData calculations
    if (context.mounted) {
      screenController.setFeatureScreenData(context);
    }
    // move point to previous transaction
    if (formNavigation != null && context.mounted) {
      final targetTransactionData = formNavigation.previous();
      onNavigationPressed(
        formDataNotifier,
        context,
        ref,
        formImagesNotifier,
        targetTransactionData: targetTransactionData,
        isDeleting: true,
      );
    }
    return true;
  }

  static void saveTransaction(
    BuildContext context,
    WidgetRef ref,
    Map<String, dynamic> formData,
    bool isEditing,
  ) {
    final formController = ref.read(transactionFormControllerProvider);
    final formDataNotifier = ref.read(transactionFormDataProvider.notifier);
    final formImagesNotifier = ref.read(imagePickerProvider.notifier);
    final screenController = ref.read(transactionScreenControllerProvider);
    final dbCache = ref.read(transactionDbCacheProvider.notifier);
    // if (isEditing) {
    //   if (!formController.validateData()) return;
    //   formController.submitData();
    // }
    Map<String, dynamic> formData = {...formDataNotifier.data};
    // we need to remove empty rows (rows without item name, which is usally last one)
    formData = removeEmptyRows(formData);
    final imageUrls = formImagesNotifier.saveChanges();
    final itemData = {...formData, 'imageUrls': imageUrls};
    final transaction = Transaction.fromMap({...formData, 'imageUrls': imageUrls});
    formController.saveItemToDb(context, transaction, isEditing, keepDialogOpen: true);
    // update the bdCache (database mirror) so that we don't need to fetch data from db
    if (itemData[transactionDateKey] is DateTime) {
      // in our form the data type usually is DateTime, but the date type in dbCache should be
      // Timestamp, as to mirror the datatype of firebase
      itemData[transactionDateKey] = firebase.Timestamp.fromDate(formData[transactionDateKey]);
    }
    final operationType = isEditing ? DbCacheOperationTypes.edit : DbCacheOperationTypes.add;
    dbCache.update(itemData, operationType);
    // redo screenData calculations
    if (context.mounted) {
      screenController.setFeatureScreenData(context);
    }
  }

  /// delete rows where there is not item name
  static Map<String, dynamic> removeEmptyRows(Map<String, dynamic> formData) {
    List<Map<String, dynamic>> items = [];
    for (var i = 0; i < formData[itemsKey].length; i++) {
      final item = formData[itemsKey][i];
      // only add items with non empty name field
      if (item[nameKey] != '') {
        Map<String, dynamic> newItem = {};
        item.forEach((key, value) => newItem[key] = value);
        items.add(newItem);
      }
    }
    return {...formData, itemsKey: items};
  }
}
