import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tablets/generated/l10n.dart';
import 'package:tablets/src/common/values/gaps.dart';
import 'package:tablets/src/routers/go_router_provider.dart';

Widget buildMainDrawer(BuildContext context, StateController<String> pageTitleNotifier) {
  return Drawer(
      width: 250,
      child: Column(children: [
        _buildDrawerHeader(context),
        Expanded(
            child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(children: [
                  _buildMainDrawerButton(context, pageTitleNotifier,
                      iconName: 'transactions',
                      title: S.of(context).transactions,
                      routeName: AppRoute.transactions.name),
                  VerticalGap.m,
                  _buildMainDrawerButton(context, pageTitleNotifier,
                      iconName: 'customers',
                      title: S.of(context).customers,
                      routeName: AppRoute.customers.name),
                  VerticalGap.m,
                  _buildMainDrawerButton(context, pageTitleNotifier,
                      iconName: 'vendors',
                      title: S.of(context).vendors,
                      routeName: AppRoute.vendors.name),
                  VerticalGap.m,
                  _buildMainDrawerButton(context, pageTitleNotifier,
                      iconName: 'salesman',
                      title: S.of(context).salesmen,
                      routeName: AppRoute.salesman.name),
                  VerticalGap.m,
                  _buildMainDrawerButton(context, pageTitleNotifier,
                      iconName: 'products',
                      title: S.of(context).products,
                      routeName: AppRoute.products.name),
                  VerticalGap.m,
                  _buildSettingsButton(context, pageTitleNotifier),
                  PushWidgets.toEnd,
                  _buildMainDrawerButton(context, pageTitleNotifier,
                      iconName: 'pending_transactions',
                      title: S.of(context).pending_transactions,
                      routeName: AppRoute.pendingTransactions.name),
                ])))
      ]));
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

Widget _buildMainDrawerButton(BuildContext context, StateController<String> pageTitleNotifier,
    {required iconName, required title, required routeName}) {
  return ListTile(
      leading: Image.asset(
        'assets/icons/side_drawer/$iconName.png',
        width: 30,
        fit: BoxFit.scaleDown,
      ),
      title: Text(title),
      onTap: () {
        pageTitleNotifier.state = title;
        Navigator.of(context).pop();
        context.goNamed(routeName);
      });
}

Widget _buildSettingsButton(BuildContext context, StateController<String> pageTitleNotifier) {
  final title = S.of(context).settings;
  return ListTile(
      leading: Image.asset(
        'assets/icons/side_drawer/settings.png',
        width: 30,
        fit: BoxFit.scaleDown,
      ),
      title: Text(title),
      onTap: () {
        Navigator.of(context).pop();
        showDialog(
            context: context,
            builder: (BuildContext ctx) => _showSettingDialog(context, pageTitleNotifier));
      });
}

Widget _showSettingDialog(BuildContext context, StateController<String> pageTitleNotifier) {
  final List<String> names = [
    S.of(context).categories,
    S.of(context).regions,
    S.of(context).settings,
  ];

  final List<String> routes = [
    AppRoute.categories.name,
    AppRoute.regions.name,
    AppRoute.settings.name
  ];

  return AlertDialog(
    alignment: Alignment.center,
    scrollable: true,
    content: Container(
      padding: const EdgeInsets.all(25),
      width: 300,
      height: 500,
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 1, // Number of columns
          childAspectRatio: 1.7, // Aspect ratio of each card
        ),
        itemCount: names.length,
        itemBuilder: (context, index) {
          return InkWell(
            onTap: () {
              pageTitleNotifier.state = names[index];
              Navigator.of(context).pop();
              context.goNamed(routes[index]);
            },
            child: Card(
              elevation: 4,
              margin: const EdgeInsets.all(16),
              child: SizedBox(
                height: 40, // Reduced height for the card
                child: Center(
                  child: Text(
                    names[index], // Use the corresponding name
                    style: const TextStyle(fontSize: 18),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    ),
  );
}
