// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';
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
  double? x; // gps longitude
  double? y; // gps latitude
  DateTime initialDate;
  double initialCredit; // initial debt on customer
  String? address;
  String sellingPriceType; // wholesale or retail
  double creditLimit; // maximum allowed credit
  double paymentDurationLimit; // maximum days to close a transaction (pay its amount)

  Customer({
    required this.dbRef,
    required this.name,
    required this.imageUrls,
    required this.salesman,
    required this.salesmanDbRef,
    required this.region,
    required this.regionDbRef,
    this.x,
    this.y,
    required this.initialDate,
    required this.initialCredit,
    this.address,
    required this.sellingPriceType,
    required this.creditLimit,
    required this.paymentDurationLimit,
  });

  @override
  String get coverImageUrl => imageUrls.isNotEmpty ? imageUrls[imageUrls.length - 1] : constants.defaultImageUrl;

  Customer copyWith({
    String? dbRef,
    String? name,
    List<String>? imageUrls,
    String? salesman,
    String? salesmanDbRef,
    String? region,
    String? regionDbRef,
    double? x,
    double? y,
    DateTime? initialDate,
    double? initialCredit,
    String? address,
    String? sellingPriceType,
    double? creditLimit,
    double? paymentDurationLimit,
  }) {
    return Customer(
      dbRef: dbRef ?? this.dbRef,
      name: name ?? this.name,
      imageUrls: imageUrls ?? this.imageUrls,
      salesman: salesman ?? this.salesman,
      salesmanDbRef: salesmanDbRef ?? this.salesmanDbRef,
      region: region ?? this.region,
      regionDbRef: regionDbRef ?? this.regionDbRef,
      x: x ?? this.x,
      y: y ?? this.y,
      initialDate: initialDate ?? this.initialDate,
      initialCredit: initialCredit ?? this.initialCredit,
      address: address ?? this.address,
      sellingPriceType: sellingPriceType ?? this.sellingPriceType,
      creditLimit: creditLimit ?? this.creditLimit,
      paymentDurationLimit: paymentDurationLimit ?? this.paymentDurationLimit,
    );
  }

  @override
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'dbRef': dbRef,
      'name': name,
      'imageUrls': imageUrls,
      'salesman': salesman,
      'salesmanDbRef': salesmanDbRef,
      'region': region,
      'regionDbRef': regionDbRef,
      'x': x,
      'y': y,
      'initialDate': initialDate,
      'initialCredit': initialCredit,
      'address': address,
      'sellingPriceType': sellingPriceType,
      'creditLimit': creditLimit,
      'paymentDurationLimit': paymentDurationLimit,
    };
  }

  factory Customer.fromMap(Map<String, dynamic> map) {
    return Customer(
      dbRef: map['dbRef'],
      name: map['name'],
      imageUrls: List<String>.from(map['imageUrls']),
      salesman: map['salesman'],
      salesmanDbRef: map['salesmanDbRef'],
      region: map['region'] as String,
      regionDbRef: map['regionDbRef'],
      x: map['x'],
      y: map['y'],
      initialDate: map['initialDate'] is Timestamp ? map['initialDate'].toDate() : map['initialDate'],
      initialCredit: map['initialCredit'],
      address: map['address'],
      sellingPriceType: map['sellingPriceType'],
      creditLimit: map['creditLimit'],
      paymentDurationLimit: map['paymentDurationLimit'],
    );
  }

  @override
  String toString() {
    return 'Customer(dbRef: $dbRef, name: $name, imageUrls: $imageUrls, salesman: $salesman, salesmanDbRef: $salesmanDbRef, region: $region, regionDbRef: $regionDbRef, x: $x, y: $y, initialDate: $initialDate, initialCredit: $initialCredit, address: $address, sellingPriceType: $sellingPriceType, creditLimit: $creditLimit, paymentDurationLimit: $paymentDurationLimit)';
  }
}
