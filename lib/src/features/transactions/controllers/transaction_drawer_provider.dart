import 'package:anydrawer/anydrawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tablets/src/features/products/view/product_drawer_filters.dart';

class ProductDrawer {
  final AnyDrawerController drawerController = AnyDrawerController();
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
      controller: drawerController,
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

final transactionDrawerControllerProvider = Provider<ProductDrawer>((ref) {
  return ProductDrawer();
});
