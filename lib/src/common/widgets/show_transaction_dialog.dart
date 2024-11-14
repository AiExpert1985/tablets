import 'package:flutter/material.dart';
import 'package:tablets/generated/l10n.dart';
import 'package:tablets/src/common/functions/utils.dart';
import 'package:tablets/src/common/values/constants.dart';
import 'package:tablets/src/common/values/form_dimenssions.dart';
import 'package:tablets/src/common/values/gaps.dart';
import 'package:tablets/src/common/values/settings.dart' as settings;
import 'package:tablets/src/common/values/transactions_common_values.dart';
import 'package:tablets/src/common/widgets/form_fields/edit_box.dart';
import 'package:tablets/src/common/widgets/form_title.dart';
import 'package:tablets/src/features/transactions/model/transaction.dart';

void showReadOnlyTransaction(BuildContext context, Transaction transaction) {
  showDialog(
    context: context,
    builder: (context) {
      return TransactionReadOnlyInvoice(transaction);
    },
  );
}

class TransactionReadOnlyInvoice extends StatelessWidget {
  const TransactionReadOnlyInvoice(this.transaction,
      {this.isVendor = false, this.hideGifts = true, super.key});
  final Transaction transaction;
  final bool hideGifts;
  final bool isVendor;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        title: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child:
                buildFormTitle(translateDbTextToScreenText(context, transaction.transactionType))),
        content: _buildDialogContent(context));
  }

  Widget _buildDialogContent(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        // color: backgroundColor,
        padding: const EdgeInsets.symmetric(vertical: 18),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            VerticalGap.xl,
            _buildFirstRow(context, transaction, isVendor),
            VerticalGap.m,
            _buildSecondRow(context, transaction),
            VerticalGap.m,
            _buildThirdRow(context, transaction),
            VerticalGap.m,
            _buildForthRow(context, transaction),
            VerticalGap.m,
            _buildFifthRow(context, transaction),
            VerticalGap.m,
            buildItemList(context, transaction, hideGifts, false),
            VerticalGap.xxl,
            _buildTotalsRow(context, transaction),
          ],
        ),
      ),
    );
  }

  Widget _buildFirstRow(BuildContext context, Transaction transaction, bool isVendor) {
    final nameLabel = isVendor ? S.of(context).vendor : S.of(context).customer;
    final salesmanLabel = S.of(context).transaction_salesman;
    return Row(
      children: [
        decoratedTextFormField(transaction.name, label: nameLabel),
        if (!isVendor) HorizontalGap.l,
        if (!isVendor) decoratedTextFormField(transaction.salesman, label: salesmanLabel),
      ],
    );
  }

  Widget _buildSecondRow(BuildContext context, Transaction transaction) {
    final currencyLabel = S.of(context).transaction_currency;
    final discountLabel = S.of(context).transaction_discount;
    return Row(
      children: [
        decoratedTextFormField(transaction.currency, label: currencyLabel),
        HorizontalGap.l,
        decoratedTextFormField(transaction.discount, label: discountLabel),
      ],
    );
  }

  Widget _buildThirdRow(BuildContext context, Transaction transaction) {
    final numberLabel = S.of(context).transaction_number;
    final paymentTypeLabel = S.of(context).transaction_payment_type;
    final dateLabel = S.of(context).transaction_date;
    return Row(
      children: [
        decoratedTextFormField(transaction.number, label: numberLabel),
        HorizontalGap.l,
        decoratedTextFormField(transaction.currency, label: paymentTypeLabel),
        HorizontalGap.l,
        decoratedTextFormField(transaction.currency, label: dateLabel),
      ],
    );
  }

  Widget _buildForthRow(BuildContext context, Transaction transaction) {
    final notesLabel = S.of(context).transaction_notes;
    return Row(
      children: [
        decoratedTextFormField(transaction.notes, label: notesLabel),
      ],
    );
  }

  Widget _buildFifthRow(BuildContext context, Transaction transaction) {
    final totalAsTextlLabel = S.of(context).transaction_total_amount_as_text;
    return Visibility(
      visible: settings.writeTotalAmountAsText,
      child: Row(
        children: [
          decoratedTextFormField(transaction.totalAsText, label: totalAsTextlLabel),
        ],
      ),
    );
  }

  Widget _buildTotalsRow(BuildContext context, Transaction transaction) {
    final totalSumLabel = S.of(context).invoice_total_price;
    final totalWeightLabel = S.of(context).invoice_total_weight;
    return SizedBox(
        width: customerInvoiceFormWidth * 0.6,
        child: Row(
          children: [
            decoratedTextFormField(transaction.totalAmount, label: totalSumLabel),
            HorizontalGap.xxl,
            decoratedTextFormField(transaction.totalWeight, label: totalWeightLabel),
          ],
        ));
  }
}

