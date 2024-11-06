import 'package:flutter/foundation.dart';

import 'package:tablets/src/common/values/constants.dart' as constants;
import 'package:tablets/src/common/interfaces/base_item.dart';

class Salesman implements BaseItem {
  @override
  String dbRef;
  @override
  String name;
  @override
  List<String> imageUrls;
  String? phone;

  Salesman({
    required this.dbRef,
    required this.name,
    required this.imageUrls,
    this.phone,
  });

  @override
  String get coverImageUrl => imageUrls.isNotEmpty ? imageUrls[imageUrls.length - 1] : constants.defaultImageUrl;

  @override
  Map<String, dynamic> toMap() {
    return {
      'dbRef': dbRef,
      'name': name,
      'imageUrls': imageUrls,
      'phone': phone,
    };
  }

  factory Salesman.fromMap(Map<String, dynamic> map) {
    return Salesman(
      dbRef: map['dbRef'] ?? '',
      name: map['name'] ?? '',
      imageUrls: List<String>.from(map['imageUrls']),
      phone: map['phone'],
    );
  }

  @override
  String toString() => 'ProductCategory(dbRef: $dbRef, name: $name, imageUrls: $imageUrls)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Salesman && other.dbRef == dbRef && other.name == name && listEquals(other.imageUrls, imageUrls);
  }

  @override
  int get hashCode => dbRef.hashCode ^ name.hashCode ^ imageUrls.hashCode;
}
