import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:tablets/src/common/interfaces/base_item.dart';

// used to represent below types of transactions:
// (1) Expenditures: Salaries, Electricity, Rent, ... etc.
// (2) Gift: Given to customers (it is considered a special type of expenditures) .
// (3) VendorReceipt: Money payed to Venders.
// (4) CustomerReceipt: Money Taken from Customers.
// (5) VenderReturn: Items returned to Venders.
// (6) CustomerReturn: Items returned from Customers.
// (7) VenderInvoice: a bill of items bought from Venders.
// (8) CustomerInvoice: bill of items sold to Customers.

// Note that I named it Transactions because Transaction is a class name used by firebase cloud
//! note when updating the class, and regenerate data class, then inside Transaction.fromMap function, the date must be
//! map['date'].runtimeType == Timestamp ? map['date'].toDate() : map['date'],,
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
  String? notes;
  String counterParty; // name of customer
  String? paymentType; // cash, debt
  String? salesman; // dbKey of salesman
  List<String>? items;
  double? discount;
  String? totalAsText;
  Transaction({
    //required for all classes (BaseItem implementation)
    required this.dbKey,
    required this.name,
    required this.imageUrls,
    // all actions must have below properties
    required this.number,
    required this.date,
    required this.amount,
    required this.currency,
    this.notes,
    required this.counterParty,
    // optional based on type of transaction
    this.paymentType, // CustomerInvoice
    this.salesman,
    this.items,
    this.discount,
    this.totalAsText,
  });

  @override
  String get coverImageUrl => imageUrls[imageUrls.length - 1];

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
      'itemDbKeyList': items,
      'discount': discount,
      'totalAsText': totalAsText,
    };
  }

  factory Transaction.fromMap(Map<String, dynamic> map) {
    return Transaction(
      dbKey: map['dbKey'],
      name: map['name'],
      imageUrls: List<String>.from(map['imageUrls']),
      number: map['number'].toInt(),
      date: map['date'].runtimeType == Timestamp ? map['date'].toDate() : map['date'],
      amount: map['amount']?.toDouble(),
      currency: map['currency'],
      notes: map['notes'],
      counterParty: map['counterParty'],
      paymentType: map['paymentType'],
      salesman: map['salesman'],
      items: ['dsafsdf', 'safsdfsdf', 'sadfsdf'],
      discount: map['discount'].toDouble(),
      totalAsText: map['totalAsText'],
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
        listEquals(other.items, items) &&
        other.discount == discount &&
        other.totalAsText == totalAsText;
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
        items.hashCode ^
        discount.hashCode ^
        totalAsText.hashCode;
  }
}
