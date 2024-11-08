import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tablets/src/common/providers/image_picker_provider.dart';
import 'package:tablets/src/common/widgets/async_value_widget.dart';
import 'package:tablets/src/features/customers/controllers/customer_filter_controller_.dart';
import 'package:tablets/src/features/customers/controllers/customer_filtered_list.dart';
import 'package:tablets/src/features/customers/controllers/customer_form_controller.dart';
import 'package:tablets/src/features/customers/model/customer.dart';
import 'package:tablets/src/features/customers/repository/customer_repository_provider.dart';
import 'package:tablets/src/features/customers/view/customer_form.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:tablets/generated/l10n.dart';
import 'package:tablets/src/common/classes/item_form_data.dart';
import 'package:tablets/src/common/values/constants.dart';

class CustomerList extends ConsumerWidget {
  const CustomerList({super.key});

  void showEditCustomerForm(BuildContext context, ItemFormData formDataNotifier,
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
  Widget build(BuildContext context, WidgetRef ref) {
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
                    return _buildDataRow(customer, context, imagePickerNotifier, formDataNotifier);
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
      ],
    );
  }

  Widget _buildDataRow(
    Customer customer,
    BuildContext context,
    ImageSliderNotifier imagePickerNotifier,
    ItemFormData formDataNotifier,
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
                    showEditCustomerForm(context, formDataNotifier, imagePickerNotifier, customer),
              ),
            ),
            Expanded(child: _buildDataCell(customer.salesman)),
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
}
