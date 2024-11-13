import 'dart:math';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:tablets/src/common/functions/debug_print.dart' as debug;
import 'package:image/image.dart' as img;
import 'package:tablets/generated/l10n.dart';
import 'package:tablets/src/features/settings/model/settings.dart';
import 'package:tablets/src/common/values/constants.dart';

String translateDbTextToScreenText(BuildContext context, String dbText) {
  final Map<String, String> lookup = {
    TransactionType.expenditures.name: S.of(context).transaction_type_expenditures,
    TransactionType.gifts.name: S.of(context).transaction_type_gifts,
    TransactionType.customerReceipt.name: S.of(context).transaction_type_customer_receipt,
    TransactionType.vendorReceipt.name: S.of(context).transaction_type_vendor_receipt,
    TransactionType.vendorReturn.name: S.of(context).transaction_type_vender_return,
    TransactionType.customerReturn.name: S.of(context).transaction_type_customer_return,
    TransactionType.vendorInvoice.name: S.of(context).transaction_type_vender_invoice,
    TransactionType.customerInvoice.name: S.of(context).transaction_type_customer_invoice,
    Currency.dinar.name: S.of(context).transaction_payment_Dinar,
    Currency.dollar.name: S.of(context).transaction_payment_Dollar,
    PaymentType.credit.name: S.of(context).transaction_payment_credit,
    PaymentType.cash.name: S.of(context).transaction_payment_cash,
    SellPriceType.retail.name: S.of(context).selling_price_type_retail,
    SellPriceType.wholesale.name: S.of(context).selling_price_type_whole,
    'true': S.of(context).yes,
    'false': S.of(context).no,
  };
  return lookup[dbText] ?? dbText;
}

String translateScreenTextToDbText(BuildContext context, String screenText) {
  final Map<String, String> lookup = {
    S.of(context).transaction_type_expenditures: TransactionType.expenditures.name,
    S.of(context).transaction_type_gifts: TransactionType.gifts.name,
    S.of(context).transaction_type_customer_receipt: TransactionType.customerReceipt.name,
    S.of(context).transaction_type_vendor_receipt: TransactionType.vendorReceipt.name,
    S.of(context).transaction_type_vender_return: TransactionType.vendorReturn.name,
    S.of(context).transaction_type_customer_return: TransactionType.customerReturn.name,
    S.of(context).transaction_type_vender_invoice: TransactionType.vendorInvoice.name,
    S.of(context).transaction_type_customer_invoice: TransactionType.customerInvoice.name,
    S.of(context).transaction_payment_Dinar: Currency.dinar.name,
    S.of(context).transaction_payment_Dollar: Currency.dollar.name,
    S.of(context).transaction_payment_credit: PaymentType.credit.name,
    S.of(context).transaction_payment_cash: PaymentType.cash.name,
    S.of(context).selling_price_type_retail: SellPriceType.retail.name,
    S.of(context).selling_price_type_whole: SellPriceType.wholesale.name,
    S.of(context).yes: 'true',
    S.of(context).no: 'false',
  };

  return lookup[screenText] ?? screenText;
}

String generateRandomString({int len = 5}) {
  var r = Random();
  return String.fromCharCodes(List.generate(len, (index) => r.nextInt(33) + 89)).toString();
}

/// compare two Lists of string
/// find items in the first list that don't exists in second list
List<String> twoListsDifferences(List<String> list1, List<String> list2) =>
    list1.where((item) => !list2.toSet().contains(item)).toList();

// Default result image size is 50 k byte (reduce speed and the cost of firebase)
// compression depends on image size, the larget image the more compression
// if image size is small, it will not be compressed
Uint8List? compressImage(Uint8List? image, {int targetImageSizeInBytes = 51200}) {
  final quality = (image!.length / targetImageSizeInBytes).round();
  if (quality > 0) {
    image = img.encodeJpg(img.decodeImage(image)!, quality: quality);
  }
  return image;
}

InputDecoration formFieldDecoration({String? label, bool hideBorders = false}) {
  return InputDecoration(
    // floatingLabelAlignment: FloatingLabelAlignment.center,
    label: label == null
        ? null
        : Text(
            label,
            // textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 13,
              color: Colors.black38,
            ),
          ),
    alignLabelWithHint: true,
    contentPadding: const EdgeInsets.all(12),
    isDense: true, // Add this line to remove the default padding
    border: hideBorders
        ? InputBorder.none
        : const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(8)),
          ),
  );
}

List<Map<String, dynamic>> convertAsyncValueListToList(
    AsyncValue<List<Map<String, dynamic>>> asyncProductList) {
  return asyncProductList.when(
      data: (products) => products,
      error: (e, st) {
        debug.errorPrint(e, stackTrace: st);
        return [];
      },
      loading: () {
        debug.errorPrint('product list is loading');
        return [];
      });
}

/// if the number ends with .0 (example 55.0), it will remove .0 and convert to String
String numberToText(dynamic value) {
  // Check if the value is an integer
  if (value == value.toInt()) {
    return value.toInt().toString(); // Convert to int and return as string
  }
  return value.toString(); // Return as string if not an integer
}

String formatDate(DateTime date) => DateFormat('yyyy/MM/dd').format(date);

// used to create thousand comma separators for numbers displayed in the UI
// it can be used with or without decimal places using numDecimalPlaces optional parameter
String doubleToStringWithComma(double value, {int? numDecimalPlaces}) {
  String valueString = '';
  if (numDecimalPlaces != null) {
    valueString = value.toStringAsFixed(numDecimalPlaces); // Keeping 2 decimal places
  } else {
    valueString = value.toString();
  }
  // Split the string into whole and decimal parts
  List<String> parts = valueString.split('.');
  String wholePart = parts[0];
  String decimalPart = parts.length > 1 ? '.${parts[1]}' : '';
  // Add commas to the whole part
  String formattedWholePart = wholePart.replaceAllMapped(
      RegExp(r'(\d)(?=(\d{3})+(?!\d))'), (Match match) => '${match[1]},');
  // Combine the whole part and the decimal part
  return formattedWholePart + decimalPart;
}
