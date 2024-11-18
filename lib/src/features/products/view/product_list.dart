import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tablets/generated/l10n.dart';
import 'package:tablets/src/common/classes/db_repository.dart';
import 'package:tablets/src/common/classes/item_form_data.dart';
import 'package:tablets/src/common/functions/utils.dart';
import 'package:tablets/src/common/values/gaps.dart';
import 'package:tablets/src/features/products/controllers/product_db_cache_provider.dart';
import 'package:tablets/src/features/products/repository/product_repository_provider.dart';
import 'package:tablets/src/features/products/utils/product_report_utils.dart';
import 'package:tablets/src/features/products/utils/product_screen_utils.dart';
import 'package:tablets/src/common/providers/image_picker_provider.dart';
import 'package:tablets/src/common/values/settings.dart';
import 'package:tablets/src/features/products/model/product.dart';
import 'package:tablets/src/common/values/constants.dart' as constants;
import 'package:tablets/src/features/products/view/product_form.dart';
import 'package:tablets/src/features/transactions/repository/transaction_repository_provider.dart';
import 'package:tablets/src/features/products/controllers/product_form_data_notifier.dart';

List<Map<String, dynamic>> _transactionsList = [];
List<Product> _productsList = [];
List<List<List<dynamic>>> _productProcessedTransactionsList = [];
List<double> _productTotalQuantityList = [];
List<double> _productTotalProfitsList = [];
List<double> _productTotalCommissionsList = [];
List<double> _productTotalPriceList = [];

Future<void> _fetchTransactions(DbRepository transactionProvider) async {
  _transactionsList = await transactionProvider.fetchItemListAsMaps();
}

void showEditProductForm(BuildContext context, Product product, ItemFormData formDataNotifier,
    ImageSliderNotifier imagePickerNotifier) {
  formDataNotifier.initialize(initialData: product.toMap());
  imagePickerNotifier.initialize(urls: product.imageUrls);
  showDialog(
    context: context,
    builder: (BuildContext ctx) => const ProductForm(isEditMode: true),
  ).whenComplete(imagePickerNotifier.close);
}

Widget buildProductsList(BuildContext context, WidgetRef ref) {
  final formDataNotifier = ref.read(productFormDataProvider.notifier);
  final imagePicker = ref.read(imagePickerProvider.notifier);
  final transactionProvider = ref.read(transactionRepositoryProvider);
  _fetchTransactions(transactionProvider);
  final productDbCache = ref.read(productDbCacheProvider.notifier);
  final products = productDbCache.data;
  ref.watch(productDbCacheProvider); // important for reload button

  _processProductTransactions(context, products);
  Widget screenWidget = products.isNotEmpty
      ? Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              _buildHeaderRow(context),
              const Divider(), // Divider to separate header from the list
              _buildDataRows(context, products, formDataNotifier, imagePicker),
            ],
          ),
        )
      : Center(
          child: SizedBox(
            height: 80,
            width: 320,
            child: TextButton.icon(
              onPressed: () async {
                final productData = await ref.read(productRepositoryProvider).fetchItemListAsMaps();
                final productDbCache = ref.read(productDbCacheProvider.notifier);
                productDbCache.set(productData);
              },
              icon: const Icon(Icons.refresh),
              label: Text(
                S.of(context).reload_page,
                style: const TextStyle(fontSize: 20),
              ),
            ),
          ),
        );
  return screenWidget;
}

Widget _buildHeaderRow(BuildContext context) {
  double totalStockQuantity = _productTotalQuantityList.reduce((a, b) => a + b);
  double totalItemPriceWorth = _productTotalPriceList.reduce((a, b) => a + b);
  return Column(
    children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const SizedBox(width: 16), // Placeholder for the avatar
          Expanded(child: _buildHeader(S.of(context).product_code)),
          Expanded(child: _buildHeader(S.of(context).product_name)),
          Expanded(child: _buildHeader(S.of(context).product_category)),
          Expanded(child: _buildHeader(S.of(context).product_salesman_commission)),
          Visibility(
              visible: !hideProductBuyingPrice,
              child: Expanded(child: _buildHeader(S.of(context).product_buying_price))),
          Expanded(child: _buildHeader(S.of(context).product_sell_whole_price)),
          Expanded(child: _buildHeader(S.of(context).product_sell_retail_price)),
          Expanded(child: _buildHeader(S.of(context).product_stock_quantity)),
          Expanded(child: _buildHeader(S.of(context).product_stock_amount)),
          Expanded(child: _buildHeader(S.of(context).product_profits)),
        ],
      ),
      VerticalGap.m,
      Visibility(
        visible: !hideMainScreenColumnTotals,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Expanded(child: SizedBox()), // Placeholder for the avatar
            const Expanded(child: SizedBox()),
            const Expanded(child: SizedBox()),
            const Expanded(child: SizedBox()),
            const Expanded(child: SizedBox()),
            Visibility(visible: !hideProductBuyingPrice, child: const SizedBox(width: 16)),
            const Expanded(child: SizedBox()),
            const Expanded(child: SizedBox()),
            Expanded(child: _buildHeader('(${doubleToStringWithComma(totalStockQuantity)})')),
            Expanded(child: _buildHeader('(${doubleToStringWithComma(totalItemPriceWorth)})')),
            const Expanded(child: SizedBox()),
          ],
        ),
      ),
    ],
  );
}

