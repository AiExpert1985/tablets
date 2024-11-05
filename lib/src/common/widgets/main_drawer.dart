import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tablets/generated/l10n.dart';
import 'package:tablets/src/common/values/gaps.dart';
import 'package:tablets/src/routers/go_router_provider.dart';

class MainDrawer extends StatelessWidget {
  const MainDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
        width: 250,
        child: Column(children: [
          const MainDrawerHeader(),
          Expanded(
              child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(children: [
                    MainDrawerButton(
                        iconName: 'products',
                        title: S.of(context).products,
                        routeName: AppRoute.products.name),
                    VerticalGap.s,
                    MainDrawerButton(
                        iconName: 'categories',
                        title: S.of(context).categories,
                        routeName: AppRoute.categories.name),
                    VerticalGap.s,
                    MainDrawerButton(
                        iconName: 'transactions',
                        title: S.of(context).transactions,
                        routeName: AppRoute.transactions.name),
                    VerticalGap.s,
                    MainDrawerButton(
                        iconName: 'salesman',
                        title: S.of(context).salesmen,
                        routeName: AppRoute.salesman.name),
                    VerticalGap.s,
                    MainDrawerButton(
                        iconName: 'customers',
                        title: S.of(context).customers,
                        routeName: AppRoute.customers.name),
                    VerticalGap.s,
                    MainDrawerButton(
                        iconName: 'vendors',
                        title: S.of(context).vendors,
                        routeName: AppRoute.vendors.name),
                    VerticalGap.s,
                    MainDrawerButton(
                        iconName: 'settings',
                        title: S.of(context).settings,
                        routeName: AppRoute.settings.name),
                    PushWidgets.toEnd,
                    MainDrawerButton(
                        iconName: 'pending_transactions',
                        title: S.of(context).pending_transactions,
                        routeName: AppRoute.pendingTransactions.name),
                  ])))
        ]));
  }
}

class MainDrawerHeader extends StatelessWidget {
  const MainDrawerHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: 250,
        child: DrawerHeader(
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
            child: Column(children: [
              SizedBox(
                // margin: const EdgeInsets.all(10),
                width: double.infinity,
                height: 200, // here I used width intentionally
                child: Image.asset('assets/images/logo.png', fit: BoxFit.scaleDown),
              ),
              // Text(
              //   S.of(context).slogan,
              //   style: const TextStyle(fontSize: 14, color: Colors.white),
              // ),
            ])));
  }
}

class MainDrawerButton extends StatelessWidget {
  const MainDrawerButton(
      {required this.iconName, required this.title, required this.routeName, super.key});

  final String iconName;
  final String title;
  final String routeName;

  @override
  Widget build(BuildContext context) {
    return ListTile(
        leading: Image.asset(
          'assets/icons/side_drawer/$iconName.png',
          width: 30,
          fit: BoxFit.scaleDown,
        ),
        title: Text(title),
        onTap: () {
          Navigator.of(context).pop();
          context.goNamed(routeName);
        });
  }
}
