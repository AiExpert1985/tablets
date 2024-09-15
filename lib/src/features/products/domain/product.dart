class Product {
  double itemCode;
  String name;
  double sellRetailPrice;
  double sellWholePrice;
  String packageType;
  double packageWeight;
  double numItemsInsidePackage;
  double alertWhenExceeds;
  double altertWhenLessThan;
  double salesmanComission;
  List<String> photos;
  String category;
  double initialQuantity;

  Product({
    required this.itemCode,
    required this.name,
    required this.sellRetailPrice, // price for selling one item
    required this.sellWholePrice, // price for selling many items
    required this.packageType,
    required this.packageWeight,
    required this.numItemsInsidePackage,
    required this.alertWhenExceeds,
    required this.altertWhenLessThan,
    required this.salesmanComission,
    required this.photos,
    required this.category,
    required this.initialQuantity,
  });
}
