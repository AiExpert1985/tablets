import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tablets/generated/l10n.dart';
import 'package:tablets/src/common_widgets/main_app_bar/main_app_bar.dart';
import 'package:tablets/src/common_widgets/main_drawer/main_drawer.dart';
import 'package:tablets/src/features/settings/presentation/controller/category_controller.dart';
import 'package:tablets/src/features/settings/presentation/view/add_category_dialog.dart';
import 'package:tablets/src/temporary/image_for_test.dart';
import 'package:tablets/src/utils/utils.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.read(categoryControllerProvider).fetchAllCategories();
    final categories = ref.read(categoryControllerProvider).categories;
    CustomDebug.print(categories);
    Widget screenContent;
    if (categories.isEmpty) {
      screenContent = Text(S.of(context).screen_is_empty,
          style: const TextStyle(fontSize: 25));
    } else {
      screenContent = GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 5, // Adjust the number of columns as needed
          // crossAxisSpacing: 2,
          // mainAxisSpacing: 2,
        ),
        itemCount: categories.length,
        itemBuilder: (BuildContext ctx, int index) {
          return CategoryItem(
              imageUrl: categories[index]['downloadedUrl']!,
              title: categories[index]['fileName']!);
        },
      );
    }
    return Scaffold(
      appBar: const MainAppBar(),
      floatingActionButton: FloatingActionButton(
        onPressed: () => showDialog(
          context: context,
          builder: (BuildContext context) => const AddCategoryDialog(),
        ),
        child: const Icon(Icons.add),
      ),
      drawer: const MainDrawer(),
      body: Container(
        padding: const EdgeInsets.all(30),
        child: Center(
          child: screenContent,
        ),
      ),
    );
  }
}
