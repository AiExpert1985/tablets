import 'package:tablets/src/constants/constants.dart';

enum ProductCategoryDbKeys { name, imageUrl }

class ProductCategory {
  ProductCategory(
      {required this.name, this.imageUrl = DefaultImageUrl.defaultItemUrl});
  String name;
  String? imageUrl;

  // I use the two variables to avoid using strings for db keys when using documents
  // create, update & delete
  static String dbKeyName = ProductCategoryDbKeys.name.name;
  static String dbKeyImageUrl = ProductCategoryDbKeys.imageUrl.name;
}
