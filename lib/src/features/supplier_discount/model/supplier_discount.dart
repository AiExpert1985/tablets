class SupplierDiscount {
  SupplierDiscount({
    required this.supplierDbRef,
    required this.productDbRef,
    required this.date,
    required this.discountAmount,
    required this.newPrice,
    required this.quantity,
  });
  String supplierDbRef;
  String productDbRef;
  DateTime date;
  double quantity;
  double discountAmount;
  double newPrice;
}
