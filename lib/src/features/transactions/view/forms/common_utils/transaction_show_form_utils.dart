import 'package:flutter/material.dart';
import 'package:tablets/generated/l10n.dart';
import 'package:tablets/src/common/classes/item_form_data.dart';
import 'package:tablets/src/common/functions/debug_print.dart';
import 'package:tablets/src/common/providers/image_picker_provider.dart';
import 'package:tablets/src/common/providers/text_editing_controllers_provider.dart';
import 'package:tablets/src/common/values/constants.dart';
import 'package:tablets/src/features/transactions/model/transaction.dart';
import 'package:tablets/src/features/transactions/view/transaction_form.dart';

class TransactionShowFormUtils {
  static const String itemsKey = 'items';
  static const String priceKey = 'price';
  static const String totalWeightKey = 'totalWeight';
  static const String totalAmountKey = 'totalAmount';
  static const String soldQuantityKey = 'soldQuantity';
  static const String giftQuantityKey = 'giftQuantity';
  static const String itemTotalAmountKey = 'itemTotalAmount';

  static void initializeFormData(
      BuildContext context, ItemFormData formDataNotifier, String transactionType,
      {Transaction? transaction}) {
    formDataNotifier.initialize(initialData: transaction?.toMap());
    if (transaction != null) return; // if we are in edit, we don't need further initialization
    if (transactionType == TransactionType.customerInvoice.name) {
      formDataNotifier.updateProperties({
        'currency': S.of(context).transaction_payment_Dinar,
        'paymentType': S.of(context).transaction_payment_credit,
        'discount': 0.0,
        'transactionType': transactionType,
        'date': DateTime.now(),
      });
    }
  }

  static void initializeTextFieldControllers(TextControllerNotifier textEditingNotifier,
      ItemFormData formDataNotifier, Transaction? transaction) {
    // for below text field we need to add  controllers because the are updated by other fields
    // for example total price it updated by the item prices
    if (transaction != null) {
      textEditingNotifier.addController(totalAmountKey,
          value: formDataNotifier.getProperty(totalAmountKey));
      textEditingNotifier.addController(totalWeightKey,
          value: formDataNotifier.getProperty(totalWeightKey));
      List items = formDataNotifier.data[itemsKey];
      for (var i = 0; i < items.length; i++) {
        final price = formDataNotifier.getSubProperty(itemsKey, i, priceKey);
        final soldQuantity = formDataNotifier.getSubProperty(itemsKey, i, soldQuantityKey);
        final giftQuantity = formDataNotifier.getSubProperty(itemsKey, i, giftQuantityKey);
        textEditingNotifier.addSubControllers(itemsKey, {
          priceKey: price,
          soldQuantityKey: soldQuantity,
          giftQuantityKey: giftQuantity,
          itemTotalAmountKey: price * soldQuantity,
        });
      }
      return;
    }
    textEditingNotifier.addController(totalAmountKey);
    textEditingNotifier.addController(totalWeightKey);
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
    initializeTextFieldControllers(textEditingNotifier, formDataNotifier, transaction);
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
