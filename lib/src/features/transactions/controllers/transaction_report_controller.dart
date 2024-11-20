import 'package:anydrawer/anydrawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tablets/generated/l10n.dart';
import 'package:tablets/src/common/functions/utils.dart';
import 'package:tablets/src/common/values/constants.dart';
import 'package:tablets/src/common/widgets/dialog_report.dart';
import 'package:tablets/src/common/widgets/report_widgets.dart';
import 'package:tablets/src/features/transactions/model/transaction.dart';

final transactionReportControllerProvider = Provider<TransactionReportController>((ref) {
  return TransactionReportController();
});

class TransactionReportController {
  TransactionReportController();

  Widget buildReportWidgets(
    BuildContext context,
    List<Map<String, dynamic>> transactions,
    AnyDrawerController drawerController,
  ) {
    final title = S.of(context).transaction_reports;
    final buttons = [
      _buildDailyIncomeButton(context, transactions, drawerController),
      _buildProfitButton(context, transactions, drawerController),
    ];
    return ReportColumn(
      title: title,
      buttons: buttons,
    );
  }

// returns [type, date, number, name, amount, salesman]
  List<List<dynamic>> _getIncomeTransactions(
      BuildContext context, List<Map<String, dynamic>> allTransactions) {
    List<List<dynamic>> incomeTransactions = [];
    for (var trans in allTransactions) {
      final transaction = Transaction.fromMap(trans);
      final type = transaction.transactionType;
      if (type == TransactionType.customerReceipt.name) {
        incomeTransactions.add([
          transaction,
          translateDbTextToScreenText(context, type),
          transaction.date,
          transaction.number,
          transaction.name,
          transaction.totalAmount,
          transaction.salesman
        ]);
      } else if (type == TransactionType.vendorReceipt.name ||
          type == TransactionType.expenditures.name) {
        incomeTransactions.add([
          transaction,
          translateDbTextToScreenText(context, type),
          transaction.date,
          transaction.number,
          transaction.name,
          -transaction.totalAmount,
          ''
        ]);
      }
    }
    return incomeTransactions;
  }

  List<String> _getTransactionIncomeReportTitles(BuildContext context) {
    return [
      S.of(context).transaction_type,
      S.of(context).transaction_date,
      S.of(context).transaction_number,
      S.of(context).transaction_name,
      S.of(context).transaction_amount,
      S.of(context).transaction_salesman
    ];
  }

  List<String> _getTransactionTypeDropList(BuildContext context) {
    return [
      translateDbTextToScreenText(context, TransactionType.customerInvoice.name),
      translateDbTextToScreenText(context, TransactionType.customerReceipt.name),
      translateDbTextToScreenText(context, TransactionType.customerReturn.name),
      translateDbTextToScreenText(context, TransactionType.vendorInvoice.name),
      translateDbTextToScreenText(context, TransactionType.vendorReceipt.name),
      translateDbTextToScreenText(context, TransactionType.vendorReturn.name),
      translateDbTextToScreenText(context, TransactionType.gifts.name),
      translateDbTextToScreenText(context, TransactionType.expenditures.name),
    ];
  }

  Widget _buildDailyIncomeButton(BuildContext context, List<Map<String, dynamic>> allTransactions,
      AnyDrawerController drawerController) {
    List<List<dynamic>> incomeTransactions = _getIncomeTransactions(context, allTransactions);
    List<String> reportTitles = _getTransactionIncomeReportTitles(context);
    List<String> transactionTypeDropdown = _getTransactionTypeDropList(context);
    return InkWell(
      child: ReportButton(S.of(context).daily_income_report),
      onTap: () {
        // Close the drawer when the button is tapped
        drawerController.close();
        // Show the daily income report dialog
        showReportDialog(
          context,
          reportTitles,
          incomeTransactions,
          title: S.of(context).daily_income,
          dateIndex: 2,
          sumIndex: 5,
          dropdownList: transactionTypeDropdown,
          dropdownLabel: S.of(context).transaction_type,
          dropdownIndex: 1,
          useOriginalTransaction: true,
        );
      },
    );
  }

  Widget _buildProfitButton(BuildContext context, List<Map<String, dynamic>> allTransactions,
      AnyDrawerController drawerController) {
    return InkWell(
      child: ReportButton(S.of(context).monthly_profit_report),
      onTap: () {
        // Close the drawer when the button is tapped
        drawerController.close();
      },
    );
  }
}
