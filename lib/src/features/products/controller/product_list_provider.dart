import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tablets/src/features/products/model/product.dart';

final productsListProvider = StateProvider<List<Product>>((ref) => []);
