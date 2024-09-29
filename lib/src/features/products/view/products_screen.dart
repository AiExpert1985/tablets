import 'package:animated_search_bar/animated_search_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tablets/generated/l10n.dart';
import 'package:tablets/src/common_widgets/main_layout/app_bar/main_app_bar.dart';
import 'package:tablets/src/common_widgets/main_layout/drawer/main_drawer.dart';
import 'package:tablets/src/features/products/controller/products_controller.dart';
import 'package:tablets/src/features/products/view/products_grid.dart';

class ProductsScreen extends ConsumerWidget {
  const ProductsScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productController = ref.watch(productsControllerProvider);

    return Scaffold(
      appBar: const MainAppBar(),
      floatingActionButton: FloatingActionButton(
        onPressed: () => productController.showProductCreateForm(context),
        child: const Icon(Icons.add),
      ),
      drawer: const MainDrawer(),
      body: Container(
        padding: const EdgeInsets.all(30),
        child: Column(
          children: [
            Center(
              child: SizedBox(
                width: MediaQuery.of(context).size.width * 0.25,
                child: AnimatedSearchBar(
                    // label: S.of(context).search,
                    onChanged: (userInput) {
                      // searchedText can be either caracters or null
                      // ref.read(searchedNameProvider.notifier).state =
                      //     userInput.trim() == '' ? null : userInput.trim();
                    },
                    searchDecoration: InputDecoration(
                      labelText: S.of(context).search,
                      alignLabelWithHint: true,
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 8, horizontal: 8),
                      border: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(8)),
                      ),
                    )),
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.width * 0.01),
            const ProductsGrid(),
          ],
        ),
      ),
    );
  }
}
