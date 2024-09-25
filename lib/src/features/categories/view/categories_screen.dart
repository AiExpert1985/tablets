import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:tablets/generated/l10n.dart';
import 'package:tablets/src/common_widgets/main_layout/app_bar/main_app_bar.dart';
import 'package:tablets/src/common_widgets/main_layout/drawer/main_drawer.dart';
import 'package:tablets/src/features/categories/controller/category_controller.dart';
import 'package:tablets/src/features/categories/view/categories_grid_widget.dart';

/// note that this widget only watches the categoryControllerProvider
/// which in turns deal with all other controllers
/// I did that for two reasons:
/// (1) to make it cleaner and easier to debug and update
/// (2) to solve the issue of not begin able to invoke await here when dealing with Future (firebase)
/// in special cases I will include other controllers ?? I will try to prevent that if i can
class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categoryController = ref.watch(categoryControllerProvider);

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
                onChanged: (userInput) {}, hintText: S.of(context).search),
            Gap(MediaQuery.of(context).size.width * 0.01),
            const CategoriesGrid(),
          ],
        ),
      ),
    );
  }
}
