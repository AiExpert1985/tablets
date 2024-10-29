import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ItemDataCell extends ConsumerWidget {
  const ItemDataCell(
      {required this.width,
      required this.cell,
      this.height = 45,
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
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
        decoration: BoxDecoration(
          border: Border(
              left: !isLast ? const BorderSide(color: Color.fromARGB(31, 133, 132, 132), width: 1.0) : BorderSide.none,
              right:
                  !isFirst ? const BorderSide(color: Color.fromARGB(31, 133, 132, 132), width: 1.0) : BorderSide.none,
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
}
