import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tablets/generated/l10n.dart';
import 'package:tablets/src/common/classes/db_repository.dart';
import 'package:tablets/src/common/classes/item_form_data.dart';
import 'package:tablets/src/features/products/utils/product_report_utils.dart';
import 'package:tablets/src/features/products/utils/product_screen_utils.dart';
import 'package:tablets/src/common/providers/image_picker_provider.dart';
import 'package:tablets/src/common/values/settings.dart';
import 'package:tablets/src/common/widgets/async_value_widget.dart';
import 'package:tablets/src/features/products/controllers/product_filtered_list_provider.dart';
import 'package:tablets/src/features/products/controllers/product_filter_controller_provider.dart';
import 'package:tablets/src/features/products/controllers/product_form_controller.dart';
import 'package:tablets/src/features/products/model/product.dart';
import 'package:tablets/src/common/values/constants.dart' as constants;
import 'package:tablets/src/features/products/repository/product_repository_provider.dart';
import 'package:tablets/src/features/products/view/product_form.dart';
import 'package:tablets/src/features/transactions/repository/transaction_repository_provider.dart';

List<Map<String, dynamic>> _transactionsList = [];

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
  final productStream = ref.watch(productStreamProvider);
  final filterIsOn = ref.watch(productFilterSwitchProvider);
  final productsListValue =
      filterIsOn ? ref.read(productFilteredListProvider).getFilteredList() : productStream;

  return AsyncValueWidget<List<Map<String, dynamic>>>(
    value: productsListValue,
    data: (products) {
      _processProductTransactions(context, products);
      return Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildHeaderRow(context),
            const Divider(), // Divider to separate header from the list
            _buildDataRows(context, products, formDataNotifier, imagePicker),
          ],
        ),
      );
    },
  );
}

Widget _buildHeaderRow(BuildContext context) {
  return Row(
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
        Expanded(child: _buildDataCell('${(totalQuantity * product.buyingPrice)}')),
        Expanded(child: _buildDataCell('TODO')),
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

List<Product> _productsList = [];
List<List<List<dynamic>>> _productProcessedTransactionsList = [];
List<double> _productTotalQuantityList = [];
List<double> _productTotalProfitsList = [];
List<double> _productTotalCommissionsList = [];

void _processProductTransactions(BuildContext context, List<Map<String, dynamic>> products) {
  for (var productData in products) {
    final product = Product.fromMap(productData);
    _productsList.add(product);
    final productProcessedTransactions =
        getProductProcessedTransactions(context, _transactionsList, product);
    _productProcessedTransactionsList.add(productProcessedTransactions);
    final productTotals = getProductTotals(productProcessedTransactions, product);
    _productTotalQuantityList.add(productTotals[0]);
    _productTotalProfitsList.add(productTotals[1]);
    _productTotalCommissionsList.add(productTotals[2]);
  }
  //   // if customer has initial credit, it should be added to the tansactions, so, we add
  //   // it here and give it transaction type 'initialCredit'
  //   if (customer.initialCredit > 0) {
  //     customerTransactions.add(Transaction(
  //       dbRef: 'na',
  //       name: customer.name,
  //       imageUrls: ['na'],
  //       number: 1000001,
  //       date: customer.initialDate,
  //       currency: 'na',
  //       transactionType: TransactionType.initialCredit.name,
  //       totalAmount: customer.initialCredit,
  //     ).toMap());
  //   }
  //   final processedInvoices = getCustomerProcessedInvoices(context, customerTransactions, customer);
  //   _processedInvoicesList.add(processedInvoices);
  //   final invoicesWithProfit = getInvoicesWithProfit(processedInvoices);
  //   _invoicesWithProfitList.add(invoicesWithProfit);
  //   final totalProfit = getTotalProfit(invoicesWithProfit, 5);
  //   _totalProfitList.add(totalProfit);
  //   final closedInvoices = getClosedInvoices(context, processedInvoices, 5);
  //   _closedInvoicesList.add(closedInvoices);
  //   final averageClosingDays = calculateAverageClosingDays(closedInvoices, 6);
  //   _averageInvoiceClosingDaysList.add(averageClosingDays);
  //   final openInvoices = getOpenInvoices(context, processedInvoices, 5);
  //   _openInvoicesList.add(openInvoices);
  //   final totalDebt = getTotalDebt(openInvoices, 7);
  //   _totalDebtList.add(totalDebt);
  //   final dueInvoices = getDueInvoices(context, openInvoices, 5);
  //   _dueInvoicesList.add(dueInvoices);
  //   final dueDebt = getDueDebt(dueInvoices, 7);
  //   _dueDebtList.add(dueDebt);
  //   final giftsAndDicounts = getGiftsAndDiscounts(context, customerTransactions);
  //   _giftsAndDiscountsList.add(giftsAndDicounts);
  //   final totalGiftsAmount = getTotalGiftsAndDiscounts(giftsAndDicounts, 4);
  //   _totalGiftsAmountList.add(totalGiftsAmount);
  // }
}
