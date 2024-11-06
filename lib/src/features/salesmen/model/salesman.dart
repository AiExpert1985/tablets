import 'package:flutter/foundation.dart';

import 'package:tablets/src/common/values/constants.dart' as constants;
import 'package:tablets/src/common/interfaces/base_item.dart';

class Salesman implements BaseItem {
  @override
  String dbKey;
  @override
  String name;
  @override
  List<String> imageUrls;
  String? phone;

  Salesman({
    required this.dbKey,
    required this.name,
    required this.imageUrls,
    this.phone,
  });

  @override
  String get coverImageUrl => imageUrls.isNotEmpty ? imageUrls[imageUrls.length - 1] : constants.defaultImageUrl;

  @override
  Map<String, dynamic> toMap() {
    return {
      'dbKey': dbKey,
      'name': name,
      'imageUrls': imageUrls,
      'phone': phone,
    };
  }

  factory Salesman.fromMap(Map<String, dynamic> map) {
    return Salesman(
      dbKey: map['dbKey'] ?? '',
      name: map['name'] ?? '',
      imageUrls: List<String>.from(map['imageUrls']),
      phone: map['phone'],
    );
  }

  @override
  String toString() => 'ProductCategory(dbKey: $dbKey, name: $name, imageUrls: $imageUrls)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Salesman && other.dbKey == dbKey && other.name == name && listEquals(other.imageUrls, imageUrls);
  }

  @override
  int get hashCode => dbKey.hashCode ^ name.hashCode ^ imageUrls.hashCode;
}
