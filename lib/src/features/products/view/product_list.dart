import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tablets/generated/l10n.dart';
import 'package:tablets/src/common/classes/db_repository.dart';
import 'package:tablets/src/common/functions/debug_print.dart';
import 'package:tablets/src/common/functions/product_utils.dart';
import 'package:tablets/src/common/providers/image_picker_provider.dart';
import 'package:tablets/src/common/widgets/async_value_widget.dart';
import 'package:tablets/src/features/products/controllers/product_filtered_list_provider.dart';
import 'package:tablets/src/features/products/controllers/product_filter_controller_provider.dart';
import 'package:tablets/src/features/products/controllers/product_form_controller.dart';
import 'package:tablets/src/features/products/model/product.dart';
import 'package:tablets/src/common/values/constants.dart' as constants;
import 'package:tablets/src/features/products/repository/product_repository_provider.dart';
import 'package:tablets/src/features/products/view/product_form.dart';
import 'package:tablets/src/features/transactions/repository/transaction_repository_provider.dart';

List<Map<String, dynamic>> _allTransactions = [];

Future<void> _fetchTransactions(DbRepository transactionProvider) async {
  _allTransactions = await transactionProvider.fetchItemListAsMaps();
}

void showEditProductForm(BuildContext context, WidgetRef ref, Product product) {
  ref.read(productFormDataProvider.notifier).initialize(initialData: product.toMap());
  final imagePicker = ref.read(imagePickerProvider.notifier);
  imagePicker.initialize(urls: product.imageUrls);
  showDialog(
    context: context,
    builder: (BuildContext ctx) => const ProductForm(isEditMode: true),
  ).whenComplete(imagePicker.close);
}

Widget buildProductsList(BuildContext context, WidgetRef ref) {
  final transactionProvider = ref.read(transactionRepositoryProvider);
  _fetchTransactions(transactionProvider);
  final productStream = ref.watch(productStreamProvider);
  final filterIsOn = ref.watch(productFilterSwitchProvider);
  final productsListValue =
      filterIsOn ? ref.read(productFilteredListProvider).getFilteredList() : productStream;

  return AsyncValueWidget<List<Map<String, dynamic>>>(
    value: productsListValue,
    data: (products) {
      return Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Header Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const SizedBox(width: 16), // Placeholder for the avatar
                Expanded(child: _buildHeader(S.of(context).product_code)),
                Expanded(child: _buildHeader(S.of(context).product_name)),
                Expanded(child: _buildHeader(S.of(context).product_category)),
                Expanded(child: _buildHeader(S.of(context).product_salesman_commission)),
                Expanded(child: _buildHeader(S.of(context).product_buying_price)),
                Expanded(child: _buildHeader(S.of(context).product_sell_retail_price)),
                Expanded(child: _buildHeader(S.of(context).product_sell_whole_price)),
                Expanded(child: _buildHeader(S.of(context).product_stock_quantity)),
                Expanded(child: _buildHeader(S.of(context).product_stock_amount)),
              ],
            ),
            const Divider(), // Divider to separate header from the list
            Expanded(
              child: ListView.builder(
                itemCount: products.length,
                itemBuilder: (context, index) {
                  Product product = Product.fromMap(products[index]);
                  final productTransactions = getProductTransactions(_allTransactions, product);
                  final productTotals = getProductTotals(productTransactions, product);
                  final totalQuantity = productTotals[0];
                  tempPrint(productTotals);
                  return Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 6.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            InkWell(
                              child: const CircleAvatar(
                                radius: 15,
                                foregroundImage:
                                    CachedNetworkImageProvider(constants.defaultImageUrl),
                              ),
                              onTap: () => showEditProductForm(context, ref, product),
                            ),
                            Expanded(child: _buildDataCell(product.code.toString())),
                            Expanded(child: _buildDataCell(product.name)),
                            Expanded(child: _buildDataCell(product.category)),
                            Expanded(child: _buildDataCell(product.salesmanCommission.toString())),
                            Expanded(child: _buildDataCell(product.buyingPrice.toString())),
                            Expanded(child: _buildDataCell(product.sellRetailPrice.toString())),
                            Expanded(child: _buildDataCell(product.sellWholePrice.toString())),
                            Expanded(child: _buildDataCell(totalQuantity.toString())),
                            Expanded(
                                child: _buildDataCell(
                                    (totalQuantity * product.buyingPrice).toString())),
                          ],
                        ),
                      ),
                      const Divider(thickness: 0.3),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      );
    },
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
