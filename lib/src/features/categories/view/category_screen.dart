import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tablets/src/common/widgets/home_screen.dart';
import 'package:tablets/src/common/widgets/main_frame.dart';
import 'package:tablets/src/common/providers/image_picker_provider.dart';
import 'package:tablets/src/common/widgets/async_value_widget.dart';
import 'package:tablets/src/common/widgets/image_titled.dart';
import 'package:tablets/src/features/categories/controllers/category_form_controller.dart';
import 'package:tablets/src/features/categories/model/category.dart';
import 'package:tablets/src/features/categories/repository/category_repository_provider.dart';
import 'package:tablets/src/features/categories/view/category_form.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

class CategoriesScreen extends ConsumerWidget {
  const CategoriesScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return const AppScreenFrame(
      CategoriesGrid(),
      buttonsWidget: CategoryFloatingButtons(),
    );
  }
}

class CategoriesGrid extends ConsumerWidget {
  const CategoriesGrid({super.key});

  void showEditCategoryForm(BuildContext context, WidgetRef ref, ProductCategory category) {
    ref.read(categoryFormDataProvider.notifier).initialize(initialData: category.toMap());
    final imagePicker = ref.read(imagePickerProvider.notifier);
    imagePicker.initialize(urls: category.imageUrls);
    showDialog(
      context: context,
      builder: (BuildContext ctx) => const CategoryForm(isEditMode: true),
    ).whenComplete(imagePicker.close);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categorytStream = ref.watch(categoryStreamProvider);
    if (categorytStream.value != null && categorytStream.value!.isEmpty) {
      return const EmptyPage();
    }
    return AsyncValueWidget<List<Map<String, dynamic>>>(
      value: categorytStream,
      data: (categories) => GridView.builder(
        itemCount: categories.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 8,
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
        ),
        itemBuilder: (ctx, index) {
          final category = ProductCategory.fromMap(categories[index]);
          return InkWell(
            hoverColor: const Color.fromARGB(255, 173, 170, 170),
            onTap: () => showEditCategoryForm(ctx, ref, category),
            child: TitledImage(
              imageUrl: category.coverImageUrl,
              title: category.name,
            ),
          );
        },
      ),
    );
  }
}

class CategoryFloatingButtons extends ConsumerWidget {
  const CategoryFloatingButtons({super.key});

  void showAddCategoryForm(BuildContext context, WidgetRef ref) {
    ref.read(categoryFormDataProvider.notifier).initialize();
    final imagePicker = ref.read(imagePickerProvider.notifier);
    imagePicker.initialize();
    showDialog(
      context: context,
      builder: (BuildContext ctx) => const CategoryForm(),
    ).whenComplete(imagePicker.close);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // final drawerController = ref.watch(categoryDrawerControllerProvider);
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
          onTap: () => showAddCategoryForm(context, ref),
        ),
      ],
    );
  }
}
