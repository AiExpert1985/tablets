import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:tablets/src/common/constants/constants.dart' as constants;

class ProductCategory {
  String dbKey;
  String name;
  List<String> imageUrls;

  ProductCategory({
    required this.dbKey,
    required this.name,
    required this.imageUrls,
  });

  String get coverImage => imageUrls.isNotEmpty ? imageUrls[imageUrls.length - 1] : constants.defaultImageUrl;

  List<String> get imageUrlsOrDefault => imageUrls.isNotEmpty ? imageUrls : [constants.defaultImageUrl];

  ProductCategory copyWith({
    String? dbKey,
    String? name,
    List<String>? imageUrls,
  }) {
    return ProductCategory(
      dbKey: dbKey ?? this.dbKey,
      name: name ?? this.name,
      imageUrls: imageUrls ?? this.imageUrls,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'dbKey': dbKey,
      'name': name,
      'imageUrls': imageUrls,
    };
  }

  factory ProductCategory.fromMap(Map<String, dynamic> map) {
    return ProductCategory(
      dbKey: map['dbKey'] ?? '',
      name: map['name'] ?? '',
      imageUrls: List<String>.from(map['imageUrls']),
    );
  }

  String toJson() => json.encode(toMap());

  factory ProductCategory.fromJson(String source) => ProductCategory.fromMap(json.decode(source));

  @override
  String toString() => 'ProductCategory(name: $name, imageUrls: $imageUrls)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ProductCategory && other.name == name && listEquals(other.imageUrls, imageUrls);
  }

  @override
  int get hashCode => name.hashCode ^ imageUrls.hashCode;
}
