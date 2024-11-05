import 'package:tablets/src/common/values/constants.dart';

const double categoryFormWidth = 350;
const double categoryFormHeight = 400;

const double productFormWidth = 600;
const double productFormHeight = 600;

const double customerInvoiceFormWidth = 800;
const double customerInvoiceFormHeight = 800;

const double salesmanFormWidth = 350;
const double salesmanFormHeight = 400;

const double customerFormWidth = 350;
const double customerFormHeight = 400;

final Map<String, dynamic> transactionFormDimenssions = {
  TransactionType.customerInvoice.name: {'height': 750, 'width': 800},
  TransactionType.venderInvoice.name: {'height': 700, 'width': 720},
  TransactionType.customerReturn.name: {'height': 700, 'width': 720},
};
