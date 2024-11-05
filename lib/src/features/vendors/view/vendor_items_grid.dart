import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tablets/src/common/providers/image_picker_provider.dart';
import 'package:tablets/src/common/widgets/async_value_widget.dart';
import 'package:tablets/src/common/widgets/image_titled.dart';
import 'package:tablets/src/features/vendors/controllers/vendor_filter_controller_.dart';
import 'package:tablets/src/features/vendors/controllers/vendor_filtered_list.dart';
import 'package:tablets/src/features/vendors/controllers/vendor_form_controller.dart';
import 'package:tablets/src/features/vendors/model/vendor.dart';
import 'package:tablets/src/features/vendors/repository/vendor_repository_provider.dart';
import 'package:tablets/src/features/vendors/view/vendor_form.dart';

class VendorGrid extends ConsumerWidget {
  const VendorGrid({super.key});

  void showEditVendorForm(BuildContext context, WidgetRef ref, Vendor vendor) {
    ref.read(vendorFormDataProvider.notifier).initialize(initialData: vendor.toMap());
    final imagePicker = ref.read(imagePickerProvider.notifier);
    imagePicker.initialize(urls: vendor.imageUrls);
    showDialog(
      context: context,
      builder: (BuildContext ctx) => const VendorForm(
        isEditMode: true,
      ),
    ).whenComplete(imagePicker.close);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final vendortStream = ref.watch(vendorStreamProvider);
    final filterIsOn = ref.watch(vendorFilterSwitchProvider);
    final vendorListValue =
        filterIsOn ? ref.read(vendorFilteredListProvider).getFilteredList() : vendortStream;
    return AsyncValueWidget<List<Map<String, dynamic>>>(
      value: vendorListValue,
      data: (categories) => GridView.builder(
        itemCount: categories.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 8,
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
        ),
        itemBuilder: (ctx, index) {
          final vendor = Vendor.fromMap(categories[index]);
          return InkWell(
            hoverColor: const Color.fromARGB(255, 173, 170, 170),
            onTap: () => showEditVendorForm(ctx, ref, vendor),
            child: TitledImage(
              imageUrl: vendor.coverImageUrl,
              title: vendor.name,
            ),
          );
        },
      ),
    );
  }
}
