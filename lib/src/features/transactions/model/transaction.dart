import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:tablets/src/common/interfaces/base_item.dart';

// name Transactions because Transaction is a class name used by firebase cloud
class Transaction implements BaseItem {
  @override
  String dbKey;
  @override
  String name; // transaction type: receipt, payment, gift, expenditure, invoice, returns, ...etc
  @override
  List<String> imageUrls;
  int number; // receipt number, entered automatically (last_receipt + 1)
  DateTime date;
  double amount; // amount of money
  String currency; // $ or ID
  String notes;
  String counterParty; // name of customer
  String paymentType; // cash, debt
  String salesman; // dbKey of salesman
  List<String>? itemDbKeyList;
  double discount;
  Transaction({
    //required for all classes (BaseItem implementation)
    required this.dbKey,
    required this.name,
    required this.imageUrls,
    // required for all transactions
    required this.number,
    required this.date,
    required this.amount,
    required this.currency,
    required this.notes,
    required this.counterParty,
    // optional based on type of transaction (Receipt, payment, invoice, )
    required this.paymentType,
    required this.salesman,
    required this.itemDbKeyList,
    required this.discount,
  });

  @override
  String get coverImageUrl => imageUrls[imageUrls.length - 1];

  Transaction copyWith({
    String? dbKey,
    String? name,
    List<String>? imageUrls,
    int? number,
    DateTime? date,
    double? amount,
    String? currency,
    String? notes,
    String? counterParty,
    String? paymentType,
    String? salesman,
    ValueGetter<List<String>?>? itemDbKeyList,
    double? discount,
  }) {
    return Transaction(
      dbKey: dbKey ?? this.dbKey,
      name: name ?? this.name,
      imageUrls: imageUrls ?? this.imageUrls,
      number: number ?? this.number,
      date: date ?? this.date,
      amount: amount ?? this.amount,
      currency: currency ?? this.currency,
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
      'date': date,
      'amount': amount,
      'currency': currency,
      'notes': notes,
      'counterParty': counterParty,
      'paymentType': paymentType,
      'salesman': salesman,
      'itemDbKeyList': itemDbKeyList,
      'discount': discount,
    };
  }

  factory Transaction.fromMap(Map<String, dynamic> map) {
    return Transaction(
      dbKey: map['dbKey'],
      name: map['name'],
      imageUrls: List<String>.from(map['imageUrls']),
      number: map['number'].toInt(),
      date: map['date'].toDate(),
      amount: map['amount']?.toDouble(),
      currency: map['currency'],
      notes: map['notes'],
      counterParty: map['counterParty'],
      paymentType: map['paymentType'],
      salesman: map['salesman'],
      itemDbKeyList: ['dsafsdf', 'safsdfsdf', 'sadfsdf'],
      discount: map['discount'].toDouble(),
    );
  }

  String toJson() => json.encode(toMap());

  factory Transaction.fromJson(String source) => Transaction.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Transaction(name: $name, date: $date, amount: $amount, counterParty: $counterParty)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Transaction &&
        other.dbKey == dbKey &&
        other.name == name &&
        listEquals(other.imageUrls, imageUrls) &&
        other.number == number &&
        other.date == date &&
        other.amount == amount &&
        other.currency == currency &&
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
        currency.hashCode ^
        notes.hashCode ^
        counterParty.hashCode ^
        paymentType.hashCode ^
        salesman.hashCode ^
        itemDbKeyList.hashCode ^
        discount.hashCode;
  }
}
