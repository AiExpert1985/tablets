import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tablets/src/features/products/model/product.dart';

final searchedProductProvider = StateProvider<Product?>((ref) => null);
