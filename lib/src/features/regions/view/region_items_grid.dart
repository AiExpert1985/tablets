import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tablets/src/common/providers/image_picker_provider.dart';
import 'package:tablets/src/common/widgets/async_value_widget.dart';
import 'package:tablets/src/common/widgets/image_titled.dart';
import 'package:tablets/src/features/regions/controllers/region_filter_controller_.dart';
import 'package:tablets/src/features/regions/controllers/region_filtered_list.dart';
import 'package:tablets/src/features/regions/controllers/region_form_controller.dart';
import 'package:tablets/src/features/regions/model/region.dart';
import 'package:tablets/src/features/regions/repository/region_repository_provider.dart';
import 'package:tablets/src/features/regions/view/region_form.dart';

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
    final filterIsOn = ref.watch(regionFilterSwitchProvider);
    final regionsListValue = filterIsOn ? ref.read(regionFilteredListProvider).getFilteredList() : productStream;
    return AsyncValueWidget<List<Map<String, dynamic>>>(
      value: regionsListValue,
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
