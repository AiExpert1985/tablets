import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tablets/generated/l10n.dart';
import 'package:tablets/src/common/functions/db_cache_inialization.dart';
import 'package:tablets/src/common/providers/page_title_provider.dart';
import 'package:tablets/src/common/values/gaps.dart';
import 'package:tablets/src/features/customers/controllers/testing_screen_functions_performance.dart';
import 'package:tablets/src/routers/go_router_provider.dart';

class MainDrawer extends ConsumerWidget {
  const MainDrawer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return const Drawer(
      width: 250,
      child: Column(
        children: [
          MainDrawerHeader(),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 30, horizontal: 20),
              child: Column(
                children: [
                  TransactionsButton(),
                  VerticalGap.l,
                  CustomersButton(),
                  VerticalGap.l,
                  VendorsButton(),
                  VerticalGap.l,
                  SalesmenButton(),
                  VerticalGap.l,
                  ProductsButton(),
                  VerticalGap.l,
                  SettingsButton(),
                  Spacer(),
                  PendingsButton(),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

class CustomersButton extends ConsumerWidget {
  const CustomersButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MainDrawerButton('customers', S.of(context).customers, () async {
      //  we need related transactionDbCache, we make sure it is inialized
      await initializeTransactionDbCache(context, ref);
      if (context.mounted) {
        await initializeCustomerDbCache(context, ref);
      }
      final pageTitleNotifier = ref.read(pageTitleProvider.notifier);
      if (context.mounted) {
        pageTitleNotifier.state = S.of(context).customers;
      }
      // if (context.mounted) {
      //   final testClass = TestScreenPerformance(context, ref);
      //   testClass.run(10000);
      // }
      if (context.mounted) {
        Navigator.of(context).pop();
        context.goNamed(AppRoute.customers.name);
      }
    });
  }
}

class PendingsButton extends ConsumerWidget {
  const PendingsButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pageTitleNotifier = ref.read(pageTitleProvider.notifier);
    return MainDrawerButton(
      'pending_transactions',
      S.of(context).pending_transactions,
      () {
        Navigator.of(context).pop();
        pageTitleNotifier.state = S.of(context).pending_transactions;
        context.goNamed(AppRoute.pendingTransactions.name);
      },
    );
  }
}

class SettingsButton extends ConsumerWidget {
  const SettingsButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MainDrawerButton(
      'settings',
      S.of(context).settings,
      () {
        Navigator.of(context).pop();
        showDialog(context: context, builder: (BuildContext ctx) => const SettingsDialog());
      },
    );
  }
}

class SalesmenButton extends ConsumerWidget {
  const SalesmenButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MainDrawerButton('salesman', S.of(context).salesmen, () async {
      //  we need related transactionDbCache, we make sure it is inialized
      //  and we need related customerDbCache, we make sure it is inialized
      await initializeTransactionDbCache(context, ref);
      if (context.mounted) {
        await initializeCustomerDbCache(context, ref);
      }
      if (context.mounted) {
        await initializeSalesmanDbCache(context, ref);
      }
      final pageTitleNotifier = ref.read(pageTitleProvider.notifier);
      if (context.mounted) {
        pageTitleNotifier.state = S.of(context).salesmen;
      }
      if (context.mounted) {
        Navigator.of(context).pop();
        context.goNamed(AppRoute.salesman.name);
      }
    });
  }
}

class VendorsButton extends ConsumerWidget {
  const VendorsButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MainDrawerButton('vendors', S.of(context).vendors, () async {
      //  we need related transactionDbCache, we make sure it is inialized
      await initializeTransactionDbCache(context, ref);
      if (context.mounted) {
        await initializeVendorDbCache(context, ref);
      }
      final pageTitleNotifier = ref.read(pageTitleProvider.notifier);
      if (context.mounted) {
        pageTitleNotifier.state = S.of(context).vendors;
      }
      if (context.mounted) {
        Navigator.of(context).pop();
        context.goNamed(AppRoute.vendors.name);
      }
    });
  }
}

class TransactionsButton extends ConsumerWidget {
  const TransactionsButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MainDrawerButton('transactions', S.of(context).transactions, () async {
      await initializeTransactionDbCache(context, ref);
      final pageTitleNotifier = ref.read(pageTitleProvider.notifier);
      if (context.mounted) {
        pageTitleNotifier.state = S.of(context).transactions;
      }
      if (context.mounted) {
        Navigator.of(context).pop();
        context.goNamed(AppRoute.transactions.name);
      }
    });
  }
}

class ProductsButton extends ConsumerWidget {
  const ProductsButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MainDrawerButton('products', S.of(context).products, () async {
      //  we need related transactionDbCache, we make sure it is inialized
      await initializeTransactionDbCache(context, ref);
      if (context.mounted) {
        await initializeProductsDbCache(context, ref);
      }
      final pageTitleNotifier = ref.read(pageTitleProvider.notifier);
      if (context.mounted) {
        pageTitleNotifier.state = S.of(context).products;
      }
      if (context.mounted) {
        context.goNamed(AppRoute.products.name);
        Navigator.of(context).pop();
      }
    });
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
