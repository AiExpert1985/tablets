import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:tablets/generated/l10n.dart';
import 'package:tablets/src/common_widgets/main_layout/app_bar/main_app_bar.dart';
import 'package:tablets/src/common_widgets/main_layout/drawer/main_drawer.dart';
import 'package:tablets/src/features/categories/controller/category_form_controller.dart';
import 'package:tablets/src/common_widgets/various/image_with_title.dart';
import 'package:tablets/src/features/categories/controller/category_search_controller.dart';
import 'package:tablets/src/features/categories/repository/category_repository_provider.dart';
import 'package:tablets/src/features/categories/model/product_category.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categoryController = ref.watch(categoryControllerProvider);
    final categoriesStream = ref.watch(categoryStreamProvider);
    ref.watch(categorySearchedTextProvider);
    return Scaffold(
      appBar: const MainAppBar(),
      floatingActionButton: FloatingActionButton(
        onPressed: () => categoryController.showCategoryCreateForm(context),
        child: const Icon(Icons.add),
      ),
      drawer: const MainDrawer(),
      body: Container(
        padding: const EdgeInsets.all(30),
        child: Column(
          children: [
            SearchBar(
                onChanged: (userInput) {
                  ref
                      .read(categorySearchedTextProvider.notifier)
                      .update((state) => userInput.trim());
                },
                hintText: S.of(context).search),
            Gap(MediaQuery.of(context).size.width * 0.01),
            categoriesStream.when(
              data: (querySnapshot) {
                return Expanded(
                  child: GridView.builder(
                    itemCount: querySnapshot.docs.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 6,
                      mainAxisSpacing: 10,
                      crossAxisSpacing: 10,
                    ),
                    itemBuilder: (ctx, index) {
                      final documentSnapshot = querySnapshot.docs[index];
                      // Access data from the document
                      final data = documentSnapshot.data();
                      final category = ProductCategory(
                          name: data[ProductCategory.dbKeyName]!,
                          imageUrl: data[ProductCategory.dbKeyImageUrl]);
                      return InkWell(
                        hoverColor: const Color.fromARGB(255, 173, 170, 170),
                        onTap: () => ref
                            .read(categoryControllerProvider)
                            .showCategoryUpdateForm(ctx, category),
                        child: ImageWithTitle(
                          imageUrl: category.imageUrl,
                          title: category.name,
                        ),
                      );
                    },
                  ),
                );
              },
              error: (error, stackTrace) => Text('Error: $error'),
              loading: () => const CircularProgressIndicator(),
            ),
          ],
        ),
      ),
    );
  }
}
