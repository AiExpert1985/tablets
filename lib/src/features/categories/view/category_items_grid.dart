import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tablets/src/common/widgets/async_value_widget.dart';
import 'package:tablets/src/common/widgets/image_titled.dart';
import 'package:tablets/src/features/categories/controllers/category_filter_controllers.dart';
import 'package:tablets/src/features/categories/controllers/category_filter_switch_data_provider.dart';
import 'package:tablets/src/features/categories/controllers/category_form_controllers.dart';
import 'package:tablets/src/features/categories/model/category.dart';
import 'package:tablets/src/features/categories/repository/category_stream_provider.dart';

class CategoriesGrid extends ConsumerWidget {
  const CategoriesGrid({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productStream = ref.watch(categoriesStreamProvider);
    final formController = ref.watch(categoryFormControllerProvider);
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
            onTap: () => formController.showForm(ctx, category: category),
            child: TitledImage(
              imageUrl: category.imageUrls[category.imageUrls.length - 1],
              title: category.name,
            ),
          );
        },
      ),
    );
  }
}
