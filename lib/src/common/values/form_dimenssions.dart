import 'package:tablets/src/common/values/constants.dart';

const double categoryFormWidth = 350;
const double categoryFormHeight = 400;

const double regionFormWidth = 350;
const double regionFormHeight = 400;

const double productFormWidth = 600;
const double productFormHeight = 600;

const double customerInvoiceFormWidth = 800;
const double customerInvoiceFormHeight = 800;

const double salesmanFormWidth = 350;
const double salesmanFormHeight = 400;

const double customerFormWidth = 350;
const double customerFormHeight = 400;

const double vendorFormWidth = 350;
const double vendorFormHeight = 400;

final Map<String, dynamic> transactionFormDimenssions = {
  TransactionType.customerInvoice.name: {'height': 750, 'width': 800},
  TransactionType.vendorInvoice.name: {'height': 750, 'width': 800},
  TransactionType.customerReturn.name: {'height': 750, 'width': 800},
  TransactionType.vendorReturn.name: {'height': 750, 'width': 800},
  TransactionType.customerReceipt.name: {'height': 500, 'width': 800},
  TransactionType.vendorReceipt.name: {'height': 500, 'width': 800},
  TransactionType.gifts.name: {'height': 630, 'width': 500},
  TransactionType.damagedItems.name: {'height': 630, 'width': 500},
  TransactionType.expenditures.name: {'height': 500, 'width': 500},
};
