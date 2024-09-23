// ignore_for_file: use_build_context_synchronously

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:tablets/src/constants/constants.dart' as constants;
import 'package:tablets/src/features/categories/model/product_category.dart';

/// the controller works with category forms (through its 'formKey') to update its category object
/// and gets images from a 'pickedImageNotifierProvider' where image file is stored when
/// user pick image (inside form)

final currentCategoryProvider = Provider<ProductCategory>((ref) {
  return ProductCategory(
    name: 'New Category',
    imageUrl: constants.DefaultImage.imageUrl,
  );
});
