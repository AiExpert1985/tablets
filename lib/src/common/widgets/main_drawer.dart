import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tablets/generated/l10n.dart';
import 'package:tablets/src/common/functions/data_backup.dart';
import 'package:tablets/src/common/functions/db_cache_inialization.dart';
import 'package:tablets/src/common/functions/utils.dart';
import 'package:tablets/src/common/providers/page_is_loading_notifier.dart';
import 'package:tablets/src/common/providers/page_title_provider.dart';
import 'package:tablets/src/common/values/gaps.dart';
import 'package:tablets/src/features/customers/controllers/customer_screen_controller.dart';
import 'package:tablets/src/features/products/controllers/product_screen_controller.dart';
import 'package:tablets/src/features/salesmen/controllers/salesman_screen_controller.dart';
import 'package:tablets/src/features/salesmen/repository/salesman_db_cache_provider.dart';
import 'package:tablets/src/features/settings/controllers/settings_form_data_notifier.dart';
import 'package:tablets/src/features/settings/repository/settings_repository_provider.dart';
import 'package:tablets/src/features/transactions/controllers/transaction_screen_controller.dart';
import 'package:tablets/src/features/transactions/repository/transaction_db_cache_provider.dart';
import 'package:tablets/src/features/vendors/controllers/vendor_screen_controller.dart';
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
                  HomeButton(),
                  VerticalGap.m,
                  TransactionsButton(),
                  VerticalGap.m,
                  CustomersButton(),
                  VerticalGap.m,
                  VendorsButton(),
                  VerticalGap.m,
                  SalesmenButton(),
                  VerticalGap.m,
                  ProductsButton(),
                  VerticalGap.m,
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

class HomeButton extends ConsumerWidget {
  const HomeButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pageTitleNotifier = ref.read(pageTitleProvider.notifier);
    return MainDrawerButton('home', S.of(context).home_page, () async {
      initializeSettings(ref);
      Navigator.of(context).pop();
      pageTitleNotifier.state = '';
      context.goNamed(AppRoute.home.name);
    });
  }
}

class CustomersButton extends ConsumerWidget {
  const CustomersButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final customerScreenController = ref.read(customerScreenControllerProvider);
    final pageTitleNotifier = ref.read(pageTitleProvider.notifier);
    final pageLoadingNotifier = ref.read(pageIsLoadingNotifier.notifier);
    return MainDrawerButton('customers', S.of(context).customers, () async {
      initializeSettings(ref);
      pageLoadingNotifier.state = true;
      //  we need related transactionDbCache, we make sure it is inialized
      await initializeTransactionDbCache(context, ref);
      if (context.mounted) {
        await initializeCustomerDbCache(context, ref);
      }
      if (context.mounted) {
        pageTitleNotifier.state = S.of(context).customers;
      }
      if (context.mounted) {
        customerScreenController.setFeatureScreenData(context);
      }
      // if (context.mounted) {
      //   final testClass = TestCustomerScreenPerformance(context, ref);
      //   testClass.run(10000);
      // }
      if (context.mounted) {
        Navigator.of(context).pop();
        context.goNamed(AppRoute.customers.name);
      }
      pageLoadingNotifier.state = false;
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
        initializeSettings(ref);
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
        initializeSettings(ref);
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
    final salesmanScreenController = ref.read(salesmanScreenControllerProvider);
    final pageTitleNotifier = ref.read(pageTitleProvider.notifier);
    final pageLoadingNotifier = ref.read(pageIsLoadingNotifier.notifier);
    return MainDrawerButton('salesman', S.of(context).salesmen, () async {
      initializeSettings(ref);
      pageLoadingNotifier.state = true;
      //  we need related transactionDbCache, we make sure it is inialized
      //  and we need related customerDbCache, we make sure it is inialized
      await initializeTransactionDbCache(context, ref);
      if (context.mounted) {
        await initializeCustomerDbCache(context, ref);
      }
      if (context.mounted) {
        await initializeSalesmanDbCache(context, ref);
      }
      if (context.mounted) {
        salesmanScreenController.setFeatureScreenData(context);
      }
      if (context.mounted) {
        pageTitleNotifier.state = S.of(context).salesmen;
      }
      if (context.mounted) {
        Navigator.of(context).pop();
        context.goNamed(AppRoute.salesman.name);
      }
      pageLoadingNotifier.state = false;
    });
  }
}

class VendorsButton extends ConsumerWidget {
  const VendorsButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final vendorScreenController = ref.read(vendorScreenControllerProvider);
    final pageTitleNotifier = ref.read(pageTitleProvider.notifier);
    final pageLoadingNotifier = ref.read(pageIsLoadingNotifier.notifier);
    return MainDrawerButton('vendors', S.of(context).vendors, () async {
      initializeSettings(ref);
      pageLoadingNotifier.state = true;
      //  we need related transactionDbCache, we make sure it is inialized
      await initializeTransactionDbCache(context, ref);
      if (context.mounted) {
        await initializeVendorDbCache(context, ref);
      }
      if (context.mounted) {
        vendorScreenController.setFeatureScreenData(context);
      }
      if (context.mounted) {
        pageTitleNotifier.state = S.of(context).vendors;
      }
      if (context.mounted) {
        Navigator.of(context).pop();
        context.goNamed(AppRoute.vendors.name);
      }
      pageLoadingNotifier.state = false;
    });
  }
}

