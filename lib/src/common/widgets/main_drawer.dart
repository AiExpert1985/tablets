import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tablets/generated/l10n.dart';
import 'package:tablets/src/common/providers/page_title_provider.dart';
import 'package:tablets/src/common/values/gaps.dart';
import 'package:tablets/src/features/customers/controllers/customer_db_cache_provider.dart';
import 'package:tablets/src/features/customers/controllers/customer_screen_controller.dart';
import 'package:tablets/src/features/customers/controllers/customer_screen_data_notifier.dart';
import 'package:tablets/src/features/customers/repository/customer_repository_provider.dart';
import 'package:tablets/src/features/customers/utils/customer_map_keys.dart';
import 'package:tablets/src/features/products/controllers/product_db_cache_provider.dart';
import 'package:tablets/src/features/products/repository/product_repository_provider.dart';
import 'package:tablets/src/features/transactions/controllers/transaction_db_cache_provider.dart';
import 'package:tablets/src/features/transactions/repository/transaction_repository_provider.dart';
import 'package:tablets/src/routers/go_router_provider.dart';

class CustomersButton extends ConsumerWidget {
  const CustomersButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pageTitleNotifier = ref.read(pageTitleProvider.notifier);
    // create a button that is used in the main side bar
    return MainDrawerButton('customers', S.of(context).customers, () async {
      // set page title in the main top bar
      pageTitleNotifier.state = S.of(context).customers;

      // set the values in the customer cache
      // note that we only load data from database (firebase) once, that means, whenever a
      // change happened to products (add, update, delete), we update the cache and
      // database with same data, so there will be no ned to fetch from database
      final customerDbCache = ref.read(customerDbCacheProvider.notifier);
      if (customerDbCache.data.isEmpty) {
        final customerData = await ref.read(customerRepositoryProvider).fetchItemListAsMaps();
        customerDbCache.setData(customerData);
      }
      // also set other features cache that going to be used if they are not set by their feature
      final transactionDbCach = ref.read(transactionDbCacheProvider.notifier);
      if (transactionDbCach.data.isEmpty) {
        final transactionData = await ref.read(transactionRepositoryProvider).fetchItemListAsMaps();
        transactionDbCach.setData(transactionData);
      }

      if (context.mounted) {
        context.goNamed(AppRoute.customers.name);
        Navigator.of(context).pop();
      }
      // finally, we use the screenController wich internally updates the screenDataNotifier that
      //will be used by the screen List widget (which will display UI to the user)
      final screenController = ref.read(customerScreenControllerProvider);
      final customers = customerDbCache.data;
      if (context.mounted) {
        screenController.processCustomerTransactions(context, customers);
      }
      Map<String, dynamic> summaryTypes = {
        totalDebtKey: 'sum',
        openInvoicesKey: 'sum',
        dueInvoicesKey: 'sum',
        dueDebtKey: 'sum',
        avgClosingDaysKey: 'avg',
        invoicesProfitKey: 'sum',
        giftsKey: 'sum',
      };
      final screenDataNotifier = ref.read(customerScreenDataProvider.notifier);
      screenDataNotifier.initialize(summaryTypes);
    });
  }
}

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
                    MainDrawerButton('transactions', S.of(context).transactions, () {
                      Navigator.of(context).pop();
                      pageTitleNotifier.state = S.of(context).transactions;
                      context.goNamed(AppRoute.transactions.name);
                    }),
                    VerticalGap.l,
                    const CustomersButton(),
                    VerticalGap.l,
                    MainDrawerButton(
                      'vendors',
                      S.of(context).vendors,
                      () => _goToPage(
                          context, pageTitleNotifier, AppRoute.vendors.name, S.of(context).vendors),
                    ),
                    VerticalGap.l,
                    MainDrawerButton('salesman', S.of(context).salesmen, () {
                      Navigator.of(context).pop();
                      pageTitleNotifier.state = S.of(context).salesmen;
                      context.goNamed(AppRoute.salesman.name);
                    }),
                    VerticalGap.l,
                    MainDrawerButton('products', S.of(context).products, () async {
                      pageTitleNotifier.state = S.of(context).products;
                      final productDbCache = ref.read(productDbCacheProvider.notifier);
                      // we only load data from database (firebase) once, that means, whenever a
                      // change happened to products (add, update, delete), we update the cache and
                      // database with same data, so there will be no ned to fetch from database
                      if (productDbCache.data.isEmpty) {
                        final productData =
                            await ref.read(productRepositoryProvider).fetchItemListAsMaps();
                        productDbCache.setData(productData);
                      }
                      if (context.mounted) {
                        context.goNamed(AppRoute.products.name);
                        Navigator.of(context).pop();
                      }
                    }),
                    VerticalGap.l,
                    MainDrawerButton(
                      'settings',
                      S.of(context).settings,
                      () {
                        Navigator.of(context).pop();
                        showDialog(
                            context: context,
                            builder: (BuildContext ctx) => const SettingsDialog());
                      },
                    ),
                    const Spacer(),
                    MainDrawerButton(
                      'pending_transactions',
                      S.of(context).pending_transactions,
                      () {
                        Navigator.of(context).pop();
                        pageTitleNotifier.state = S.of(context).pending_transactions;
                        context.goNamed(AppRoute.pendingTransactions.name);
                      },
                    ),
                  ])))
        ]));
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
