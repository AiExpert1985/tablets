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
          _buildDrawerHeader(context),
          Expanded(
              child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(children: [
                    _buildMainDrawerButton(context,
                        iconName: 'transactions',
                        title: S.of(context).transactions,
                        routeName: AppRoute.transactions.name),
                    VerticalGap.s,
                    _buildMainDrawerButton(context,
                        iconName: 'customers',
                        title: S.of(context).customers,
                        routeName: AppRoute.customers.name),
                    VerticalGap.s,
                    _buildMainDrawerButton(context,
                        iconName: 'vendors',
                        title: S.of(context).vendors,
                        routeName: AppRoute.vendors.name),
                    VerticalGap.s,
                    _buildMainDrawerButton(context,
                        iconName: 'salesman',
                        title: S.of(context).salesmen,
                        routeName: AppRoute.salesman.name),
                    VerticalGap.s,
                    _buildMainDrawerButton(context,
                        iconName: 'products',
                        title: S.of(context).products,
                        routeName: AppRoute.products.name),
                    VerticalGap.s,
                    _buildMainDrawerButton(context,
                        iconName: 'categories',
                        title: S.of(context).categories,
                        routeName: AppRoute.categories.name),
                    VerticalGap.s,
                    _buildMainDrawerButton(context,
                        iconName: 'regions',
                        title: S.of(context).regions,
                        routeName: AppRoute.regions.name),
                    VerticalGap.s,
                    _buildMainDrawerButton(context,
                        iconName: 'settings',
                        title: S.of(context).settings,
                        routeName: AppRoute.settings.name),
                    PushWidgets.toEnd,
                    _buildMainDrawerButton(context,
                        iconName: 'pending_transactions',
                        title: S.of(context).pending_transactions,
                        routeName: AppRoute.pendingTransactions.name),
                  ])))
        ]));
  }
}

Widget _buildDrawerHeader(BuildContext context) {
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

Widget _buildMainDrawerButton(BuildContext context,
    {required iconName, required title, required routeName}) {
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
