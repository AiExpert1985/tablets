import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:tablets/src/features/category/controllers/drawer_provider.dart';
import 'package:tablets/src/features/category/controllers/form_controllers.dart';

class CategoryFloatingButtons extends ConsumerWidget {
  const CategoryFloatingButtons({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formController = ref.watch(categoryFormControllerProvider);
    final drawerController = ref.watch(categoryDrawerControllerProvider);
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
          onTap: () => formController.showAddForm(context),
        ),
      ],
    );
  }
}
