import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tablets/generated/l10n.dart';
import 'package:tablets/src/common/values/constants.dart';
import 'package:tablets/src/common/widgets/home_screen.dart';
import 'package:tablets/src/common/widgets/main_frame.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:tablets/src/common/providers/image_picker_provider.dart';
import 'package:tablets/src/common/widgets/main_screen_list_cells.dart';
import 'package:tablets/src/features/vendors/controllers/vendor_drawer_provider.dart';
import 'package:tablets/src/features/vendors/controllers/vendor_form_controller.dart';
import 'package:tablets/src/features/vendors/controllers/vendor_report_controller.dart';
import 'package:tablets/src/features/vendors/controllers/vendor_screen_controller.dart';
import 'package:tablets/src/features/vendors/controllers/vendor_screen_data_provider.dart';
import 'package:tablets/src/features/vendors/repository/vendor_db_cache_provider.dart';
import 'package:tablets/src/features/vendors/view/vendor_form.dart';
import 'package:tablets/src/features/vendors/model/vendor.dart';

class VendorScreen extends ConsumerWidget {
  const VendorScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // I need to read and watch db for one reason, which is hiding floating buttons when
    // page is accessed by refresh and not throught the side bar
    final dbCache = ref.read(vendorDbCacheProvider.notifier).data;
    ref.watch(vendorDbCacheProvider);
    return AppScreenFrame(
      const VendorList(),
      buttonsWidget: dbCache.isEmpty ? null : const VendorFloatingButtons(),
    );
  }
}

class VendorList extends ConsumerWidget {
  const VendorList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dbCache = ref.read(vendorDbCacheProvider.notifier);
    final dbData = dbCache.data;
    ref.watch(vendorDbCacheProvider);
    Widget screenWidget = dbData.isNotEmpty
        ? const Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              children: [
                ListHeaders(),
                Divider(),
                ListData(),
              ],
            ),
          )
        : const HomeScreenGreeting();
    return screenWidget;
  }
}

class ListData extends ConsumerWidget {
  const ListData({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dbCache = ref.read(vendorDbCacheProvider.notifier);
    final dbData = dbCache.data;
    ref.watch(vendorDbCacheProvider);
    return Expanded(
      child: ListView.builder(
        itemCount: dbData.length,
        itemBuilder: (ctx, index) {
          final vendorData = dbData[index];
          return Column(
            children: [
              DataRow(vendorData),
              const Divider(thickness: 0.2, color: Colors.grey),
            ],
          );
        },
      ),
    );
  }
}

class ListHeaders extends StatelessWidget {
  const ListHeaders({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const MainScreenPlaceholder(width: 20, isExpanded: false),
        MainScreenHeaderCell(S.of(context).vendor),
        MainScreenHeaderCell(S.of(context).phone),
        MainScreenHeaderCell(S.of(context).current_debt),
      ],
    );
  }
}

class DataRow extends ConsumerWidget {
  const DataRow(this.vendorData, {super.key});
  final Map<String, dynamic> vendorData;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final vendor = Vendor.fromMap(vendorData);
    final reportController = ref.read(vendorReportControllerProvider);
    final screenController = ref.read(vendorScreenControllerProvider);
    screenController.createVendorScreenData(context, vendorData);
    final screenDataProvider = ref.read(vendorScreenDataProvider);
    final screenData = screenDataProvider.getItemData(vendor.dbRef);
    final name = screenData[vendorNameKey] as String;
    final phone = screenData[vendorPhoneKey] as String;
    final totalDebt = screenData[totalDebtKey] as double;
    final matchingList = screenData[totalDebtDetailsKey] as List<List<dynamic>>;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          MainScreenEditButton(defaultImageUrl, () => _showEditVendorForm(context, ref, vendor)),
          MainScreenTextCell(name),
          MainScreenTextCell(phone),
          MainScreenClickableCell(
            totalDebt,
            () => reportController.showVendorMatchingReport(context, matchingList, name),
          ),
        ],
      ),
    );
  }

  void _showEditVendorForm(BuildContext context, WidgetRef ref, Vendor vendor) {
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
