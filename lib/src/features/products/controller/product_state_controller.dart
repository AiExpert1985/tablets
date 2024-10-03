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

  ProductState setProduct(Product product) => state = state.copyWith(product: product);

  ProductState setImageUrls(imageUrls) => state = state.copyWith(imageUrls: imageUrls);

  ProductState updateImageUrls(String url) {
    // first remove default image from list (if there is)
    List<String> currentUrls = List.from(state.imageUrls);
    currentUrls.remove(constants.DefaultImage.url);
    // then add the new url
    state = state.copyWith(imageUrls: [...currentUrls, url]);
    return state;
  }

  void reset() => state = ProductState.getDefault();

  void resetProduct() => state = state.copyWith(product: ProductState.getDefault().product);

  void resetImageUrls() => state = state.copyWith(imageUrls: ProductState.getDefault().imageUrls);

  /// I used this trick because I faced problem when I passed below
  /// final productStateProvider = ref.watch(productStateNotifierProvider);
  /// and then access that state through
  /// productStateProvider.product (or .imageUrls)
  /// because it keeps giving me the old state, even when the state is changed
  /// I decided to use the
  /// final productStateController = ref.watch(productStateNotifierProvider.notifier)
  /// productStateController.currentState.product (or .imageUrls)

  ProductState get currentState => state;
}

final productStateNotifierProvider =
    StateNotifierProvider<ProductStateNotifier, ProductState>((ref) {
  final product = ProductState.getDefault();
  return ProductStateNotifier(product);
});
