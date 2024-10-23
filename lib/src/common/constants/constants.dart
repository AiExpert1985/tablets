const String defaultImageUrl =
    'https://firebasestorage.googleapis.com/v0/b/tablets-519a0.appspot.com/o/default%2Fdefault_image.PNG?alt=media&token=d142f689-e42f-46ca-bb4b-8ea68a714ba4';

const double categoryFormWidth = 350;
const double categoryFormHeight = 400;

const double productFormWidth = 600;
const double productFormHeight = 600;

const double invoiceFormWidth = 700;
const double invoiceFormHeight = 700;

const double salesmanFormWidth = 350;
const double salesmanFormHeight = 400;

const double customerFormWidth = 350;
const double customerFormHeight = 400;

enum FieldDataTypes { int, double, string, datetime }

enum TransactionTypes {
  expenditures,
  gifts,
  customerReceipt,
  vendorReceipt,
  venderReturn,
  customerReturn,
  venderInvoice,
  customerInvoice
}