Widget _buildDataRows(BuildContext context, List<Map<String, dynamic>> products,
    ItemFormData formDataNotifier, ImageSliderNotifier imagePickerNotifier) {
  return Expanded(
    child: ListView.builder(
      itemCount: products.length,
      itemBuilder: (ctx, index) {
        return Column(
          children: [
            _buildDataRow(ctx, index, imagePickerNotifier, formDataNotifier),
            const Divider(thickness: 0.3),
          ],
        );
      },
    ),
  );
}

Widget _buildDataRow(
  BuildContext context,
  int index,
  ImageSliderNotifier imagePickerNotifier,
  ItemFormData formDataNotifier,
) {
  Product product = _productsList[index];
  final productTransactions = _productProcessedTransactionsList[index];
  final totalQuantity = _productTotalQuantityList[index];
  final totalItemProfit = _productTotalProfitsList[index]; // profit doesn't include commission
  final profitInvoices = getOnlyProfitInvoices(productTransactions, 5);
  final totalItemPriceWorth = _productTotalPriceList[index];
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 6.0),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        InkWell(
          child: const CircleAvatar(
            radius: 15,
            foregroundImage: CachedNetworkImageProvider(constants.defaultImageUrl),
          ),
          onTap: () => showEditProductForm(context, product, formDataNotifier, imagePickerNotifier),
        ),
        Expanded(child: _buildDataCell('${product.code}')),
        Expanded(child: _buildDataCell(product.name)),
        Expanded(child: _buildDataCell(product.category)),
        Expanded(child: _buildDataCell('${product.salesmanCommission}')),
        Visibility(
          visible: !hideProductBuyingPrice,
          child: Expanded(child: _buildDataCell('${product.buyingPrice}')),
        ),
        Expanded(child: _buildDataCell('${product.sellWholePrice}')),
        Expanded(child: _buildDataCell('${product.sellRetailPrice}')),
        Expanded(
          child: InkWell(
            child: _buildDataCell('$totalQuantity'),
            onTap: () => showHistoryReport(context, productTransactions, product.name),
          ),
        ),
        Expanded(child: _buildDataCell('$totalItemPriceWorth')),
        Expanded(
          child: InkWell(
            child: _buildDataCell('$totalItemProfit'),
            onTap: () => showProfitReport(context, profitInvoices, product.name),
          ),
        ),
      ],
    ),
  );
}

Widget _buildHeader(String text) {
  return Text(
    text,
    textAlign: TextAlign.center,
    style: const TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.bold,
    ),
  );
}

Widget _buildDataCell(String text) {
  return Text(
    text,
    textAlign: TextAlign.center,
    style: const TextStyle(fontSize: 16),
  );
}

void _processProductTransactions(BuildContext context, List<Map<String, dynamic>> products) {
  _resetGlobalLists();
  for (var productData in products) {
    final product = Product.fromMap(productData);
    _productsList.add(product);
    final productProcessedTransactions =
        getProductProcessedTransactions(context, _transactionsList, product);
    _productProcessedTransactionsList.add(productProcessedTransactions);
    final productTotals = getProductTotals(productProcessedTransactions);
    final quantity = productTotals[0];
    final profit = productTotals[1];
    final commission = productTotals[2];
    final totalPrice = quantity * product.buyingPrice;
    _productTotalQuantityList.add(quantity);
    _productTotalProfitsList.add(profit);
    _productTotalCommissionsList.add(commission);
    _productTotalPriceList.add(totalPrice);
  }
}

void _resetGlobalLists() {
  _productsList = [];
  _productProcessedTransactionsList = [];
  _productTotalQuantityList = [];
  _productTotalProfitsList = [];
  _productTotalCommissionsList = [];
  _productTotalPriceList = [];
}
