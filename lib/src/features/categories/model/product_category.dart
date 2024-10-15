import 'package:tablets/src/constants/constants.dart' as constants;

class ProductCategory {
  String name;
  String imageUrl;
  ProductCategory({required this.name, required this.imageUrl});

  // a second constructor
  ProductCategory.defaultValues()
      : name = 'temp category',
        imageUrl = constants.defaultImageUrl;

  factory ProductCategory.fromMap(Map<String, dynamic> map) {
    return ProductCategory(
      name: map['name'],
      imageUrl: map['imageUrl'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'imageUrl': imageUrl,
    };
  }

  ProductCategory copyWith({String? name, String? imageUrl}) {
    return ProductCategory(name: name ?? this.name, imageUrl: imageUrl ?? this.imageUrl);
  }

  @override
  String toString() => 'Category $name';
}
