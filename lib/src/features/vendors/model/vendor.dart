import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:tablets/src/common/interfaces/base_item.dart';
import 'package:tablets/src/common/values/constants.dart' as constants;

class Vendor implements BaseItem {
  @override
  String dbKey;
  @override
  String name;
  @override
  List<String> imageUrls;

  Vendor({
    required this.dbKey,
    required this.name,
    required this.imageUrls,
  });

  @override
  String get coverImageUrl =>
      imageUrls.isNotEmpty ? imageUrls[imageUrls.length - 1] : constants.defaultImageUrl;

  @override
  Map<String, dynamic> toMap() {
    return {
      'dbKey': dbKey,
      'name': name,
      'imageUrls': imageUrls,
    };
  }

  factory Vendor.fromMap(Map<String, dynamic> map) {
    return Vendor(
      dbKey: map['dbKey'] ?? '',
      name: map['name'] ?? '',
      imageUrls: List<String>.from(map['imageUrls']),
    );
  }

  String toJson() => json.encode(toMap());

  factory Vendor.fromJson(String source) => Vendor.fromMap(json.decode(source));

  @override
  String toString() => 'ProductCategory(dbKey: $dbKey, name: $name, imageUrls: $imageUrls)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Vendor &&
        other.dbKey == dbKey &&
        other.name == name &&
        listEquals(other.imageUrls, imageUrls);
  }

  @override
  int get hashCode {
    return dbKey.hashCode ^ name.hashCode ^ imageUrls.hashCode;
  }
}
