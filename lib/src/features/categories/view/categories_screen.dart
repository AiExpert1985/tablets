import 'package:animated_search_bar/animated_search_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tablets/generated/l10n.dart';
import 'package:tablets/src/common_widgets/main_frame.dart';
import 'package:tablets/src/features/categories/controller/category_controller.dart';
import 'package:tablets/src/features/categories/controller/searched_name_provider.dart';
import 'package:tablets/src/features/categories/view/categories_grid_widget.dart';

class CategoriesScreen extends ConsumerWidget {
  const CategoriesScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categoryController = ref.watch(categoryControllerProvider);
    return AppScreenFrame(
      screenBody: Column(
        children: [
          Center(
            child: SizedBox(
              width: MediaQuery.of(context).size.width * 0.25,
              child: AnimatedSearchBar(
                  // label: S.of(context).search,
                  onChanged: (userInput) {
                    // searchedText can be either caracters or null
                    ref.read(searchedNameProvider.notifier).state =
                        userInput.trim() == '' ? null : userInput.trim();
                  },
                  searchDecoration: InputDecoration(
                    labelText: S.of(context).search,
                    alignLabelWithHint: true,
                    contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                    border: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                    ),
                  )),
            ),
          ),
          SizedBox(height: MediaQuery.of(context).size.width * 0.01),
          const CategoriesGrid(),
          FloatingActionButton(
            onPressed: () => categoryController.showAddCategoryForm(context),
            child: const Icon(Icons.add),
          ),
        ],
      ),
    );
  }
}
