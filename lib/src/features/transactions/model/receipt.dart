import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:tablets/src/common/interfaces/transaction.dart';

class Receipt implements Transaction {
  @override
  String dbKey;
  @override
  String name; // transaction type: receipt, payment, gift, expenditure, invoice, returns, ...etc
  @override
  List<String> imageUrls;
  @override
  int number;
  @override
  DateTime date;
  @override
  double amount; // amount of money
  @override
  String currencty; // $ or ID
  @override
  String notes;
  String counterParty; // name of customer
  String paymentType; // cash, debt
  String salesman; // dbKey of salesman
  List<String>? itemDbKeyList;
  double discount;
  Receipt({
    required this.dbKey,
    required this.name,
    required this.imageUrls,
    required this.number,
    required this.date,
    required this.amount,
    required this.currencty,
    required this.notes,
    required this.counterParty,
    required this.paymentType,
    required this.salesman,
    required this.itemDbKeyList,
    required this.discount,
  });

  @override
  String get coverImageUrl => imageUrls[imageUrls.length - 1];

  Receipt copyWith({
    String? dbKey,
    String? name,
    List<String>? imageUrls,
    int? number,
    DateTime? date,
    double? amount,
    String? currencty,
    String? notes,
    String? counterParty,
    String? paymentType,
    String? salesman,
    ValueGetter<List<String>?>? itemDbKeyList,
    double? discount,
  }) {
    return Receipt(
      dbKey: dbKey ?? this.dbKey,
      name: name ?? this.name,
      imageUrls: imageUrls ?? this.imageUrls,
      number: number ?? this.number,
      date: date ?? this.date,
      amount: amount ?? this.amount,
      currencty: currencty ?? this.currencty,
      notes: notes ?? this.notes,
      counterParty: counterParty ?? this.counterParty,
      paymentType: paymentType ?? this.paymentType,
      salesman: salesman ?? this.salesman,
      itemDbKeyList: itemDbKeyList != null ? itemDbKeyList() : this.itemDbKeyList,
      discount: discount ?? this.discount,
    );
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      'dbKey': dbKey,
      'name': name,
      'imageUrls': imageUrls,
      'number': number,
      'date': date.millisecondsSinceEpoch,
      'amount': amount,
      'currencty': currencty,
      'notes': notes,
      'counterParty': counterParty,
      'paymentType': paymentType,
      'salesman': salesman,
      'itemDbKeyList': itemDbKeyList,
      'discount': discount,
    };
  }

  factory Receipt.fromMap(Map<String, dynamic> map) {
    return Receipt(
      dbKey: map['dbKey'] ?? '',
      name: map['name'] ?? '',
      imageUrls: List<String>.from(map['imageUrls']),
      number: map['number']?.toInt() ?? 0,
      date: DateTime.fromMillisecondsSinceEpoch(map['date']),
      amount: map['amount']?.toDouble() ?? 0.0,
      currencty: map['currencty'] ?? '',
      notes: map['notes'] ?? '',
      counterParty: map['counterParty'] ?? '',
      paymentType: map['paymentType'] ?? '',
      salesman: map['salesman'] ?? '',
      itemDbKeyList: List<String>.from(map['itemDbKeyList']),
      discount: map['discount']?.toDouble() ?? 0.0,
    );
  }

  String toJson() => json.encode(toMap());

  factory Receipt.fromJson(String source) => Receipt.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Receipt(name: $name, date: $date, amount: $amount, counterParty: $counterParty)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Receipt &&
        other.dbKey == dbKey &&
        other.name == name &&
        listEquals(other.imageUrls, imageUrls) &&
        other.number == number &&
        other.date == date &&
        other.amount == amount &&
        other.currencty == currencty &&
        other.notes == notes &&
        other.counterParty == counterParty &&
        other.paymentType == paymentType &&
        other.salesman == salesman &&
        listEquals(other.itemDbKeyList, itemDbKeyList) &&
        other.discount == discount;
  }

  @override
  int get hashCode {
    return dbKey.hashCode ^
        name.hashCode ^
        imageUrls.hashCode ^
        number.hashCode ^
        date.hashCode ^
        amount.hashCode ^
        currencty.hashCode ^
        notes.hashCode ^
        counterParty.hashCode ^
        paymentType.hashCode ^
        salesman.hashCode ^
        itemDbKeyList.hashCode ^
        discount.hashCode;
  }
}
