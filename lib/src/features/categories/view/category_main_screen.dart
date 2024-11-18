import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tablets/src/common/widgets/main_frame.dart';
import 'package:tablets/src/features/categories/view/category_items_grid.dart';
import 'package:tablets/src/features/categories/view/category_floating_buttons.dart';

class CategoriesScreen extends ConsumerWidget {
  const CategoriesScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return const AppScreenFrame(
      CategoriesGrid(),
      buttonsWidget: CategoryFloatingButtons(),
    );
  }
}
