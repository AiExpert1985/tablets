import 'package:flutter/material.dart';
import 'package:tablets/generated/l10n.dart';
import 'package:tablets/src/common/classes/item_form_data.dart';
import 'package:tablets/src/common/providers/image_picker_provider.dart';
import 'package:tablets/src/common/providers/text_editing_controllers_provider.dart';
import 'package:tablets/src/common/values/constants.dart' as constants;
import 'package:tablets/src/features/transactions/model/transaction.dart';
import 'package:tablets/src/features/transactions/view/transaction_form.dart';

class TransactionShowFormUtils {
  static void initializeFormData(BuildContext context, ItemFormData formDataNotifier,
      {String? formType, Transaction? transaction}) {
    formDataNotifier.initialize(initialData: transaction?.toMap());
    // give defaults values for drop down lists based on codition represents the transaction type
    if (formType == constants.TransactionTypes.customerInvoice.name) {
      formDataNotifier.updateProperties({
        'currency': S.of(context).transaction_payment_Dinar,
        'paymentType': S.of(context).transaction_payment_credit,
        'discount': 0.0,
        'name': formType,
        'date': DateTime.now(),
      });
    }
  }

  static void initializeTextFieldControllers(TextControllerNotifier textFieldNotifier) {
    // for below text field we need to add  controllers because the are updated by other fields
    // for example total price it updated by the item prices
    textFieldNotifier.addController(fieldName: 'totalAmount');
    textFieldNotifier.addController(fieldName: 'totalWeight');
  }

  static void showForm(
    BuildContext context,
    ImageSliderNotifier imagePickerNotifier,
    ItemFormData formDataNotifier,
    TextControllerNotifier textFieldNotifier, {
    String? formType,
    Transaction? transaction,
    bool isEditMode = false,
  }) {
    imagePickerNotifier.initialize();
    initializeFormData(context, formDataNotifier, formType: formType, transaction: transaction);
    initializeTextFieldControllers(textFieldNotifier);
    showDialog(
      context: context,
      builder: (BuildContext ctx) => TransactionForm(isEditMode),
    ).whenComplete(() {
      imagePickerNotifier.close();
      textFieldNotifier.disposeControllers();
    });
  }
}
