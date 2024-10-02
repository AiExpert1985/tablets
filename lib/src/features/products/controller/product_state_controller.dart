import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tablets/src/constants/constants.dart' as constants;
import 'package:tablets/src/features/products/model/product.dart';

ProductState _defaultProductState =
    ProductState(Product.getDefault(), [constants.DefaultImage.url]);

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

  void setProduct(Product product) => state = state.copyWith(product: product);

  void setImageUrls(imageUrls) => state = state.copyWith(imageUrls: imageUrls);

  void updateImageUrls(String url) {
    // first remove default image from list (if there is)
    List<String> currentUrls = List.from(state.imageUrls);
    currentUrls.remove(constants.DefaultImage.url);
    // then add the new url
    state = state.copyWith(imageUrls: [...currentUrls, url]);
  }

  void reset() => state = ProductState.getDefault();

  void resetProduct() => state = state.copyWith(product: ProductState.getDefault().product);

  void resetImageUrls() => state = state.copyWith(imageUrls: ProductState.getDefault().imageUrls);
}

final productStateNotifierProvider =
    StateNotifierProvider<ProductStateNotifier, ProductState>((ref) {
  final product = ProductState.getDefault();
  return ProductStateNotifier(product);
});
