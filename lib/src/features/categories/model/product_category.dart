import 'package:tablets/src/constants/constants.dart' as constants;

class Category {
  String name;
  String imageUrl;
  Category({required this.name, required this.imageUrl});

  // a second constructor
  Category.defaultValues()
      : name = 'temp category',
        imageUrl = constants.DefaultImage.url;

  factory Category.fromMap(Map<String, dynamic> map) {
    return Category(
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

  Category copyWith({String? name, String? imageUrl}) {
    return Category(
        name: name ?? this.name, imageUrl: imageUrl ?? this.imageUrl);
  }

  @override
  String toString() {
    return 'ProductCategory($name)';
  }
}
