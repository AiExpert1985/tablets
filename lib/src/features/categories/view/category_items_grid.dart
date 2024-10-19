import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tablets/src/common/providers/image_picker_provider.dart';
import 'package:tablets/src/common/widgets/async_value_widget.dart';
import 'package:tablets/src/common/widgets/image_titled.dart';
import 'package:tablets/src/features/categories/controllers/category_filtered_list.dart';
import 'package:tablets/src/features/categories/controllers/category_filter_controller_.dart';
import 'package:tablets/src/features/categories/controllers/category_form_controller.dart';
import 'package:tablets/src/features/categories/model/category.dart';
import 'package:tablets/src/features/categories/repository/category_repository_provider.dart';
import 'package:tablets/src/features/categories/view/category_form.dart';

class CategoriesGrid extends ConsumerWidget {
  const CategoriesGrid({super.key});

  void showEditCategoryForm(BuildContext context, WidgetRef ref, ProductCategory category) {
    ref.read(categoryFormDataProvider.notifier).initialize(item: category);
    final imagePicker = ref.read(imagePickerProvider.notifier);
    imagePicker.initialize(urls: category.imageUrls);
    showDialog(
      context: context,
      builder: (BuildContext ctx) => const CategoryForm(
        isEditMode: true,
      ),
    ).whenComplete(imagePicker.close);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productStream = ref.watch(categoryStreamProvider);
    final filterIsOn = ref.watch(categoryFilterSwitchProvider);
    final categoriesListValue =
        filterIsOn ? ref.read(categoryFilteredListProvider).getFilteredList() : productStream;
    return AsyncValueWidget<List<Map<String, dynamic>>>(
      value: categoriesListValue,
      data: (categories) => GridView.builder(
        itemCount: categories.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 7,
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
