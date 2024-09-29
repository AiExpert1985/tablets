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

class MainDrawerPendingBillsButton extends StatelessWidget {
  const MainDrawerPendingBillsButton({super.key});

  @override
  Widget build(BuildContext context) {
    return ListTile(
        leading: const Icon(Icons.settings),
        title: Text(S.of(context).pending_bills),
        onTap: () {
          Navigator.of(context).pop();
          context.goNamed(AppRoute.pendingBills.name);
        });
  }
}

class MainDrawerProductsButton extends StatelessWidget {
  const MainDrawerProductsButton({super.key});

  @override
  Widget build(BuildContext context) {
    return ListTile(
        leading: Image.asset(
          'assets/icons/side_drawer/products.png',
          width: 30,
          fit: BoxFit.scaleDown,
        ),
        title: Text(S.of(context).products),
        onTap: () {
          Navigator.of(context).pop();
          context.goNamed(AppRoute.products.name);
        });
  }
}

class MainDrawerSalesmenMovementButton extends StatelessWidget {
  const MainDrawerSalesmenMovementButton({super.key});

  @override
  Widget build(BuildContext context) {
    return ListTile(
        leading: const Icon(Icons.settings),
        title: Text(S.of(context).salesmen_movement),
        onTap: () {
          Navigator.of(context).pop();
          context.goNamed(AppRoute.salesmen.name);
        });
  }
}

class MainDrawerSettingsButton extends StatelessWidget {
  const MainDrawerSettingsButton({super.key});

  @override
  Widget build(BuildContext context) {
    return ListTile(
        leading: const Icon(Icons.settings),
        title: Text(S.of(context).settings),
        onTap: () {
          Navigator.of(context).pop();
          context.goNamed(AppRoute.settings.name);
        });
  }
}

class MainDrawerTransactionsButton extends StatelessWidget {
  const MainDrawerTransactionsButton({super.key});

  @override
  Widget build(BuildContext context) {
    return ListTile(
        leading: const Icon(Icons.settings),
        title: Text(S.of(context).transactions),
        onTap: () {
          Navigator.of(context).pop();
          context.goNamed(AppRoute.transactions.name);
        });
  }
}
