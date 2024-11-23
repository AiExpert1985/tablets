import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tablets/src/common/providers/page_is_loading_notifier.dart';
import 'package:tablets/src/common/values/features_keys.dart';
import 'package:tablets/src/common/values/gaps.dart';
import 'package:tablets/src/common/widgets/main_frame.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:tablets/src/common/providers/image_picker_provider.dart';
import 'package:tablets/src/features/products/controllers/product_drawer_provider.dart';
import 'package:tablets/src/features/products/controllers/product_form_data_notifier.dart';
import 'package:tablets/src/features/products/controllers/product_report_controller.dart';
import 'package:tablets/src/features/products/controllers/product_screen_data_notifier.dart';
import 'package:tablets/src/features/products/view/product_form.dart';
import 'package:tablets/generated/l10n.dart';
import 'package:tablets/src/common/values/constants.dart';
import 'package:tablets/src/common/widgets/home_screen.dart';
import 'package:tablets/src/common/widgets/main_screen_list_cells.dart';
import 'package:tablets/src/features/products/repository/product_db_cache_provider.dart';
import 'package:tablets/src/common/values/settings.dart';
import 'package:tablets/src/features/products/model/product.dart';

class ProductsScreen extends ConsumerWidget {
  const ProductsScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(productDbCacheProvider);
    return const AppScreenFrame(
      ProductsList(),
      buttonsWidget: ProductFloatingButtons(),
    );
  }
}

class ProductsList extends ConsumerWidget {
  const ProductsList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dbCache = ref.read(productDbCacheProvider.notifier);
    final dbData = dbCache.data;
    ref.watch(productScreenDataNotifier);
    final pageIsLoading = ref.read(pageIsLoadingNotifier);
    ref.watch(pageIsLoadingNotifier);
    if (pageIsLoading) {
      return const PageLoading();
    }
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
    final screenDataNotifier = ref.read(productScreenDataNotifier.notifier);
    final screenData = screenDataNotifier.data;
    ref.watch(productScreenDataNotifier);
    return Expanded(
      child: ListView.builder(
        itemCount: screenData.length,
        itemBuilder: (ctx, index) {
          final productData = screenData[index];
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
    return Column(
      children: [
        Row(
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
        ),
        VerticalGap.m,
        if (!hideMainScreenColumnTotals) const HeaderTotalsRow()
      ],
    );
  }
}

class HeaderTotalsRow extends ConsumerWidget {
  const HeaderTotalsRow({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(productScreenDataNotifier);
    final screenDataNotifier = ref.read(productScreenDataNotifier.notifier);
    final summary = screenDataNotifier.summary;
    final totalStockPrice = summary[productTotalStockPriceKey]?['value'] ?? '';

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const MainScreenPlaceholder(width: 20, isExpanded: false),
        const MainScreenPlaceholder(),
        const MainScreenPlaceholder(),
        const MainScreenPlaceholder(),
        const MainScreenPlaceholder(),
        const MainScreenPlaceholder(),
        const MainScreenPlaceholder(),
        const MainScreenPlaceholder(),
        const MainScreenPlaceholder(),
        MainScreenHeaderCell(totalStockPrice, isColumnTotal: true),
        const MainScreenPlaceholder(),
      ],
    );
  }
}

class DataRow extends ConsumerWidget {
  const DataRow(this.productScreenData, {super.key});
  final Map<String, dynamic> productScreenData;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final reportController = ref.read(productReportControllerProvider);
    final productRef = productScreenData[productDbRefKey];
    final productDbCache = ref.read(productDbCacheProvider.notifier);
    final productData = productDbCache.getItemByDbRef(productRef);
    final product = Product.fromMap(productData);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          MainScreenEditButton(defaultImageUrl, () => _showEditProductForm(context, ref, product)),
          MainScreenTextCell(productScreenData[productCodeKey]),
          MainScreenTextCell(productScreenData[productNameKey]),
          MainScreenTextCell(productScreenData[productCategoryKey]),
          MainScreenTextCell(productScreenData[productCommissionKey]),
          if (!hideProductBuyingPrice) MainScreenTextCell(productScreenData[productBuyingPriceKey]),
          MainScreenTextCell(productScreenData[productSellingWholeSaleKey]),
          MainScreenTextCell(productScreenData[productSellingRetailKey]),
          MainScreenClickableCell(
              productScreenData[productQuantityKey],
              () => reportController.showHistoryReport(
                  context, productScreenData[productQuantityDetailsKey], product.name)),
          MainScreenTextCell(productScreenData[productTotalStockPriceKey]),
          MainScreenClickableCell(
              (productScreenData[productProfitKey]),
              () => reportController.showProfitReport(
                  context, productScreenData[productProfitDetailsKey], product.name)),
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
