import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:tablets/src/common/providers/image_picker_provider.dart';
// import 'package:tablets/src/features/categories/view/category_form.dart';
import 'package:tablets/src/features/salesmen/controllers/salesman_drawer_provider.dart';
import 'package:tablets/src/features/salesmen/controllers/salesman_form_controller.dart';

class SalesmanFloatingButtons extends ConsumerWidget {
  const SalesmanFloatingButtons({super.key});

  void showAddSalesmanForm(BuildContext context, WidgetRef ref) {
    ref.read(salesmanFormDataProvider.notifier).initialize();
    final imagePicker = ref.read(imagePickerProvider.notifier);
    imagePicker.initialize();
    showDialog(
      context: context,
      builder: (BuildContext ctx) => const SalesmanForm(),
    ).whenComplete(imagePicker.close);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final drawerController = ref.watch(salesmanDrawerControllerProvider);
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
          onTap: () => showAddSalesmanForm(context, ref),
        ),
      ],
    );
  }
}
