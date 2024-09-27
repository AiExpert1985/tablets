import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tablets/generated/l10n.dart';
import 'package:tablets/src/routers/go_router_provider.dart';

class MainDrawerCategoriesButton extends StatelessWidget {
  const MainDrawerCategoriesButton({super.key});

  @override
  Widget build(BuildContext context) {
    return ListTile(
        leading: Image.asset(
          'assets/icons/side_drawer/categories.png',
          width: 30,
          fit: BoxFit.scaleDown,
        ),
        title: Text(S.of(context).categories),
        onTap: () {
          Navigator.of(context).pop();
          context.goNamed(AppRoute.categories.name);
        });
  }
}
