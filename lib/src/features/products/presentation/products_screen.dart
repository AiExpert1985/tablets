import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tablets/generated/l10n.dart';
import 'package:tablets/src/common_widgets/main_app_bar/main_app_bar.dart';
import 'package:tablets/src/common_widgets/main_drawer/main_drawer.dart';
import 'package:tablets/src/features/products/presentation/add_product_dialog.dart';

class ProductsScreen extends ConsumerWidget {
  const ProductsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: const MainAppBar(),
      floatingActionButton: FloatingActionButton(
        onPressed: () => showDialog(
          context: context,
          builder: (BuildContext context) => const AddProductDialog(),
        ),
        child: const Icon(Icons.add),
      ),
      drawer: const MainDrawer(),
      body: const Center(
          child: Text('Products Screen', style: TextStyle(fontSize: 20))),
    );
  }
}
