import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tablets/src/common/widgets/main_frame.dart';
import 'package:tablets/src/features/category/view/category_body_categories_grid.dart';
import 'package:tablets/src/features/category/view/category_body_floating_buttons.dart';

class CategoriesScreen extends ConsumerWidget {
  const CategoriesScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return const AppScreenFrame(
      screenBody: Stack(
        children: [
          CategoriesGrid(),
          Positioned(
            bottom: 0,
            left: 0,
            child: CategoryFloatingButtons(),
          )
        ],
      ),
    );
  }
}
