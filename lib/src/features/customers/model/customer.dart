import 'package:flutter/foundation.dart';

import 'package:tablets/src/common/interfaces/base_item.dart';
import 'package:tablets/src/common/values/constants.dart' as constants;

class Customer implements BaseItem {
  @override
  String dbRef;
  @override
  String name;
  @override
  List<String> imageUrls;
  String salesman;
  String salesmanDbRef;

  Customer({
    required this.dbRef,
    required this.name,
    required this.imageUrls,
    required this.salesman,
    required this.salesmanDbRef,
  });

  @override
  String get coverImageUrl => imageUrls.isNotEmpty ? imageUrls[imageUrls.length - 1] : constants.defaultImageUrl;

  @override
  Map<String, dynamic> toMap() {
    return {
      'dbRef': dbRef,
      'name': name,
      'imageUrls': imageUrls,
      'salesman': salesman,
      'salesmanDbRef': salesmanDbRef,
    };
  }

  factory Customer.fromMap(Map<String, dynamic> map) {
    return Customer(
      dbRef: map['dbRef'] ?? '',
      name: map['name'] ?? '',
      imageUrls: List<String>.from(map['imageUrls']),
      salesman: map['salesman'] ?? '',
      salesmanDbRef: map['salesmanDbRef'] ?? '',
    );
  }

  @override
  String toString() => 'ProductCategory(dbRef: $dbRef, name: $name, imageUrls: $imageUrls)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Customer &&
        other.dbRef == dbRef &&
        other.name == name &&
        listEquals(other.imageUrls, imageUrls) &&
        other.salesman == salesman;
  }

  @override
  int get hashCode {
    return dbRef.hashCode ^ name.hashCode ^ imageUrls.hashCode ^ salesman.hashCode;
  }
}
