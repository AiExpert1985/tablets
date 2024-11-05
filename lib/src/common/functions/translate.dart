import 'package:flutter/material.dart';
import 'package:tablets/generated/l10n.dart';
import 'package:tablets/src/features/settings/model/settings.dart';
import 'package:tablets/src/common/values/constants.dart';

String translateTransactionType(BuildContext context, String dbName) {
  final Map<String, String> trasactionTypeLookup = {
    TransactionType.expenditures.name: S.of(context).transaction_type_expenditures,
    TransactionType.gifts.name: S.of(context).transaction_type_gifts,
    TransactionType.customerReceipt.name: S.of(context).transaction_type_customer_receipt,
    TransactionType.vendorReceipt.name: S.of(context).transaction_type_vendor_receipt,
    TransactionType.vendorReturn.name: S.of(context).transaction_type_vender_return,
    TransactionType.customerReturn.name: S.of(context).transaction_type_customer_return,
    TransactionType.vendorInvoice.name: S.of(context).transaction_type_vender_invoice,
    TransactionType.customerInvoice.name: S.of(context).transaction_type_customer_invoice
  };
  return trasactionTypeLookup[dbName] ?? dbName;
}

String translateCurrency(BuildContext context, String dbName) {
  final Map<String, String> trasactionTypeLookup = {
    Currency.dinar.name: S.of(context).transaction_payment_Dinar,
    Currency.dollar.name: S.of(context).transaction_payment_Dollar,
  };
  return trasactionTypeLookup[dbName] ?? dbName;
}

String translatePaymentType(BuildContext context, String dbName) {
  final Map<String, String> trasactionTypeLookup = {
    PaymentType.credit.name: S.of(context).transaction_payment_credit,
    PaymentType.cash.name: S.of(context).transaction_payment_cash,
  };
  return trasactionTypeLookup[dbName] ?? dbName;
}
