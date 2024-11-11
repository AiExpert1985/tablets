import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:tablets/src/common/providers/background_color.dart';
import 'package:tablets/src/features/transactions/controllers/transaction_drawer_provider.dart';
import 'package:tablets/src/features/transactions/repository/transaction_repository_provider.dart';
import 'package:tablets/src/features/transactions/view/transaction_group_selection.dart';

class TransactionsFloatingButtons extends ConsumerWidget {
  const TransactionsFloatingButtons({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final drawerController = ref.watch(transactionDrawerControllerProvider);
    const iconsColor = Color.fromARGB(255, 126, 106, 211);
    return SpeedDial(
      direction: SpeedDialDirection.up,
      switchLabelPosition: false,
      animatedIcon: AnimatedIcons.menu_close,
      spaceBetweenChildren: 10,
      animatedIconTheme: const IconThemeData(size: 28.0),
      visible: true,
      curve: Curves.bounceInOut,
      children: [
        SpeedDialChild(
            child: const Icon(Icons.pie_chart, color: Colors.white),
            backgroundColor: iconsColor,
            onTap: () async {
              final allTransactions =
                  await ref.read(transactionRepositoryProvider).fetchItemListAsMaps();
              if (context.mounted) {
                drawerController.showReports(context, allTransactions);
              }
            }),
        SpeedDialChild(
          child: const Icon(Icons.search, color: Colors.white),
          backgroundColor: iconsColor,
          onTap: () => drawerController.showSearchForm(context),
        ),
        SpeedDialChild(
          child: const Icon(Icons.add, color: Colors.white),
          backgroundColor: iconsColor,
          onTap: () {
            // reset background color when form is closed
            ref.read(backgroundColorProvider.notifier).state = Colors.white;
            showDialog(
              context: context,
              builder: (BuildContext ctx) => const TransactionGroupSelection(),
            ).whenComplete(() {});
          },
        ),
      ],
    );
  }
}
