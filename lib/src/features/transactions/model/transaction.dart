import 'package:cloud_firestore/cloud_firestore.dart';
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
// (9) DamagedItems: item thrown away from the stock

// Note that I named it Transactions because Transaction is a class name used by firebase cloud
//! note when updating the class, and regenerate data class, then inside Transaction.fromMap function, the date must be
//! map['date'] is Timestamp ? map['date'].toDate() : map['date'],,
class Transaction implements BaseItem {
  @override
  String dbRef;
  @override
  String name; // transaction type: receipt, payment, gift, expenditure, invoice, returns, ...etc
  @override
  List<String> imageUrls;
  int number; // receipt number, entered automatically (last_receipt + 1)
  DateTime date;
  String currency; // $ or ID
  String? notes;
  String transactionType; // name of customer
  String? paymentType; // cash, debt
  String? salesman; // dbRef of salesman
  List<Map<String, dynamic>>? items;
  double? discount;
  String? totalAsText;
  double? totalWeight;
  double? subTotalAmount;
  String? salesmanDbRef;

  double totalAmount;
  Transaction({
    //required for all classes (BaseItem implementation)
    required this.dbRef,
    required this.name,
    required this.imageUrls,
    // all actions must have below properties
    required this.number,
    required this.date,
    required this.currency,
    this.notes,
    required this.transactionType,
    // optional based on type of transaction
    this.paymentType, // CustomerInvoice
    this.salesman,
    this.items,
    this.discount,
    this.totalAsText,
    this.totalWeight,
    this.subTotalAmount, // before the discount
    required this.totalAmount, // after discount
    this.salesmanDbRef,
  });

  @override
  String get coverImageUrl => imageUrls[imageUrls.length - 1];

  @override
  Map<String, dynamic> toMap() {
    return {
      'dbRef': dbRef,
      'name': name,
      'imageUrls': imageUrls,
      'number': number,
      'date': date,
      'currency': currency,
      'notes': notes,
      'transactionType': transactionType,
      'paymentType': paymentType,
      'salesman': salesman,
      'items': items,
      'discount': discount,
      'totalAsText': totalAsText,
      'totalWeight': totalWeight,
      'totalAmount': totalAmount,
      'subTotalAmount': subTotalAmount,
      'salesmanDbRef': salesmanDbRef,
    };
  }

  factory Transaction.fromMap(Map<String, dynamic> map) {
    return Transaction(
      dbRef: map['dbRef'],
      name: map['name'],
      imageUrls: List<String>.from(map['imageUrls']),
      number: map['number'].toInt(),
      date: map['date'] is Timestamp ? map['date'].toDate() : map['date'],
      currency: map['currency'],
      notes: map['notes'],
      transactionType: map['transactionType'],
      paymentType: map['paymentType'],
      salesman: map['salesman'],
      items: (map['items'] as List<dynamic>?)?.map((item) => item as Map<String, dynamic>).toList(),
      discount: map['discount'].toDouble(),
      totalAsText: map['totalAsText'],
      totalWeight: map['totalWeight'],
      totalAmount: map['totalAmount'],
      subTotalAmount: map['subTotalAmount'],
      salesmanDbRef: map['salesmanDbRef'],
    );
  }

  @override
  String toString() {
    return 'Transaction(name: $name, date: $date, amount: $totalAmount, transactionType: $transactionType)';
  }
}
