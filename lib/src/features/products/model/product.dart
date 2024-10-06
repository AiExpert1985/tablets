import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:tablets/src/constants/constants.dart' as constants;

Product _defaultProduct = Product(
    code: 110011,
    name: 'NA',
    sellRetailPrice: 110011,
    sellWholePrice: 110011,
    packageType: 'NA',
    packageWeight: 110011,
    numItemsInsidePackage: 110011,
    alertWhenExceeds: 110011,
    altertWhenLessThan: 110011,
    salesmanComission: 110011,
    imageUrls: [constants.DefaultImage.url],
    category: 'NA',
    initialQuantity: 110011);

class Product {
  double code;
  String name;
  double sellRetailPrice;
  double sellWholePrice;
  String packageType;
  double packageWeight;
  double numItemsInsidePackage;
  double alertWhenExceeds;
  double altertWhenLessThan;
  double salesmanComission;
  List<String> imageUrls;
  String category;
  double initialQuantity;

  Product({
    required this.code,
    required this.name,
    required this.sellRetailPrice,
    required this.sellWholePrice,
    required this.packageType,
    required this.packageWeight,
    required this.numItemsInsidePackage,
    required this.alertWhenExceeds,
    required this.altertWhenLessThan,
    required this.salesmanComission,
    required this.imageUrls,
    required this.category,
    required this.initialQuantity,
  });

  static Product getDefault() => _defaultProduct.copyWith();

  Product copyWith({
    double? code,
    String? name,
    double? sellRetailPrice,
    double? sellWholePrice,
    String? packageType,
    double? packageWeight,
    double? numItemsInsidePackage,
    double? alertWhenExceeds,
    double? altertWhenLessThan,
    double? salesmanComission,
    List<String>? imageUrls,
    String? category,
    double? initialQuantity,
  }) {
    return Product(
      code: code ?? this.code,
      name: name ?? this.name,
      sellRetailPrice: sellRetailPrice ?? this.sellRetailPrice,
      sellWholePrice: sellWholePrice ?? this.sellWholePrice,
      packageType: packageType ?? this.packageType,
      packageWeight: packageWeight ?? this.packageWeight,
      numItemsInsidePackage: numItemsInsidePackage ?? this.numItemsInsidePackage,
      alertWhenExceeds: alertWhenExceeds ?? this.alertWhenExceeds,
      altertWhenLessThan: altertWhenLessThan ?? this.altertWhenLessThan,
      salesmanComission: salesmanComission ?? this.salesmanComission,
      imageUrls: imageUrls ?? this.imageUrls,
      category: category ?? this.category,
      initialQuantity: initialQuantity ?? this.initialQuantity,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'code': code,
      'name': name,
      'sellRetailPrice': sellRetailPrice,
      'sellWholePrice': sellWholePrice,
      'packageType': packageType,
      'packageWeight': packageWeight,
      'numItemsInsidePackage': numItemsInsidePackage,
      'alertWhenExceeds': alertWhenExceeds,
      'altertWhenLessThan': altertWhenLessThan,
      'salesmanComission': salesmanComission,
      'imageUrls': imageUrls,
      'category': category,
      'initialQuantity': initialQuantity,
    };
  }

  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      code: map['code']?.toDouble() ?? 0.0,
      name: map['name'] ?? '',
      sellRetailPrice: map['sellRetailPrice']?.toDouble() ?? 0.0,
      sellWholePrice: map['sellWholePrice']?.toDouble() ?? 0.0,
      packageType: map['packageType'] ?? '',
      packageWeight: map['packageWeight']?.toDouble() ?? 0.0,
      numItemsInsidePackage: map['numItemsInsidePackage']?.toDouble() ?? 0.0,
      alertWhenExceeds: map['alertWhenExceeds']?.toDouble() ?? 0.0,
      altertWhenLessThan: map['altertWhenLessThan']?.toDouble() ?? 0.0,
      salesmanComission: map['salesmanComission']?.toDouble() ?? 0.0,
      imageUrls: List<String>.from(map['imageUrls']),
      category: map['category'] ?? '',
      initialQuantity: map['initialQuantity']?.toDouble() ?? 0.0,
    );
  }

  String toJson() => json.encode(toMap());

  factory Product.fromJson(String source) => Product.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Product(code: $code, name: $name, sellRetailPrice: $sellRetailPrice, sellWholePrice: $sellWholePrice, packageType: $packageType, packageWeight: $packageWeight, numItemsInsidePackage: $numItemsInsidePackage, alertWhenExceeds: $alertWhenExceeds, altertWhenLessThan: $altertWhenLessThan, salesmanComission: $salesmanComission, imageUrls: $imageUrls, category: $category, initialQuantity: $initialQuantity)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Product &&
        other.code == code &&
        other.name == name &&
        other.sellRetailPrice == sellRetailPrice &&
        other.sellWholePrice == sellWholePrice &&
        other.packageType == packageType &&
        other.packageWeight == packageWeight &&
        other.numItemsInsidePackage == numItemsInsidePackage &&
        other.alertWhenExceeds == alertWhenExceeds &&
        other.altertWhenLessThan == altertWhenLessThan &&
        other.salesmanComission == salesmanComission &&
        listEquals(other.imageUrls, imageUrls) &&
        other.category == category &&
        other.initialQuantity == initialQuantity;
  }

  @override
  int get hashCode {
    return code.hashCode ^
        name.hashCode ^
        sellRetailPrice.hashCode ^
        sellWholePrice.hashCode ^
        packageType.hashCode ^
        packageWeight.hashCode ^
        numItemsInsidePackage.hashCode ^
        alertWhenExceeds.hashCode ^
        altertWhenLessThan.hashCode ^
        salesmanComission.hashCode ^
        imageUrls.hashCode ^
        category.hashCode ^
        initialQuantity.hashCode;
  }
}
