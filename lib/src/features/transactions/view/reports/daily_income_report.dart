import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart'; // Make sure to add this dependency in pubspec.yaml
import 'package:intl/intl.dart';
import 'package:tablets/generated/l10n.dart';
import 'package:tablets/src/common/functions/utils.dart';
import 'package:tablets/src/common/values/constants.dart';
import 'package:tablets/src/common/values/gaps.dart';
import 'package:tablets/src/common/values/transactions_common_values.dart';

class DailyIncomeReport extends StatefulWidget {
  const DailyIncomeReport(this.allTransactions, {super.key});
  final List<Map<String, dynamic>> allTransactions;

  @override
  DailyIncomeReportState createState() => DailyIncomeReportState();
}

class DailyIncomeReportState extends State<DailyIncomeReport> {
  DateTime? startDate;
  DateTime? endDate;
  double income = 0;
  List<Map<String, dynamic>> filteredTransactions = [];

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        S.of(context).daily_income,
        textAlign: TextAlign.center,
      ),
      alignment: Alignment.center,
      scrollable: true,
      content: Container(
        padding: const EdgeInsets.all(25),
        width: 300,
        height: 300,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            FormBuilder(
              child: Column(
                children: [
                  FormBuilderDateTimePicker(
                    name: 'start_date',
                    decoration: InputDecoration(
                      labelText: S.of(context).from_date,
                      border: const OutlineInputBorder(),
                    ),
                    initialValue: startDate,
                    inputType: InputType.date, // Set to date only
                    format: DateFormat('dd-MM-yyyy'),
                    onChanged: (value) {
                      setState(() {
                        startDate = value;
                      });
                      _calculateIncome(widget.allTransactions, startDate, endDate);
                    },
                  ),
                  const SizedBox(height: 16),
                  FormBuilderDateTimePicker(
                    name: 'end_date',
                    decoration: InputDecoration(
                      labelText: S.of(context).to_date,
                      border: const OutlineInputBorder(),
                    ),
                    initialValue: endDate,
                    inputType: InputType.date, // Set to date only
                    format: DateFormat('dd-MM-yyyy'),
                    onChanged: (value) {
                      setState(() {
                        endDate = value;
                      });
                      _calculateIncome(widget.allTransactions, startDate, endDate);
                    },
                  ),
                ],
              ),
            ),
            VerticalGap.xxl,
            InkWell(
              onTap: () {
                _showTransactionsDialog(context);
              },
              child: SizedBox(
                width: 250,
                height: 55,
                child: Center(
                  child: Text(numberToText(income), // Function to convert number to text
                      style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _calculateIncome(List<Map<String, dynamic>> transactions, DateTime? start, DateTime? end) {
    if (start == null || end == null) return;
    // Filter transactions based on the date range
    filteredTransactions = transactions.where((transaction) {
      final transactionDate = transaction[dateKey].toDate();
      return transactionDate.isAfter(start.subtract(const Duration(days: 1))) &&
          transactionDate.isBefore(end.add(const Duration(days: 1)));
    }).toList(); // Store the filtered transactions

    // Calculate income
    double calculatedIncome = filteredTransactions.fold(0, (sum, transaction) {
      final amount = transaction[totalAmountKey];
      final type = transaction[transactionTypeKey];
      if (type == TransactionType.customerReceipt.name) {
        return sum + amount;
      } else if (type == TransactionType.vendorReceipt.name ||
          type == TransactionType.expenditures.name) {
        return sum - amount;
      }
      return sum;
    });

    setState(() {
      income = calculatedIncome; // Update the income variable to reflect the new calculation
    });
  }

  void _showTransactionsDialog(BuildContext context) {
    // First, filter the transactions based on the allowed types
    List<Map<String, dynamic>> displayedTransactions = filteredTransactions.where((transaction) {
      final type = transaction[transactionTypeKey];
      return type == TransactionType.customerReceipt.name ||
          type == TransactionType.vendorReceipt.name ||
          type == TransactionType.expenditures.name;
    }).toList();

    // Sort the displayed transactions based on the date in descending order
    displayedTransactions.sort((a, b) {
      final dateA = a[dateKey].toDate(); // Assuming dateKey is the key for the date
      final dateB = b[dateKey].toDate();
      return dateB.compareTo(dateA); // Descending order
    });

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: SizedBox(
            width: 600, // Adjust width as needed
            height: 400, // Adjust height as needed
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            S.of(context).transaction_type,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            S.of(context).transaction_name, // New column header
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            S.of(context).transaction_date,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            S.of(context).transaction_amount,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            S.of(context).transaction_salesman, // New column header
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const Divider(), // A divider line between the header and the rows
                  // List of Transactions
                  ListView.builder(
                    shrinkWrap: true,
                    physics:
                        const NeverScrollableScrollPhysics(), // Disable scrolling for the inner ListView
                    itemCount: displayedTransactions.length,
                    itemBuilder: (context, index) {
                      final transaction = displayedTransactions[index];
                      final amount = transaction[totalAmountKey];
                      final date = transaction[dateKey].toDate();
                      final type = translateDbString(context, transaction[transactionTypeKey]);
                      final name = transaction['name']; // Assuming 'name' is the key for the name
                      final salesman = transaction[
                          'salesman']; // Assuming 'salesman' is the key for the salesman

                      return Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(type),
                                ),
                              ),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(name ?? ''), // Display name or 'N/A' if null
                                ),
                              ),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(DateFormat('dd-MM-yyyy').format(date)),
                                ),
                              ),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(numberToText(amount)),
                                ),
                              ),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(salesman ?? ''), // Display salesman or 'N/A' if null
                                ),
                              ),
                            ],
                          ),
                          const Divider(thickness: 0.3)
                        ],
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
