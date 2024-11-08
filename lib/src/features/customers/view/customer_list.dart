import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tablets/src/common/classes/db_repository.dart';
import 'package:tablets/src/common/functions/utils.dart';
import 'package:tablets/src/common/providers/image_picker_provider.dart';
import 'package:tablets/src/common/widgets/async_value_widget.dart';
import 'package:tablets/src/features/customers/controllers/customer_filter_controller_.dart';
import 'package:tablets/src/features/customers/controllers/customer_filtered_list.dart';
import 'package:tablets/src/features/customers/controllers/customer_form_controller.dart';
import 'package:tablets/src/features/customers/model/customer.dart';
import 'package:tablets/src/features/customers/repository/customer_repository_provider.dart';
import 'package:tablets/src/features/customers/utils/customer_total_debt.dart';
import 'package:tablets/src/features/customers/view/customer_form.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:tablets/generated/l10n.dart';
import 'package:tablets/src/common/classes/item_form_data.dart';
import 'package:tablets/src/common/values/constants.dart';
import 'package:tablets/src/features/transactions/repository/transaction_repository_provider.dart';

List<Map<String, dynamic>> _transactions = [];

Future<void> _fetchTransactions(DbRepository transactionProvider) async {
  _transactions = await transactionProvider.fetchItemListAsMaps();
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
    data: (transactions) {
      return Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildHeaderRow(context),
            const SizedBox(height: 19),
            _buildHorizontalLine(), // Add some space between header and data
            Expanded(
              child: ListView.builder(
                itemCount: transactions.length,
                itemBuilder: (context, index) {
                  final customer = Customer.fromMap(transactions[index]);
                  return _buildDataRow(
                      customer, context, imagePickerNotifier, formDataNotifier, _transactions);
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
      Expanded(child: _buildHeader(S.of(context).customer)),
      Expanded(child: _buildHeader(S.of(context).salesman_selection)),
      Expanded(child: _buildHeader(S.of(context).current_debt)),
    ],
  );
}

Widget _buildDataRow(
  Customer customer,
  BuildContext context,
  ImageSliderNotifier imagePickerNotifier,
  ItemFormData formDataNotifier,
  List<Map<String, dynamic>> transactions,
) {
  return Column(
    children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: InkWell(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const CircleAvatar(
                    radius: 15,
                    foregroundImage: CachedNetworkImageProvider(defaultImageUrl),
                  ),
                  const SizedBox(width: 8),
                  Text(customer.name),
                ],
              ),
              onTap: () =>
                  _showEditCustomerForm(context, formDataNotifier, imagePickerNotifier, customer),
            ),
          ),
          Expanded(child: _buildDataCell(customer.salesman)),
          Expanded(
              child:
                  _buildDataCell(doubleToString(calculateTotalDebt(transactions, customer.dbRef))))
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
