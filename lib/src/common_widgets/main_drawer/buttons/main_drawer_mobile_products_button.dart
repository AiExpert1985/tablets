import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tablets/src/routers/go_router_provider.dart';

class MainDrawerMobileProductsButton extends StatelessWidget {
  const MainDrawerMobileProductsButton({super.key});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.mobile_friendly),
      title: const Text('Mobile Products'),
      onTap: () => context.goNamed(AppRoute.mobileProducts.name),
    );
  }
}
