import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tablets/generated/l10n.dart';
import 'package:tablets/src/constants/constants.dart' as constants;
import 'package:tablets/src/routers/go_router_provider.dart';

class MainDrawer extends StatelessWidget {
  const MainDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: MediaQuery.of(context).size.width * 0.17,
      child: Column(
        children: [
          const MainDrawerHeader(),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(
                vertical: MediaQuery.of(context).size.width * 0.01,
                horizontal: MediaQuery.of(context).size.width * 0.01,
              ),
              child: Column(
                children: [
                  const MainDrawerProductsButton(),
                  constants.DrawerGap.vertical,
                  const MainDrawerTransactionsButton(),
                  constants.DrawerGap.vertical,
                  const MainDrawerSalesmenMovementButton(),
                  constants.DrawerGap.vertical,
                  const MainDrawerSettingsButton(),
                  constants.DrawerGap.vertical,
                  const MainDrawerCategoriesButton(),
                  constants.PushWidgets.toEnd,
                  const MainDrawerPendingBillsButton(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class MainDrawerHeader extends StatelessWidget {
  const MainDrawerHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return DrawerHeader(
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Theme.of(context).colorScheme.primary,
            Theme.of(context).colorScheme.primary.withOpacity(0.7),
          ],
        ),
      ),
      child: Column(
        children: [
          SizedBox(
            // margin: const EdgeInsets.all(10),
            width: double.infinity,
            height: MediaQuery.of(context).size.width * 0.1, // here I used width intentionally
            child: Image.asset('assets/images/logo.png', fit: BoxFit.scaleDown),
          ),
          // Text(
          //   S.of(context).slogan,
          //   style: const TextStyle(fontSize: 14, color: Colors.white),
          // ),
        ],
      ),
    );
  }
}

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
