import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tablets/src/common_widgets/various/async_value_widget.dart';
import 'package:tablets/src/common_widgets/images/titled_image.dart';
import 'package:tablets/src/features/categories/controller/category_controller.dart';
import 'package:tablets/src/features/categories/model/product_category.dart';
import 'package:tablets/src/features/categories/repository/category_repository_provider.dart';

class CategoriesGrid extends ConsumerWidget {
  const CategoriesGrid({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categoriesListValue = ref.watch(categoriesStreamProvider);
    return AsyncValueWidget<List<ProductCategory>>(
      value: categoriesListValue,
      data: (categories) => Expanded(
        child: GridView.builder(
          itemCount: categories.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 6,
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
          ),
          itemBuilder: (ctx, index) {
            final category = categories[index];
            return InkWell(
              hoverColor: const Color.fromARGB(255, 173, 170, 170),
              onTap: () => ref.read(categoryControllerProvider).showEditCategoryForm(ctx, category),
              child: TitledImage(
                imageUrl: category.imageUrl,
                title: category.name,
              ),
            );
          },
        ),
      ),
    );
  }
}
