import 'package:flutter/material.dart';
import 'package:tablets/generated/l10n.dart';
import 'package:tablets/src/common/classes/item_form_data.dart';
import 'package:tablets/src/common/functions/debug_print.dart';
import 'package:tablets/src/common/providers/image_picker_provider.dart';
import 'package:tablets/src/common/providers/text_editing_controllers_provider.dart';
import 'package:tablets/src/features/transactions/model/transaction.dart';
import 'package:tablets/src/features/transactions/view/forms/common_utils/common_values.dart';
import 'package:tablets/src/features/transactions/view/transaction_form.dart';

class TransactionShowFormUtils {
  static void initializeFormData(
      BuildContext context, ItemFormData formDataNotifier, String transactionType,
      {Transaction? transaction}) {
    formDataNotifier.initialize(initialData: transaction?.toMap());
    if (transaction != null) return; // if we are in edit, we don't need further initialization

    formDataNotifier.updateProperties({
      currencyKey: S.of(context).transaction_payment_Dinar,
      paymentTypeKey: S.of(context).transaction_payment_credit,
      discountKey: 0.0,
      transactionTypeKey: transactionType,
      dateKey: DateTime.now(),
      totalAmountKey: 0,
      totalWeightKey: 0,
      nameKey: null,
      salesmanKey: null,
      numberKey: null,
      totalAsTextKey: null,
      notesKey: null,
    });
    formDataNotifier.updateSubProperties(itemsKey, emptyCustomerInvoiceItem);
  }

  // for below text field we need to add  controllers because the are updated by other fields
  // for example total price it updated by the item prices
  static void initializeTextFieldControllers(
      TextControllerNotifier textEditingNotifier, ItemFormData formDataNotifier) {
    List items = formDataNotifier.getProperty(itemsKey);
    for (var i = 0; i < items.length; i++) {
      final price = formDataNotifier.getSubProperty(itemsKey, i, itemPriceKey);
      final weight = formDataNotifier.getSubProperty(itemsKey, i, itemWeightKey);
      final soldQuantity = formDataNotifier.getSubProperty(itemsKey, i, itemSoldQuantityKey);
      final giftQuantity = formDataNotifier.getSubProperty(itemsKey, i, itemGiftQuantityKey);
      textEditingNotifier.updateSubControllers(itemsKey, {
        itemPriceKey: price,
        itemSoldQuantityKey: soldQuantity,
        itemGiftQuantityKey: giftQuantity,
        itemTotalAmountKey: soldQuantity == null || price == null ? 0 : soldQuantity * price,
        itemTotalWeightKey: soldQuantity == null || weight == null ? 0 : soldQuantity * weight,
      });
      final totalAmount = formDataNotifier.getProperty(totalAmountKey);
      final totalWeight = formDataNotifier.getProperty(totalWeightKey);
      textEditingNotifier
          .updateControllers({totalAmountKey: totalAmount, totalWeightKey: totalWeight});
    }
  }

  static void showForm(
    BuildContext context,
    ImageSliderNotifier imagePickerNotifier,
    ItemFormData formDataNotifier,
    TextControllerNotifier textEditingNotifier, {
    String? formType,
    Transaction? transaction,
  }) {
    if (formType == null && transaction?.transactionType == null) {
      errorPrint(
          'both formType and transaction can not be null, one of them is needed for transactionType');
      return;
    }
    String transactionType = formType ?? transaction?.transactionType as String;
    imagePickerNotifier.initialize();
    initializeFormData(context, formDataNotifier, transactionType, transaction: transaction);
    initializeTextFieldControllers(textEditingNotifier, formDataNotifier);
    bool isEditMode = transaction != null;

    showDialog(
      context: context,
      builder: (BuildContext ctx) => TransactionForm(isEditMode, transactionType),
    ).whenComplete(() {
      imagePickerNotifier.close();
      textEditingNotifier.disposeControllers();
    });
  }
}
