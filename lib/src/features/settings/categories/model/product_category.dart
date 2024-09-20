import 'package:tablets/src/constants/constants.dart';

class ProductCategory {
  ProductCategory(
      {required this.name, this.imageUrl = DefaultImageUrl.defaultItemUrl});
  String name;
  String? imageUrl;
}
