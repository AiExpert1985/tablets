// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:tablets/src/common/constants/constants.dart' as constants;
import 'package:tablets/src/common/interfaces/base_item.dart';

class Salesman implements BaseItem {
  @override
  String dbKey;
  @override
  String name;
  @override
  List<String> imageUrls;
  String phone;
  List<String> customerDbKeys;
  List<String> workRegions;

  Salesman({
    required this.dbKey,
    required this.name,
    required this.imageUrls,
    required this.phone,
    required this.customerDbKeys,
    this.workRegions = const [],
  });

  @override
  String get coverImageUrl => imageUrls.isNotEmpty ? imageUrls[imageUrls.length - 1] : constants.defaultImageUrl;

  Salesman copyWith({
    String? dbKey,
    String? name,
    List<String>? imageUrls,
    String? phone,
    List<String>? customerDbKeys,
    List<String>? workRegions,
  }) {
    return Salesman(
      dbKey: dbKey ?? this.dbKey,
      name: name ?? this.name,
      imageUrls: imageUrls ?? this.imageUrls,
      phone: phone ?? this.phone,
      customerDbKeys: customerDbKeys ?? this.customerDbKeys,
      workRegions: workRegions ?? this.workRegions,
    );
  }

  @override
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'dbKey': dbKey,
      'name': name,
      'imageUrls': imageUrls,
      'phone': phone,
      'customerDbKeys': customerDbKeys,
      'workRegions': workRegions,
    };
  }

  factory Salesman.fromMap(Map<String, dynamic> map) {
    return Salesman(
      dbKey: map['dbKey'] ?? '',
      name: map['name'] ?? '',
      imageUrls: map['imageUrls'] ?? [constants.defaultImageUrl],
      phone: map['phone'] ?? '',
      customerDbKeys: map['customerDbKeys'] ?? [],
      workRegions: map['workRegions'] ?? [],
    );
  }

  String toJson() => json.encode(toMap());

  factory Salesman.fromJson(String source) => Salesman.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Salesman(dbKey: $dbKey, name: $name, imageUrls: $imageUrls, phone: $phone, customerDbKeys: $customerDbKeys, workRegions: $workRegions)';
  }

  @override
  bool operator ==(covariant Salesman other) {
    if (identical(this, other)) return true;

    return other.dbKey == dbKey &&
        other.name == name &&
        listEquals(other.imageUrls, imageUrls) &&
        other.phone == phone &&
        listEquals(other.customerDbKeys, customerDbKeys) &&
        listEquals(other.workRegions, workRegions);
  }

  @override
  int get hashCode {
    return dbKey.hashCode ^
        name.hashCode ^
        imageUrls.hashCode ^
        phone.hashCode ^
        customerDbKeys.hashCode ^
        workRegions.hashCode;
  }
}
