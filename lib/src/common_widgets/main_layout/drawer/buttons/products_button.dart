import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tablets/generated/l10n.dart';
import 'package:tablets/src/routers/go_router_provider.dart';

class MainDrawerProductsButton extends StatelessWidget {
  const MainDrawerProductsButton({super.key});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Image.asset('assets/images/products.png', fit: BoxFit.scaleDown),
      title: Text(S.of(context).products),
      onTap: () => context.goNamed(AppRoute.products.name),
    );
  }
}
