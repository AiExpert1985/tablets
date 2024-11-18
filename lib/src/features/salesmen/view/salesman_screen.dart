import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tablets/src/common/widgets/main_frame.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:tablets/src/common/providers/image_picker_provider.dart';
import 'package:tablets/src/features/salesmen/controllers/salesman_drawer_provider.dart';
import 'package:tablets/src/features/salesmen/controllers/salesman_form_controller.dart';
import 'package:tablets/src/features/salesmen/view/salesman_form.dart';
import 'package:tablets/src/common/widgets/async_value_widget.dart';
import 'package:tablets/src/common/widgets/image_titled.dart';
import 'package:tablets/src/features/salesmen/controllers/salesman_filter_controller_.dart';
import 'package:tablets/src/features/salesmen/controllers/salesman_filtered_list.dart';
import 'package:tablets/src/features/salesmen/model/salesman.dart';
import 'package:tablets/src/features/salesmen/repository/salesman_repository_provider.dart';

class SalesmanScreen extends ConsumerWidget {
  const SalesmanScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return const AppScreenFrame(
      SalesmanGrid(),
      buttonsWidget: SalesmanFloatingButtons(),
    );
  }
}

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

class SalesmanGrid extends ConsumerWidget {
  const SalesmanGrid({super.key});

  void showEditSalesmanForm(BuildContext context, WidgetRef ref, Salesman salesman) {
    ref.read(salesmanFormDataProvider.notifier).initialize(initialData: salesman.toMap());
    final imagePicker = ref.read(imagePickerProvider.notifier);
    imagePicker.initialize(urls: salesman.imageUrls);
    showDialog(
      context: context,
      builder: (BuildContext ctx) => const SalesmanForm(
        isEditMode: true,
      ),
    ).whenComplete(imagePicker.close);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final salesmantStream = ref.watch(salesmanStreamProvider);
    final filterIsOn = ref.watch(salesmanFilterSwitchProvider);
    final salesmanListValue =
        filterIsOn ? ref.read(salesmanFilteredListProvider).getFilteredList() : salesmantStream;
    return AsyncValueWidget<List<Map<String, dynamic>>>(
      value: salesmanListValue,
      data: (categories) => GridView.builder(
        itemCount: categories.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 8,
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
        ),
        itemBuilder: (ctx, index) {
          final salesman = Salesman.fromMap(categories[index]);
          return InkWell(
            hoverColor: const Color.fromARGB(255, 173, 170, 170),
            onTap: () => showEditSalesmanForm(ctx, ref, salesman),
            child: TitledImage(
              imageUrl: salesman.coverImageUrl,
              title: salesman.name,
            ),
          );
        },
      ),
    );
  }
}
