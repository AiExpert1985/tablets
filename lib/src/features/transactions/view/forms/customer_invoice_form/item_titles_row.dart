import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tablets/generated/l10n.dart';
import 'package:tablets/src/features/transactions/view/common/customer_invoice_widths.dart';
import 'package:tablets/src/features/transactions/view/common/item_cell.dart';

class CustomerInvoiceItemTitles extends ConsumerWidget {
  const CustomerInvoiceItemTitles({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        ..._buildItemDataCells(context),
      ],
    );
  }

  List<Widget> _buildItemDataCells(BuildContext context) {
    final titles = [
      '',
      S.of(context).item_name,
      S.of(context).item_price,
      S.of(context).item_sold_quantity,
      S.of(context).item_gifts_quantity,
      S.of(context).item_total_price,
    ];

    final widths = [
      CustomerInvoiceWidths.sequence,
      CustomerInvoiceWidths.name,
      CustomerInvoiceWidths.price,
      CustomerInvoiceWidths.soldQuantity,
      CustomerInvoiceWidths.giftQuantity,
      CustomerInvoiceWidths.soldTotalAmount,
    ];

    return List.generate(titles.length, (index) {
      return ItemDataCell(
        isTitle: true,
        isFirst: index == 0,
        isLast: index == titles.length - 1,
        width: widths[index],
        cell: Text(titles[index]),
      );
    });
  }
}
