import 'package:flutter/widgets.dart';
import 'package:tablets/src/features/products/model/product.dart';

class ProductItem extends StatelessWidget {
  const ProductItem(this.product, {super.key});
  final Product product;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(product.code.toString()),
        const SizedBox(width: 20),
        Text(product.name),
      ],
    );
  }
}
