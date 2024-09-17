import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tablets/src/common_widgets/main_app_bar/main_app_bar.dart';
import 'package:tablets/src/common_widgets/main_drawer/main_drawer.dart';
import 'package:tablets/src/features/settings/presentation/view/add_category_dialog.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
      body: Center(
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, // Adjust the number of columns as needed
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
          ),
          itemCount: 20,
          itemBuilder: (BuildContext context, int index) {},
        ),
      ),
    );
  }
}
