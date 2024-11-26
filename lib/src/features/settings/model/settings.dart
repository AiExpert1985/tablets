import 'package:tablets/src/common/interfaces/base_item.dart';
import 'package:tablets/src/common/values/constants.dart';

enum PaymentType { cash, credit }

enum Currency { dinar, dollar }

class Settings implements BaseItem {
  @override
  String dbRef;
  @override
  String name;
  @override
  List<String> imageUrls;
  // switches
  bool hideTransactionAmountAsText;
  bool hideProductBuyingPrice;
  bool hideMainScreenColumnTotals;
  bool hideCustomerProfit;
  bool hideProductProfit;
  bool hideSalesmanProfit;
  bool showCompanyUrlBarCode;

// Sliders
  int maxDebtDuration;
  int printedCsutomerInvoices;
  int printedCsutomerReceipts;

  double maxDebtAmount;

  String companyUrl;
  String mainPageGreetingText;

// Radio buttons
  String paymentType;
  String currency;

  Settings({
    required this.dbRef,
    required this.name,
    required this.imageUrls,
    required this.hideTransactionAmountAsText,
    required this.hideProductBuyingPrice,
    required this.hideMainScreenColumnTotals,
    required this.hideCustomerProfit,
    required this.hideProductProfit,
    required this.hideSalesmanProfit,
    required this.showCompanyUrlBarCode,
    required this.maxDebtDuration,
    required this.printedCsutomerInvoices,
    required this.printedCsutomerReceipts,
    required this.maxDebtAmount,
    required this.companyUrl,
    required this.mainPageGreetingText,
    required this.paymentType,
    required this.currency,
  });

  @override
  String get coverImageUrl =>
      imageUrls.isNotEmpty ? imageUrls[imageUrls.length - 1] : defaultImageUrl;

  @override
  Map<String, dynamic> toMap() {
    return {
      'dbRef': dbRef,
      'name': name,
      'imageUrls': imageUrls,
      'hideTransactionAmountAsText': hideTransactionAmountAsText,
      'hideProductBuyingPrice': hideProductBuyingPrice,
      'hideMainScreenColumnTotals': hideMainScreenColumnTotals,
      'hideCustomerProfit': hideCustomerProfit,
      'hideProductProfit': hideProductProfit,
      'hideSalesmanProfit': hideSalesmanProfit,
      'showCompanyUrlBarCode': showCompanyUrlBarCode,
      'maxDebtDuration': maxDebtDuration,
      'printedCsutomerInvoices': printedCsutomerInvoices,
      'printedCsutomerReceipts': printedCsutomerReceipts,
      'maxDebtAmount': maxDebtAmount,
      'companyUrl': companyUrl,
      'mainPageGreetingText': mainPageGreetingText,
      'paymentType': paymentType,
      'currency': currency,
    };
  }

  factory Settings.fromMap(Map<String, dynamic> map) {
    return Settings(
      dbRef: map['dbRef'] ?? '',
      name: map['name'] ?? '',
      imageUrls: List<String>.from(map['imageUrls']),
      hideTransactionAmountAsText: map['hideTransactionAmountAsText'] ?? false,
      hideProductBuyingPrice: map['hideProductBuyingPrice'] ?? false,
      hideMainScreenColumnTotals: map['hideMainScreenColumnTotals'] ?? false,
      hideCustomerProfit: map['hideCustomerProfit'] ?? false,
      hideProductProfit: map['hideProductProfit'] ?? false,
      hideSalesmanProfit: map['hideSalesmanProfit'] ?? false,
      showCompanyUrlBarCode: map['showCompanyUrlBarCode'] ?? false,
      maxDebtDuration: map['maxDebtDuration']?.toInt() ?? 21,
      printedCsutomerInvoices: map['printedCsutomerInvoices']?.toInt() ?? 1,
      printedCsutomerReceipts: map['printedCsutomerReceipts']?.toInt() ?? 1,
      maxDebtAmount: map['maxDebtAmount']?.toDouble() ?? 1000000,
      companyUrl: map['companyUrl'] ?? '',
      mainPageGreetingText: map['mainPageGreetingText'] ?? '',
      paymentType: map['paymentType'] ?? PaymentType.credit.name,
      currency: map['currency'] ?? Currency.dinar.name,
    );
  }

  @override
  String toString() {
    return 'Settings for $name';
  }
}
