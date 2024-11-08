import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tablets/src/common/classes/db_repository.dart';
import 'package:tablets/src/common/functions/utils.dart';
import 'package:tablets/src/common/providers/image_picker_provider.dart';
import 'package:tablets/src/common/values/gaps.dart';
import 'package:tablets/src/common/widgets/async_value_widget.dart';
import 'package:tablets/src/common/widgets/show_dialog_list.dart';
import 'package:tablets/src/features/customers/controllers/customer_filter_controller_.dart';
import 'package:tablets/src/features/customers/controllers/customer_filtered_list.dart';
import 'package:tablets/src/features/customers/controllers/customer_form_controller.dart';
import 'package:tablets/src/features/customers/model/customer.dart';
import 'package:tablets/src/features/customers/repository/customer_repository_provider.dart';
import 'package:tablets/src/features/customers/utils/customer_utils.dart';
import 'package:tablets/src/features/customers/view/customer_form.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:tablets/generated/l10n.dart';
import 'package:tablets/src/common/classes/item_form_data.dart';
import 'package:tablets/src/common/values/constants.dart';
import 'package:tablets/src/features/transactions/repository/transaction_repository_provider.dart';

List<Map<String, dynamic>> _allTransactions = [];

Future<void> _fetchTransactions(DbRepository transactionProvider) async {
  _allTransactions = await transactionProvider.fetchItemListAsMaps();
}

void _showEditCustomerForm(BuildContext context, ItemFormData formDataNotifier,
    ImageSliderNotifier imagePicker, Customer customer) {
  formDataNotifier.initialize(initialData: customer.toMap());
  imagePicker.initialize(urls: customer.imageUrls);
  showDialog(
    context: context,
    builder: (BuildContext ctx) => const CustomerForm(
      isEditMode: true,
    ),
  ).whenComplete(imagePicker.close);
}

@override
Widget buildCustomerList(BuildContext context, WidgetRef ref) {
  final transactionProvider = ref.read(transactionRepositoryProvider);
  _fetchTransactions(transactionProvider);
  final formDataNotifier = ref.read(customerFormDataProvider.notifier);
  final customertStream = ref.watch(customerStreamProvider);
  final filterIsOn = ref.watch(customerFilterSwitchProvider);
  final imagePickerNotifier = ref.read(imagePickerProvider.notifier);
  final customerListValue =
      filterIsOn ? ref.read(customerFilteredListProvider).getFilteredList() : customertStream;
  return AsyncValueWidget<List<Map<String, dynamic>>>(
    value: customerListValue,
    data: (customers) {
      return Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildHeaderRow(context),
            VerticalGap.l,
            _buildHorizontalLine(), // Add some space between header and data
            Expanded(
              child: ListView.builder(
                itemCount: customers.length,
                itemBuilder: (context, index) {
                  final customer = Customer.fromMap(customers[index]);
                  final customerTransactions =
                      getCustomerTransactions(_allTransactions, customer.dbRef);
                  final totalDebt = getTotalDebt(customerTransactions);
                  final openInvoices = getOpenInvoices(customerTransactions, totalDebt);

                  return _buildDataRow(customer, context, imagePickerNotifier, formDataNotifier,
                      totalDebt, openInvoices);
                },
              ),
            ),
          ],
        ),
      );
    },
  );
}

Widget _buildHeaderRow(BuildContext context) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Expanded(child: _buildHeader('')),
      Expanded(child: _buildHeader(S.of(context).customer)),
      Expanded(child: _buildHeader(S.of(context).salesman_selection)),
      Expanded(child: _buildHeader(S.of(context).current_debt)),
      Expanded(child: _buildHeader(S.of(context).num_open_invoice)),
    ],
  );
}

Widget _buildDataRow(
    Customer customer,
    BuildContext context,
    ImageSliderNotifier imagePickerNotifier,
    ItemFormData formDataNotifier,
    double totalDebt,
    List<List<dynamic>> openInvoices) {
  return Column(
    children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: InkWell(
              child: const CircleAvatar(
                radius: 15,
                foregroundImage: CachedNetworkImageProvider(defaultImageUrl),
              ),
              onTap: () =>
                  _showEditCustomerForm(context, formDataNotifier, imagePickerNotifier, customer),
            ),
          ),
          Expanded(child: _buildDataCell(customer.name)),
          Expanded(child: _buildDataCell(customer.salesman)),
          Expanded(child: _buildDataCell(numberToString(totalDebt))),
          Expanded(
            child: InkWell(
              child: _buildDataCell(numberToString(openInvoices.length)),
              onTap: () {
                final title = '${customer.name} (${openInvoices.length})';
                final columnTitles = [
                  S.of(context).transaction_number,
                  S.of(context).transaction_date,
                  S.of(context).transaction_amount,
                  S.of(context).paid_amount,
                  S.of(context).remaining_amount,
                  S.of(context).receipt_date,
                  S.of(context).receipt_number,
                  S.of(context).receipt_amount,
                ];
                showDialogList(context, title, 800, 400, columnTitles, openInvoices);
              },
            ),
          ),
        ],
      ),
      const SizedBox(height: 4), // Space between row and divider
      _buildHorizontalLine()
    ],
  );
}

Widget _buildDataCell(String text) {
  return Text(
    text,
    textAlign: TextAlign.center,
    style: const TextStyle(fontSize: 16),
  );
}

Widget _buildHeader(String text) {
  return Text(
    text,
    textAlign: TextAlign.center,
    style: const TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.bold,
    ),
  );
}

Widget _buildHorizontalLine() {
  return Container(
    margin: const EdgeInsets.symmetric(vertical: 10),
    height: 1, // Height of the divider
    color: Colors.grey[300], // Light gray color
  );
}

// void _showOpenInvoices(BuildContext context, List<Map<String, dynamic>> dataList) {
//   showDialog(
//     context: context,
//     builder: (BuildContext context) {
//       return AlertDialog(
//         title: Center(child: Text('${S.of(context).num_open_invoice} (${dataList.length})')),
//         content: SizedBox(
//           // Set a fixed height for the dialog content
//           height: 300, // Adjust this height as needed
//           width: 300, // Use max width
//           child: ListView.builder(
//             itemCount: dataList.length,
//             itemBuilder: (context, index) {
//               final data = dataList[index];
//               return Padding(
//                 padding: const EdgeInsets.symmetric(vertical: 5.0),
//                 child: Center(child: Text('Number: ${data['number']}, Amount: ${data['amount']}')),
//               );
//             },
//           ),
//         ),
//         actions: <Widget>[
//           Center(
//             child: IconButton(
//               icon: const CancelIcon(),
//               onPressed: () {
//                 Navigator.of(context).pop();
//               },
//             ),
//           ),
//         ],
//       );
//     },
//   );
// }
