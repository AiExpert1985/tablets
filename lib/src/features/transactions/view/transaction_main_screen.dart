import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tablets/src/common/widgets/main_frame.dart';
import 'package:tablets/src/features/transactions/view/transaction_floating_buttons.dart';
import 'package:tablets/src/features/transactions/view/transaction_list.dart';

class TransactionsScreen extends ConsumerWidget {
  const TransactionsScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return const AppScreenFrame(
      screenBody: Stack(
        children: [
          TransactionsList(),
          Positioned(
            bottom: 0,
            left: 0,
            child: TransactionsFloatingButtons(),
          )
        ],
      ),
    );
  }
}