const double sequenceColumnWidth = customerInvoiceFormWidth * 0.055;
const double nameColumnWidth = customerInvoiceFormWidth * 0.345;
const double priceColumnWidth = customerInvoiceFormWidth * 0.16;
const double soldQuantityColumnWidth = customerInvoiceFormWidth * 0.1;
const double giftQuantityColumnWidth = customerInvoiceFormWidth * 0.1;
const double soldTotalAmountColumnWidth = customerInvoiceFormWidth * 0.17;

Widget buildItemList(
    BuildContext context, Transaction transaction, bool hideGifts, bool hidePrice) {
  return Container(
    height: 350,
    decoration: BoxDecoration(
      border: Border.all(color: Colors.black38, width: 1.0),
      borderRadius: BorderRadius.circular(8.0),
    ),
    padding: const EdgeInsets.all(12),
    child: SingleChildScrollView(
      child: Column(
        children: [
          _buildColumnTitles(context, hideGifts, hidePrice),
          ..._buildDataRows(transaction, hideGifts, hidePrice),
        ],
      ),
    ),
  );
}

List<Widget> _buildDataRows(Transaction transaction, bool hideGifts, bool hidePrice) {
  final items = transaction.items;
  if (items == null || items.isEmpty) return const [];
  return List.generate(items.length, (index) {
    final item = items[index];
    return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          buildDataCell(nameColumnWidth, Text(item[itemNameKey]), isFirst: true),
          if (!hidePrice) buildDataCell(priceColumnWidth, Text('${item[itemSellingPriceKey]}')),
          buildDataCell(soldQuantityColumnWidth, Text('${item[itemSoldQuantityKey]}')),
          if (!hideGifts)
            buildDataCell(giftQuantityColumnWidth, Text('${item[itemGiftQuantityKey]}')),
          if (!hidePrice)
            buildDataCell(soldTotalAmountColumnWidth, Text('${item[itemTotalAmountKey]}'),
                isLast: true),
        ]);
  });
}

Widget _buildColumnTitles(BuildContext context, bool hideGifts, bool hidePrice) {
  final titles = [
    Text(S.of(context).item_name),
    if (!hidePrice) Text(S.of(context).item_price),
    Text(S.of(context).item_sold_quantity),
    if (!hideGifts) Text(S.of(context).item_gifts_quantity),
    if (!hidePrice) Text(S.of(context).item_total_price),
  ];

  final widths = [
    nameColumnWidth,
    if (!hidePrice) priceColumnWidth,
    soldQuantityColumnWidth,
    if (!hideGifts) giftQuantityColumnWidth,
    if (!hidePrice) soldTotalAmountColumnWidth,
  ];

  return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        ...List.generate(titles.length, (index) {
          return buildDataCell(
            widths[index],
            titles[index],
            isTitle: true,
            isFirst: index == 0,
            isLast: index == titles.length - 1,
          );
        })
      ]);
}

Widget buildDataCell(
  double width,
  dynamic cell, {
  double height = 45,
  bool isTitle = false,
  bool isFirst = false,
  bool isLast = false,
}) {
  return Container(
      decoration: BoxDecoration(
        border: Border(
            left: !isLast
                ? const BorderSide(color: Color.fromARGB(31, 133, 132, 132), width: 1.0)
                : BorderSide.none,
            right: !isFirst
                ? const BorderSide(color: Color.fromARGB(31, 133, 132, 132), width: 1.0)
                : BorderSide.none,
            bottom: const BorderSide(color: Color.fromARGB(31, 133, 132, 132), width: 1.0)),
      ),
      width: width,
      height: height,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          cell,
        ],
      ));
}

Widget decoratedTextFormField(dynamic fieldValue, {String? label}) {
  String stringFieldValue;
  if (fieldValue is DateTime) {
    stringFieldValue = formatDate(fieldValue); // Assuming formatDate is defined elsewhere
  } else if (fieldValue is int || fieldValue is double) {
    stringFieldValue = fieldValue.toString();
  } else if (fieldValue is String) {
    stringFieldValue = fieldValue;
  } else {
    stringFieldValue = ''; // Default value if the type is not recognized
  }
  final name = generateRandomString();
  return FormInputField(
    label: label,
    initialValue: stringFieldValue,
    onChangedFn: (item) {},
    dataType: FieldDataType.text,
    name: name,
    isReadOnly: true,
  );
}
