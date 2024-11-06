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
  String region;
  String regionDbRef;

  Customer({
    required this.dbRef,
    required this.name,
    required this.imageUrls,
    required this.salesman,
    required this.salesmanDbRef,
    required this.region,
    required this.regionDbRef,
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
      'region': region,
      'regionDbRef': regionDbRef,
    };
  }

  factory Customer.fromMap(Map<String, dynamic> map) {
    return Customer(
      dbRef: map['dbRef'] ?? '',
      name: map['name'] ?? '',
      imageUrls: List<String>.from(map['imageUrls']),
      salesman: map['salesman'] ?? '',
      salesmanDbRef: map['salesmanDbRef'] ?? '',
      region: map['region'] ?? '',
      regionDbRef: map['regionDbRef'] ?? '',
    );
  }

  @override
  String toString() => 'ProductCategory(dbRef: $dbRef, name: $name, imageUrls: $imageUrls)';
}
