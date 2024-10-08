import 'package:anydrawer/anydrawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tablets/src/features/products/view/drawer_search_fields.dart';
// import 'package:tablets/src/utils/utils.dart' as utils;
// import 'package:tablets/src/constants/constants.dart' as constants;

class ProductDrawer {
  void showSearchForm(BuildContext context) {
    showDrawer(
      context,
      builder: (context) {
        return const Center(
          child: SafeArea(
            top: true,
            child: ProductSearchForm(),
          ),
        );
      },
      config: const DrawerConfig(
        side: DrawerSide.left,
        widthPercentage: 0.3,
        dragEnabled: false, // I wanted it to be only controller by buttons inside body
        closeOnClickOutside: true,
        // closeOnEscapeKey: true,
        // closeOnResume: true, // (Android only)
        // closeOnBackButton: true, // (Requires a route navigator)
        backdropOpacity: 0.3,
        // borderRadius: 24,
      ),
      onOpen: () {},
      onClose: () {},
    );
  }

  void showReports(context) {
    showDrawer(
      context,
      builder: (context) {
        return const Center(
          child: Text('Reports'),
        );
      },
      config: const DrawerConfig(
        side: DrawerSide.left,
        widthPercentage: 0.2,
        dragEnabled: false, // I wanted it to be only controller by buttons inside body
        closeOnClickOutside: true,
        backdropOpacity: 0.3,
        borderRadius: 10,
      ),
      onOpen: () {},
      onClose: () {},
    );
  }
}

final productsDrawerProvider = Provider<ProductDrawer>((ref) {
  return ProductDrawer();
});
