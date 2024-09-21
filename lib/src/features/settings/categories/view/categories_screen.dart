import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tablets/src/common_providers/image_picker.dart';
import 'package:tablets/src/common_widgets/main_app_bar/main_app_bar.dart';
import 'package:tablets/src/common_widgets/main_drawer/main_drawer.dart';
import 'package:tablets/src/features/settings/categories/controller/category_controller.dart';
import 'package:tablets/src/features/settings/categories/view/create_category_dialog.dart';
import 'package:tablets/src/features/settings/categories/view/category_item_widget.dart';
import 'package:tablets/src/features/settings/categories/model/product_category.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categoriesStream = ref.watch(categoriesStreamProvider);
    return Scaffold(
      appBar: const MainAppBar(),
      floatingActionButton: FloatingActionButton(
        onPressed: () => showDialog(
          context: context,
          builder: (BuildContext context) => const CreateCategoryDialog(),
        ),
        child: const Icon(Icons.add),
      ),
      drawer: const MainDrawer(),
      body: Container(
        padding: const EdgeInsets.all(30),
        child: Center(
          child: categoriesStream.when(
            data: (querySnapshot) {
              return GridView.builder(
                itemCount: querySnapshot.docs.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
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
                    onTap: () {
                      // first update the image in image picker to show current image
                      ref
                          .read(pickedImageNotifierProvider.notifier)
                          .updatePlaceHolderImageUrl(category.imageUrl);
                      // then open the update dialog
                      ref
                          .read(categoryControllerProvider)
                          .showCategoryUpdateForm(ctx, category);
                    },
                    child: CategoryItem(category),
                  );
                },
              );
            },
            error: (error, stackTrace) => Text('Error: $error'),
            loading: () => const CircularProgressIndicator(),
          ),
        ),
      ),
    );
  }
}