class TransactionsButton extends ConsumerWidget {
  const TransactionsButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final transactionScreenController = ref.read(transactionScreenControllerProvider);
    final pageTitleNotifier = ref.read(pageTitleProvider.notifier);
    final pageLoadingNotifier = ref.read(pageIsLoadingNotifier.notifier);
    return MainDrawerButton('transactions', S.of(context).transactions, () async {
      initializeSettings(ref);
      pageLoadingNotifier.state = true;
      await initializeTransactionDbCache(context, ref);
      // initialize related dbCaches
      if (context.mounted) {
        await initializeCustomerDbCache(context, ref);
      }
      if (context.mounted) {
        await initializeProductDbCache(context, ref);
      }
      if (context.mounted) {
        transactionScreenController.setFeatureScreenData(context);
      }
      if (context.mounted) {
        pageTitleNotifier.state = S.of(context).transactions;
      }
      if (context.mounted) {
        Navigator.of(context).pop();
        context.goNamed(AppRoute.transactions.name);
      }
      pageLoadingNotifier.state = false;
    });
  }
}

class ProductsButton extends ConsumerWidget {
  const ProductsButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productScreenController = ref.read(productScreenControllerProvider);
    final pageTitleNotifier = ref.read(pageTitleProvider.notifier);
    final pageLoadingNotifier = ref.read(pageIsLoadingNotifier.notifier);
    return MainDrawerButton('products', S.of(context).products, () async {
      initializeSettings(ref);
      pageLoadingNotifier.state = true;
      //  we need related transactionDbCache, we make sure it is inialized
      await initializeTransactionDbCache(context, ref);
      if (context.mounted) {
        await initializeProductDbCache(context, ref);
      }
      if (context.mounted) {
        productScreenController.setFeatureScreenData(context);
      }
      // if (context.mounted) {
      //   final testClass = TestProductScreenPerformance(context, ref);
      //   testClass.run(1000);
      // }
      if (context.mounted) {
        pageTitleNotifier.state = S.of(context).products;
      }
      if (context.mounted) {
        context.goNamed(AppRoute.products.name);
        Navigator.of(context).pop();
      }
      pageLoadingNotifier.state = false;
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
              Text(
                S.of(context).slogan,
                style: const TextStyle(fontSize: 14, color: Colors.white),
              ),
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
    final List<String> names = [
      S.of(context).categories,
      S.of(context).regions,
      S.of(context).settings,
    ];

    final List<String> routes = [
      AppRoute.categories.name,
      AppRoute.regions.name,
      AppRoute.settings.name,
    ];

    return AlertDialog(
      alignment: Alignment.center,
      scrollable: true,
      content: Container(
        padding: const EdgeInsets.all(25),
        width: 300,
        height: 650,
        child: Column(
          children: [
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 1, // Number of columns
                  childAspectRatio: 1.7, // Aspect ratio of each card
                ),
                itemCount: names.length,
                itemBuilder: (context, index) {
                  return SettingChildButton(names[index], routes[index]);
                },
              ),
            ),
            const BackupButton(),
          ],
        ),
      ),
    );
  }
}

class SettingChildButton extends ConsumerWidget {
  const SettingChildButton(this.name, this.route, {super.key});

  final String name;
  final String route;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pageTitleNotifier = ref.read(pageTitleProvider.notifier);
    return InkWell(
      onTap: () {
        pageTitleNotifier.state = name;
        if (context.mounted) {
          context.goNamed(route);
        }
        if (context.mounted) {
          Navigator.of(context).pop();
        }
      },
      child: Card(
        elevation: 4,
        margin: const EdgeInsets.all(16),
        child: SizedBox(
          height: 40, // Reduced height for the card
          child: Center(
            child: Text(
              name, // Use the corresponding name
              style: const TextStyle(fontSize: 18),
            ),
          ),
        ),
      ),
    );
  }
}

class BackupButton extends ConsumerWidget {
  const BackupButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SizedBox(
      height: 150,
      child: InkWell(
        onTap: () {
          final dataBaseMaps = _getDataBaseMaps(context, ref);
          final dataBaseNames = _getDataBaseNames(context);
          backupDatabase(dataBaseMaps, dataBaseNames);
        },
        child: Card(
          elevation: 4,
          margin: const EdgeInsets.all(16),
          child: SizedBox(
            height: 40, // Reduced height for the card
            child: Center(
              child: Text(
                S.of(context).save_data_backup, // Use the corresponding name
                style: const TextStyle(fontSize: 18),
              ),
            ),
          ),
        ),
      ),
    );
  }

  List<List<Map<String, dynamic>>> _getDataBaseMaps(BuildContext context, WidgetRef ref) {
    initializeTransactionDbCache(context, ref);
    initializeCustomerDbCache(context, ref);
    initializeSalesmanDbCache(context, ref);
    initializeProductDbCache(context, ref);
    initializeVendorDbCache(context, ref);
    final transactionsDbCache = ref.read(transactionDbCacheProvider.notifier);
    final transactionData = formatDateForJson(transactionsDbCache.data, 'date');
    final salesmenDbCache = ref.read(salesmanDbCacheProvider.notifier);
    final salesmanData = salesmenDbCache.data;
    if (context.mounted) {
      Navigator.of(context).pop();
    }
    final dataBaseMaps = [transactionData, salesmanData];
    return dataBaseMaps;
  }

  List<String> _getDataBaseNames(BuildContext context) {
    return [S.of(context).transactions, S.of(context).salesmen];
  }
}

void initializeSettings(WidgetRef ref) async {
  final settingsDataNotifier = ref.read(settingsFormDataProvider.notifier);
  if (settingsDataNotifier.data.isEmpty) {
    final settingRepository = ref.read(settingsRepositoryProvider);
    final settingsData = await settingRepository.fetchItemListAsMaps();
    settingsDataNotifier.initialize(initialData: settingsData[0]);
  }
}
