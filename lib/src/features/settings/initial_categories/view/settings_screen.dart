import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tablets/src/common_widgets/main_app_bar/main_app_bar.dart';
import 'package:tablets/src/common_widgets/main_drawer/main_drawer.dart';
import 'package:tablets/src/features/settings/initial_categories/controller/init_category_db_controller.dart';
import 'package:tablets/src/features/settings/initial_categories/view/add_category_dialog.dart';
import 'package:tablets/src/temporary/image_for_test.dart';

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
                  crossAxisCount: 5,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                ),
                itemBuilder: (context, index) {
                  final documentSnapshot = querySnapshot.docs[index];
                  // Access data from the document
                  final data = documentSnapshot.data();
                  return CategoryItem(
                    imageUrl: data['imageUrl']!,
                    title: data['category']!,
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
