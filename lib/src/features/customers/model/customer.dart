import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:tablets/src/common/interfaces/base_item.dart';
import 'package:tablets/src/common/values/constants.dart' as constants;

class Customer implements BaseItem {
  @override
  String dbKey;
  @override
  String name;
  @override
  List<String> imageUrls;
  String salesman;

  Customer({
    required this.dbKey,
    required this.name,
    required this.imageUrls,
    required this.salesman,
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
      'salesman': salesman,
    };
  }

  factory Customer.fromMap(Map<String, dynamic> map) {
    return Customer(
      dbKey: map['dbKey'] ?? '',
      name: map['name'] ?? '',
      imageUrls: List<String>.from(map['imageUrls']),
      salesman: map['salesman'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory Customer.fromJson(String source) => Customer.fromMap(json.decode(source));

  @override
  String toString() => 'ProductCategory(dbKey: $dbKey, name: $name, imageUrls: $imageUrls)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Customer &&
        other.dbKey == dbKey &&
        other.name == name &&
        listEquals(other.imageUrls, imageUrls) &&
        other.salesman == salesman;
  }

  @override
  int get hashCode {
    return dbKey.hashCode ^ name.hashCode ^ imageUrls.hashCode ^ salesman.hashCode;
  }
}
