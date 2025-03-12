class SalesPoint {
  String salesmanName;
  String salesmanDbRef;
  String customerName;
  String customerDbRef;
  DateTime date;
  bool isVisited;
  bool hasTransaction;

  SalesPoint(this.salesmanName, this.salesmanDbRef, this.customerName, this.customerDbRef,
      this.date, this.isVisited, this.hasTransaction);
}
