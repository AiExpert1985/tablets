import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:tablets/src/constants/constants.dart' as constants;

Product _defaultProduct = Product(
    code: 100001,
    name: 'product',
    sellRetailPrice: 0,
    sellWholePrice: 0,
    packageType: 'unknown',
    packageWeight: 0,
    numItemsInsidePackage: 0,
    alertWhenExceeds: 100000,
    altertWhenLessThan: 100000,
    salesmanComission: 0,
    iamgesUrl: constants.DefaultImage.defaultImagesUrl,
    category: 'unknown',
    initialQuantity: 0);

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
  List<String> iamgesUrl;
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
    required this.iamgesUrl,
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
    List<String>? photos,
    String? category,
    double? initialQuantity,
  }) {
    return Product(
      // ignore: unnecessary_this
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
      iamgesUrl: photos ?? iamgesUrl,
      category: category ?? this.category,
      initialQuantity: initialQuantity ?? this.initialQuantity,
    );
  }

  @override
  String toString() {
    return 'Product(code: $code, name: $name)';
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
        listEquals(other.iamgesUrl, iamgesUrl) &&
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
        iamgesUrl.hashCode ^
        category.hashCode ^
        initialQuantity.hashCode;
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
      'photos': iamgesUrl,
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
      iamgesUrl: List<String>.from(map['photos']),
      category: map['category'] ?? '',
      initialQuantity: map['initialQuantity']?.toDouble() ?? 0.0,
    );
  }

  String toJson() => json.encode(toMap());

  factory Product.fromJson(String source) => Product.fromMap(json.decode(source));
}
