import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tablets/src/common/providers/image_picker_provider.dart';
import 'package:tablets/src/common/widgets/async_value_widget.dart';
import 'package:tablets/src/common/widgets/image_titled.dart';
import 'package:tablets/src/features/customers/controllers/customer_filter_controller_.dart';
import 'package:tablets/src/features/customers/controllers/customer_filtered_list.dart';
import 'package:tablets/src/features/customers/controllers/customer_form_controller.dart';
import 'package:tablets/src/features/customers/model/customer.dart';
import 'package:tablets/src/features/customers/repository/customer_repository_provider.dart';
import 'package:tablets/src/features/customers/view/customer_form.dart';

class CustomerGrid extends ConsumerWidget {
  const CustomerGrid({super.key});

  void showEditCustomerForm(BuildContext context, WidgetRef ref, Customer customer) {
    ref.read(customerFormDataProvider.notifier).initialize(item: customer);
    final imagePicker = ref.read(imagePickerProvider.notifier);
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
    final customertStream = ref.watch(customerStreamProvider);
    final filterIsOn = ref.watch(customerFilterSwitchProvider);
    final customerListValue = filterIsOn ? ref.read(customerFilteredListProvider).getFilteredList() : customertStream;
    return AsyncValueWidget<List<Map<String, dynamic>>>(
      value: customerListValue,
      data: (categories) => GridView.builder(
        itemCount: categories.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 8,
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
        ),
        itemBuilder: (ctx, index) {
          final customer = Customer.fromMap(categories[index]);
          return InkWell(
            hoverColor: const Color.fromARGB(255, 173, 170, 170),
            onTap: () => showEditCustomerForm(ctx, ref, customer),
            child: TitledImage(
              imageUrl: customer.coverImageUrl,
              title: customer.name,
            ),
          );
        },
      ),
    );
  }
}
