import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:tablets/src/common/constants/constants.dart' as constants;
import 'package:tablets/src/common/interfaces/base_item.dart';

class Customer implements BaseItem {
  @override
  String dbKey;
  @override
  String name;
  @override
  List<String> imageUrls;

  Customer({
    required this.dbKey,
    required this.name,
    required this.imageUrls,
  });

  @override
  String get coverImageUrl => imageUrls.isNotEmpty ? imageUrls[imageUrls.length - 1] : constants.defaultImageUrl;

  Customer copyWith({
    String? dbKey,
    String? name,
    List<String>? imageUrls,
  }) {
    return Customer(
      dbKey: dbKey ?? this.dbKey,
      name: name ?? this.name,
      imageUrls: imageUrls ?? this.imageUrls,
    );
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      'dbKey': dbKey,
      'name': name,
      'imageUrls': imageUrls,
    };
  }

  factory Customer.fromMap(Map<String, dynamic> map) {
    return Customer(
      dbKey: map['dbKey'] ?? '',
      name: map['name'] ?? '',
      imageUrls: List<String>.from(map['imageUrls']),
    );
  }

  String toJson() => json.encode(toMap());

  factory Customer.fromJson(String source) => Customer.fromMap(json.decode(source));

  @override
  String toString() => 'ProductCategory(dbKey: $dbKey, name: $name, imageUrls: $imageUrls)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Customer && other.dbKey == dbKey && other.name == name && listEquals(other.imageUrls, imageUrls);
  }

  @override
  int get hashCode => dbKey.hashCode ^ name.hashCode ^ imageUrls.hashCode;
}
