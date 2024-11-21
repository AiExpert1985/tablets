import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tablets/src/common/widgets/main_frame.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:tablets/src/common/providers/image_picker_provider.dart';
import 'package:tablets/src/features/products/controllers/product_drawer_provider.dart';
import 'package:tablets/src/features/products/controllers/product_form_data_notifier.dart';
import 'package:tablets/src/features/products/controllers/product_report_controller.dart';
import 'package:tablets/src/features/products/controllers/product_screen_data_provider.dart';
import 'package:tablets/src/features/products/view/product_form.dart';
import 'package:tablets/generated/l10n.dart';
import 'package:tablets/src/common/values/constants.dart';
import 'package:tablets/src/common/widgets/home_screen.dart';
import 'package:tablets/src/common/widgets/main_screen_list_cells.dart';
import 'package:tablets/src/features/products/repository/product_db_cache_provider.dart';
import 'package:tablets/src/features/products/controllers/product_screen_controller.dart';
import 'package:tablets/src/common/values/settings.dart';
import 'package:tablets/src/features/products/model/product.dart';

class ProductsScreen extends ConsumerWidget {
  const ProductsScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // I need to read and watch db for one reason, which is hiding floating buttons when
    // page is accessed by refresh and not throught the side bar
    final dbCache = ref.read(productDbCacheProvider.notifier).data;
    ref.watch(productDbCacheProvider);
    return AppScreenFrame(
      const ProductsList(),
      buttonsWidget: dbCache.isEmpty ? null : const ProductFloatingButtons(),
    );
  }
}

class ProductsList extends ConsumerWidget {
  const ProductsList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dbCache = ref.read(productDbCacheProvider.notifier);
    final dbData = dbCache.data;
    ref.watch(productDbCacheProvider);

    Widget screenWidget = dbData.isNotEmpty
        ? const Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              children: [
                ListHeaders(),
                Divider(),
                ListData(),
              ],
            ),
          )
        : const HomeScreenGreeting();
    return screenWidget;
  }
}

class ListData extends ConsumerWidget {
  const ListData({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dbCache = ref.read(productDbCacheProvider.notifier);
    final dbData = dbCache.data;
    ref.watch(productDbCacheProvider);
    return Expanded(
      child: ListView.builder(
        itemCount: dbData.length,
        itemBuilder: (ctx, index) {
          final productData = dbData[index];
          return Column(
            children: [
              DataRow(productData),
              const Divider(thickness: 0.2, color: Colors.grey),
            ],
          );
        },
      ),
    );
  }
}

class ListHeaders extends StatelessWidget {
  const ListHeaders({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const MainScreenPlaceholder(width: 20, isExpanded: false),
        MainScreenHeaderCell(S.of(context).product_code),
        MainScreenHeaderCell(S.of(context).product_name),
        MainScreenHeaderCell(S.of(context).product_category),
        MainScreenHeaderCell(S.of(context).product_salesman_commission),
        if (!hideProductBuyingPrice) MainScreenHeaderCell(S.of(context).product_buying_price),
        MainScreenHeaderCell(S.of(context).product_sell_whole_price),
        MainScreenHeaderCell(S.of(context).product_sell_retail_price),
        MainScreenHeaderCell(S.of(context).product_stock_quantity),
        MainScreenHeaderCell(S.of(context).product_stock_amount),
        MainScreenHeaderCell(S.of(context).product_profits),
      ],
    );
  }
}

class DataRow extends ConsumerWidget {
  const DataRow(this.productData, {super.key});
  final Map<String, dynamic> productData;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final product = Product.fromMap(productData);
    final screenController = ref.read(productScreenControllerProvider);
    screenController.createProductScreenData(context, product);
    final screenDataProvider = ref.read(productScreenDataProvider);
    final productScreenData = screenDataProvider.getItemData(product.dbRef);
    final totalQuantity = productScreenData[quantityKey] as double;
    final productTransactions = productScreenData[quantityDetailsKey] as List<List<dynamic>>;
    // profit doesn't include salesman commission
    final totalItemProfit = productScreenData[profitKey] as double;
    final profitInvoices = productScreenData[profitDetailsKey] as List<List<dynamic>>;
    final totalStockPrice = productScreenData[totalStockPriceKey] as double;
    final reportController = ref.read(productReportControllerProvider);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          MainScreenEditButton(defaultImageUrl, () => _showEditProductForm(context, ref, product)),
          MainScreenTextCell('${product.code}'),
          MainScreenTextCell(product.name),
          MainScreenTextCell(product.category),
          MainScreenTextCell('${product.salesmanCommission}'),
          if (!hideProductBuyingPrice) MainScreenTextCell('${product.buyingPrice}'),
          MainScreenTextCell('${product.sellWholePrice}'),
          MainScreenTextCell('${product.sellRetailPrice}'),
          MainScreenClickableCell('$totalQuantity',
              () => reportController.showHistoryReport(context, productTransactions, product.name)),
          MainScreenTextCell('$totalStockPrice'),
          MainScreenClickableCell(('$totalItemProfit'),
              () => reportController.showProfitReport(context, profitInvoices, product.name)),
        ],
      ),
    );
  }
}

void _showEditProductForm(BuildContext context, WidgetRef ref, Product product) {
  final imagePickerNotifier = ref.read(imagePickerProvider.notifier);
  final formDataNotifier = ref.read(productFormDataProvider.notifier);
  formDataNotifier.initialize(initialData: product.toMap());
  imagePickerNotifier.initialize(urls: product.imageUrls);
  showDialog(
    context: context,
    builder: (BuildContext ctx) => const ProductForm(isEditMode: true),
  ).whenComplete(imagePickerNotifier.close);
}

class ProductFloatingButtons extends ConsumerWidget {
  const ProductFloatingButtons({super.key});

  void showAddProductForm(BuildContext context, WidgetRef ref) {
    ref.read(productFormDataProvider.notifier).initialize();
    final imagePicker = ref.read(imagePickerProvider.notifier);
    imagePicker.initialize();
    showDialog(
      context: context,
      builder: (BuildContext ctx) => const ProductForm(),
    ).whenComplete(imagePicker.close);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final drawerController = ref.watch(productsDrawerControllerProvider);
    const iconsColor = Color.fromARGB(255, 126, 106, 211);
    return SpeedDial(
      direction: SpeedDialDirection.up,
      switchLabelPosition: false,
      animatedIcon: AnimatedIcons.menu_close,
      spaceBetweenChildren: 10,
      animatedIconTheme: const IconThemeData(size: 28.0),
      visible: true,
      curve: Curves.bounceInOut,
      children: [
        SpeedDialChild(
          child: const Icon(Icons.pie_chart, color: Colors.white),
          backgroundColor: iconsColor,
          onTap: () => drawerController.showReports(context),
        ),
        SpeedDialChild(
          child: const Icon(Icons.search, color: Colors.white),
          backgroundColor: iconsColor,
          onTap: () => drawerController.showSearchForm(context),
        ),
        SpeedDialChild(
          child: const Icon(Icons.add, color: Colors.white),
          backgroundColor: iconsColor,
          onTap: () => showAddProductForm(context, ref),
        ),
      ],
    );
  }
}
