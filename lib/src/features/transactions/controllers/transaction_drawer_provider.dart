import 'package:anydrawer/anydrawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tablets/generated/l10n.dart';
import 'package:tablets/src/common/widgets/dialog_report.dart';
import 'package:tablets/src/features/products/view/product_drawer_filters.dart';
import 'package:tablets/src/features/transactions/controllers/transaction_reports_util.dart';

class TransactionDrawer {
  final AnyDrawerController drawerController = AnyDrawerController();

  void showSearchForm(BuildContext context) {
    showDrawer(
      context,
      builder: (context) {
        return const Center(
          child: SafeArea(
            top: true,
            child: ProductSearchForm(),
          ),
        );
      },
      config: const DrawerConfig(
        side: DrawerSide.left,
        widthPercentage: 0.3,
        dragEnabled: false,
        closeOnClickOutside: true,
        backdropOpacity: 0.3,
      ),
      onOpen: () {},
      onClose: () {},
      controller: drawerController,
    );
  }

  void showReports(BuildContext context, List<Map<String, dynamic>> allTransactions) {
    showDrawer(
      context,
      builder: (context) {
        return Center(
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            _buildDailyIncome(context, allTransactions),
          ]),
        );
      },
      config: const DrawerConfig(
        side: DrawerSide.left,
        widthPercentage: 0.2,
        dragEnabled: false,
        closeOnClickOutside: true,
        backdropOpacity: 0.3,
        borderRadius: 10,
      ),
      onOpen: () {},
      onClose: () {},
      controller: drawerController,
    );
  }

  Widget _buildDailyIncome(BuildContext context, List<Map<String, dynamic>> allTransactions) {
    List<List<dynamic>> incomeTransactions = getIncomeTransactions(context, allTransactions);
    List<String> reportTitles = getTransactionIncomeReportTitles(context);
    List<String> transactionTypeDropdown = getTransactionTypeDropList(context);
    return InkWell(
      child: Text(S.of(context).daily_income),
      onTap: () {
        // Close the drawer when the button is tapped
        drawerController.close();
        // Show the daily income report dialog
        showReportDialog(
          context,
          reportTitles,
          incomeTransactions,
          title: S.of(context).daily_income,
          dateIndex: 1,
          sumIndex: 4,
          dropdownList: transactionTypeDropdown,
          dropdownLabel: S.of(context).transaction_type,
          dropdownIndex: 0,
        );
      },
    );
  }
}

final transactionDrawerControllerProvider = Provider<TransactionDrawer>((ref) {
  return TransactionDrawer();
});
