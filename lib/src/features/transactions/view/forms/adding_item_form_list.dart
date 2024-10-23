import 'package:flutter/material.dart';
import 'package:tablets/generated/l10n.dart';
import 'package:tablets/src/common/constants/constants.dart';

class AddingItemFormList extends StatelessWidget {
  const AddingItemFormList({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black38, width: 1.0),
        borderRadius: BorderRadius.circular(8.0),
      ),
      padding: const EdgeInsets.all(12),
      child: Column(
        children: [
          const ItemListTitles(),
          Expanded(
            child: ListView(
              children: const [
                ItemListTitles(),
                ItemListTitles(),
                ItemListTitles(),
                ItemListTitles(),
                ItemListTitles(),
                ItemListTitles(),
                ItemListTitles(),
                ItemListTitles(),
                ItemListTitles(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ItemListTitles extends StatelessWidget {
  const ItemListTitles({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        FormItemCell(
            isTitle: true,
            isFirst: true,
            width: sequenceWidth,
            cell: Text(S.of(context).item_sequence)),
        FormItemCell(isTitle: true, width: nameWidth, cell: Text(S.of(context).item_name)),
        FormItemCell(isTitle: true, width: priceWidth, cell: Text(S.of(context).item_price)),
        FormItemCell(
            isTitle: true, width: soldQuantityWidth, cell: Text(S.of(context).item_sold_quantity)),
        FormItemCell(
            isTitle: true, width: giftQantityWidth, cell: Text(S.of(context).item_gifts_quantity)),
        FormItemCell(
            isTitle: true,
            isLast: true,
            width: soldTotalPriceWidth,
            cell: Text(S.of(context).item_total_price)),
      ],
    );
  }
}

class FormItemCell extends StatelessWidget {
  const FormItemCell(
      {required this.width,
      required this.cell,
      this.height = itemHeight,
      this.isTitle = false,
      this.isFirst = false,
      this.isLast = false,
      super.key});
  final bool isTitle; // title is diffent in having lower border line
  final bool isFirst; // first doesn't have right border (in arabic locale)
  final bool isLast; // doesn't have left border (in arabic locale)
  final double width;
  final double height;
  final Widget cell;

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
          border: Border(
            left: !isLast
                ? const BorderSide(color: Color.fromARGB(31, 133, 132, 132), width: 1.0)
                : BorderSide.none,
            right: !isFirst
                ? const BorderSide(color: Color.fromARGB(31, 133, 132, 132), width: 1.0)
                : BorderSide.none,
            bottom: isTitle
                ? const BorderSide(color: Color.fromARGB(31, 133, 132, 132), width: 1.0)
                : BorderSide.none,
          ),
        ),
        width: width,
        height: itemHeight,
        child: Center(child: cell));
  }
}

// I made a design decision to make the width variable based on the size of the container
const double itemHeight = customerInvoiceFormHeight * 0.06;
const double sequenceWidth = customerInvoiceFormWidth * 0.1;
const double nameWidth = customerInvoiceFormWidth * 0.34;
const double priceWidth = customerInvoiceFormWidth * 0.12;
const double soldQuantityWidth = customerInvoiceFormWidth * 0.12;
const double giftQantityWidth = customerInvoiceFormWidth * 0.12;
const double soldTotalPriceWidth = customerInvoiceFormWidth * 0.13;
