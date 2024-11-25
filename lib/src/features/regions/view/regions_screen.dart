import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tablets/src/common/widgets/main_frame.dart';
import 'package:tablets/src/common/providers/image_picker_provider.dart';
import 'package:tablets/src/common/widgets/async_value_widget.dart';
import 'package:tablets/src/common/widgets/image_titled.dart';
import 'package:tablets/src/features/regions/controllers/region_form_controller.dart';
import 'package:tablets/src/features/regions/model/region.dart';
import 'package:tablets/src/features/regions/repository/region_repository_provider.dart';
import 'package:tablets/src/features/regions/view/region_form.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

class RegionsScreen extends ConsumerWidget {
  const RegionsScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return const AppScreenFrame(
      RegionsGrid(),
      buttonsWidget: RegionFloatingButtons(),
    );
  }
}

class RegionsGrid extends ConsumerWidget {
  const RegionsGrid({super.key});

  void showEditRegionForm(BuildContext context, WidgetRef ref, Region region) {
    ref.read(regionFormDataProvider.notifier).initialize(initialData: region.toMap());
    final imagePicker = ref.read(imagePickerProvider.notifier);
    imagePicker.initialize(urls: region.imageUrls);
    showDialog(
      context: context,
      builder: (BuildContext ctx) => const RegionForm(isEditMode: true),
    ).whenComplete(imagePicker.close);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productStream = ref.watch(regionStreamProvider);
    return AsyncValueWidget<List<Map<String, dynamic>>>(
      value: productStream,
      data: (regions) => GridView.builder(
        itemCount: regions.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 8,
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
        ),
        itemBuilder: (ctx, index) {
          final region = Region.fromMap(regions[index]);
          return InkWell(
            hoverColor: const Color.fromARGB(255, 173, 170, 170),
            onTap: () => showEditRegionForm(ctx, ref, region),
            child: TitledImage(
              imageUrl: region.coverImageUrl,
              title: region.name,
            ),
          );
        },
      ),
    );
  }
}

class RegionFloatingButtons extends ConsumerWidget {
  const RegionFloatingButtons({super.key});

  void showAddRegionForm(BuildContext context, WidgetRef ref) {
    ref.read(regionFormDataProvider.notifier).initialize();
    final imagePicker = ref.read(imagePickerProvider.notifier);
    imagePicker.initialize();
    showDialog(
      context: context,
      builder: (BuildContext ctx) => const RegionForm(),
    ).whenComplete(imagePicker.close);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // final drawerController = ref.watch(regionDrawerControllerProvider);
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
        // SpeedDialChild(
        //   child: const Icon(Icons.pie_chart, color: Colors.white),
        //   backgroundColor: iconsColor,
        //   onTap: () => drawerController.showReports(context),
        // ),
        // SpeedDialChild(
        //   child: const Icon(Icons.search, color: Colors.white),
        //   backgroundColor: iconsColor,
        //   onTap: () => drawerController.showSearchForm(context),
        // ),
        SpeedDialChild(
          child: const Icon(Icons.add, color: Colors.white),
          backgroundColor: iconsColor,
          onTap: () => showAddRegionForm(context, ref),
        ),
      ],
    );
  }
}
