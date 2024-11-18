import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tablets/src/common/widgets/main_frame.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:tablets/src/common/providers/image_picker_provider.dart';
import 'package:tablets/src/features/vendors/controllers/vendor_drawer_provider.dart';
import 'package:tablets/src/features/vendors/controllers/vendor_form_controller.dart';
import 'package:tablets/src/features/vendors/view/vendor_form.dart';
import 'package:tablets/src/common/widgets/async_value_widget.dart';
import 'package:tablets/src/common/widgets/image_titled.dart';
import 'package:tablets/src/features/vendors/controllers/vendor_filter_controller_.dart';
import 'package:tablets/src/features/vendors/controllers/vendor_filtered_list.dart';
import 'package:tablets/src/features/vendors/model/vendor.dart';
import 'package:tablets/src/features/vendors/repository/vendor_repository_provider.dart';

class VendorScreen extends ConsumerWidget {
  const VendorScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return const AppScreenFrame(
      VendorGrid(),
      buttonsWidget: VendorFloatingButtons(),
    );
  }
}

class VendorFloatingButtons extends ConsumerWidget {
  const VendorFloatingButtons({super.key});

  void showAddVendorForm(BuildContext context, WidgetRef ref) {
    final formDataNotifier = ref.read(vendorFormDataProvider.notifier);
    formDataNotifier.initialize();
    formDataNotifier.updateProperties({
      'initialDate': DateTime.now(),
    });
    final imagePicker = ref.read(imagePickerProvider.notifier);
    imagePicker.initialize();
    showDialog(
      context: context,
      builder: (BuildContext ctx) => const VendorForm(),
    ).whenComplete(imagePicker.close);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final drawerController = ref.watch(vendorDrawerControllerProvider);
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
          onTap: () => drawerController.showReports(context),
        ),
        SpeedDialChild(
          child: const Icon(Icons.search, color: Colors.white),
          backgroundColor: iconsColor,
          onTap: () => drawerController.showSearchForm(context),
        ),
        SpeedDialChild(
          child: const Icon(Icons.add, color: Colors.white),
          backgroundColor: iconsColor,
          onTap: () => showAddVendorForm(context, ref),
        ),
      ],
    );
  }
}

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
