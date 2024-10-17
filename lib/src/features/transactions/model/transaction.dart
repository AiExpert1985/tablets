class Transaction {
  String dbKey;
  int number;
  String name;
  String type;
  DateTime date;
  double paymentAmount;
  String? notes;
  String? subtype;
  String? salesmanDbKey;
  String? regionDbKey;
  String? phone;
  String? paymentType;
  List<String>? itemDbKeyList;
  double? discount;
  double? paymentTransferFee;

  Transaction({
    required this.dbKey,
    required this.number,
    required this.name,
    required this.type,
    required this.date,
    required this.paymentAmount,
    this.notes,
    this.subtype,
    this.salesmanDbKey,
    this.regionDbKey,
    this.phone,
    this.paymentType,
    this.itemDbKeyList,
    this.discount,
    this.paymentTransferFee,
  });
}
