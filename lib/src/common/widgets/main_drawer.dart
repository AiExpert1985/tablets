import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tablets/generated/l10n.dart';
import 'package:tablets/src/common/providers/page_title_provider.dart';
import 'package:tablets/src/common/values/gaps.dart';
import 'package:tablets/src/routers/go_router_provider.dart';

class MainDrawer extends ConsumerWidget {
  const MainDrawer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pageTitleNotifier = ref.read(pageTitleProvider.notifier);
    return Drawer(
        width: 250,
        child: Column(children: [
          const MainDrawerHeader(),
          Expanded(
              child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
                  child: Column(children: [
                    MainDrawerButton(
                      'transactions',
                      S.of(context).transactions,
                      () => _goToPage(
                        context,
                        pageTitleNotifier,
                        AppRoute.transactions.name,
                        S.of(context).transactions,
                      ),
                    ),
                    VerticalGap.l,
                    MainDrawerButton(
                      'customers',
                      S.of(context).customers,
                      () => _goToPage(context, pageTitleNotifier, AppRoute.customers.name,
                          S.of(context).customers),
                    ),
                    VerticalGap.l,
                    MainDrawerButton(
                      'vendors',
                      S.of(context).vendors,
                      () => _goToPage(
                          context, pageTitleNotifier, AppRoute.vendors.name, S.of(context).vendors),
                    ),
                    VerticalGap.l,
                    MainDrawerButton(
                      'salesman',
                      S.of(context).salesmen,
                      () => _goToPage(context, pageTitleNotifier, AppRoute.salesman.name,
                          S.of(context).salesmen),
                    ),
                    VerticalGap.l,
                    MainDrawerButton(
                      'products',
                      S.of(context).products,
                      () => _goToPage(context, pageTitleNotifier, AppRoute.products.name,
                          S.of(context).products),
                    ),
                    VerticalGap.l,
                    MainDrawerButton(
                      'settings',
                      S.of(context).settings,
                      () => _showSettingDialog(context),
                    ),
                    const Spacer(),
                    MainDrawerButton(
                      'pending_transactions',
                      S.of(context).pending_transactions,
                      () => _goToPage(context, pageTitleNotifier, AppRoute.pendingTransactions.name,
                          S.of(context).pending_transactions),
                    ),
                  ])))
        ]));
  }

  void _showSettingDialog(BuildContext context) {
    Navigator.of(context).pop();
    showDialog(
      context: context,
      builder: (BuildContext ctx) => const SettingsDialog(),
    );
  }

  void _goToPage(BuildContext context, StateController<String> pageTitleNotifier, String routeName,
      String title) {
    Navigator.of(context).pop();
    pageTitleNotifier.state = title;
    context.goNamed(routeName);
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

class MainDrawerButton extends ConsumerWidget {
  final String iconName;
  final String title;
  final VoidCallback onTap;

  const MainDrawerButton(
    this.iconName,
    this.title,
    this.onTap, {
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListTile(
        leading: Image.asset(
          'assets/icons/side_drawer/$iconName.png',
          width: 30,
          fit: BoxFit.scaleDown,
        ),
        title: Text(title),
        onTap: onTap);
  }
}

class SettingsDialog extends ConsumerWidget {
  const SettingsDialog({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pageTitleNotifier = ref.read(pageTitleProvider.notifier);
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
}
