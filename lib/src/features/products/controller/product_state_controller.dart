import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tablets/src/features/products/model/product.dart';

ProductState _defaultProductState = ProductState(Product.getDefault(), []);

class ProductState {
  ProductState(this.product, this.imageUrls);
  Product product;
  List<String> imageUrls;

  static ProductState getDefault() => _defaultProductState.copyWith();

  ProductState copyWith({
    Product? product,
    List<String>? imageUrls,
  }) {
    return ProductState(
      product ?? this.product,
      imageUrls ?? this.imageUrls,
    );
  }
}

class ProductStateNotifier extends StateNotifier<ProductState> {
  ProductStateNotifier(super.state);
  void updateProduct(Product product) => state = state.copyWith(product: product);

  void updateImageUrls(String url) => state = state.copyWith(imageUrls: [...state.imageUrls, url]);

  void reset() => state = ProductState.getDefault();

  void resetProduct() => state = state.copyWith(product: Product.getDefault());

  void resetImageUrls() => state = state.copyWith(imageUrls: []);

  void setImageUrls(imageUrls) => state = state.copyWith(imageUrls: imageUrls);
}

final productStateNotifierProvider =
    StateNotifierProvider<ProductStateNotifier, ProductState>((ref) {
  final product = ProductState(Product.getDefault(), []);
  return ProductStateNotifier(product);
});
