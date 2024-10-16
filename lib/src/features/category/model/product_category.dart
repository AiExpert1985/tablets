import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:tablets/src/common/constants/constants.dart' as constants;

class ProductCategory {
  String name;

  List<String> imageUrls;

  ProductCategory({
    required this.name,
    required this.imageUrls,
  });

  String get coverImage => imageUrls.isNotEmpty ? imageUrls[imageUrls.length - 1] : constants.defaultImageUrl;

  List<String> get imageUrlsOrDefault => imageUrls.isNotEmpty ? imageUrls : [constants.defaultImageUrl];

  ProductCategory copyWith({
    String? name,
    List<String>? imageUrls,
  }) {
    return ProductCategory(
      name: name ?? this.name,
      imageUrls: imageUrls ?? this.imageUrls,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'imageUrls': imageUrls,
    };
  }

  factory ProductCategory.fromMap(Map<String, dynamic> map) {
    return ProductCategory(
        name: map['name'] as String,
        imageUrls: List<String>.from(
          (map['imageUrls'] as List<String>),
        ));
  }

  String toJson() => json.encode(toMap());

  factory ProductCategory.fromJson(String source) =>
      ProductCategory.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'ProductCategory(name: $name, imageUrls: $imageUrls)';

  @override
  bool operator ==(covariant ProductCategory other) {
    if (identical(this, other)) return true;

    return other.name == name && listEquals(other.imageUrls, imageUrls);
  }

  @override
  int get hashCode => name.hashCode ^ imageUrls.hashCode;
}
