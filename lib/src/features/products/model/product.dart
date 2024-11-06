import 'package:tablets/src/common/interfaces/base_item.dart';

class Product implements BaseItem {
  @override
  String dbRef;
  @override
  String name;
  @override
  List<String> imageUrls;
  int code;
  double sellRetailPrice;
  double sellWholePrice;
  String packageType;
  double packageWeight;
  int numItemsInsidePackage;
  int alertWhenExceeds;
  int altertWhenLessThan;
  double salesmanComission;
  String category;
  int initialQuantity;

  Product({
    required this.dbRef,
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

  @override
  String get coverImageUrl => imageUrls[imageUrls.length - 1];

  Product copyWith({
    String? dbRef,
    int? code,
    String? name,
    double? sellRetailPrice,
    double? sellWholePrice,
    String? packageType,
    double? packageWeight,
    int? numItemsInsidePackage,
    int? alertWhenExceeds,
    int? altertWhenLessThan,
    double? salesmanComission,
    List<String>? imageUrls,
    String? category,
    int? initialQuantity,
  }) {
    return Product(
      dbRef: dbRef ?? this.dbRef,
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

  @override
  Map<String, dynamic> toMap() {
    return {
      'dbRef': dbRef,
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
      dbRef: map['dbRef'] ?? '',
      code: map['code']?.toInt() ?? 0,
      name: map['name'] ?? '',
      sellRetailPrice: map['sellRetailPrice']?.toDouble() ?? 0.0,
      sellWholePrice: map['sellWholePrice']?.toDouble() ?? 0.0,
      packageType: map['packageType'] ?? '',
      packageWeight: map['packageWeight']?.toDouble() ?? 0.0,
      numItemsInsidePackage: map['numItemsInsidePackage']?.toInt() ?? 0,
      alertWhenExceeds: map['alertWhenExceeds']?.toInt() ?? 0,
      altertWhenLessThan: map['altertWhenLessThan']?.toInt() ?? 0,
      salesmanComission: map['salesmanComission']?.toDouble() ?? 0.0,
      imageUrls: List<String>.from(map['imageUrls']),
      category: map['category'] ?? '',
      initialQuantity: map['initialQuantity']?.toInt() ?? 0,
    );
  }

  @override
  String toString() {
    return 'Product(dbRef: $dbRef, code: $code, name: $name, sellRetailPrice: $sellRetailPrice, sellWholePrice: $sellWholePrice, packageType: $packageType, packageWeight: $packageWeight, numItemsInsidePackage: $numItemsInsidePackage, alertWhenExceeds: $alertWhenExceeds, altertWhenLessThan: $altertWhenLessThan, salesmanComission: $salesmanComission, imageUrls: $imageUrls, category: $category, initialQuantity: $initialQuantity)';
  }
}
