import 'package:tablets/src/constants/constants.dart' as constants;

enum ProductCategoryDbKeys { name, imageUrl }

class ProductCategory {
  ProductCategory({required this.name, required this.imageUrl});
  String name;
  String imageUrl;

  void setDefaultValues() {
    name = 'New Category';
    imageUrl = constants.DefaultImage.imageUrl;
  }

  // I use the two variables to avoid using strings for db keys when using documents
  // create, update & delete
  static final String dbKeyName = ProductCategoryDbKeys.name.name;
  static final String dbKeyImageUrl = ProductCategoryDbKeys.imageUrl.name;
}
