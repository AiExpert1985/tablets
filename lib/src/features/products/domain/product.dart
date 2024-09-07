class Product {
  double itemCode;
  String name;
  double buyPrice;
  double sellRetailPrice;
  double sellWholePrice;
  double packageWeight;
  double numItemsInsidePackage;

  Product({
    required this.itemCode,
    required this.name,
    required this.buyPrice,
    required this.sellRetailPrice, // price for selling one item
    required this.sellWholePrice, // price for selling many items
    required this.packageWeight,
    required this.numItemsInsidePackage,
  });
}
