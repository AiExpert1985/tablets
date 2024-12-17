import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:pdf/widgets.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:tablets/generated/l10n.dart';
import 'package:tablets/src/common/functions/utils.dart';
import 'package:tablets/src/common/printing/print_document.dart';
import 'package:tablets/src/features/customers/controllers/customer_screen_controller.dart';
import 'package:tablets/src/features/customers/repository/customer_db_cache_provider.dart';
import 'package:tablets/src/features/salesmen/repository/salesman_db_cache_provider.dart';
import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';

Future<Document> getCustomerReceiptPdf(BuildContext context, WidgetRef ref,
    Map<String, dynamic> transactionData, pw.ImageProvider image) async {
  final pdf = pw.Document();
  final customerDbCache = ref.read(customerDbCacheProvider.notifier);
  final customerData = customerDbCache.getItemByDbRef(transactionData['nameDbRef']);
  final salesmanDbCache = ref.read(salesmanDbCacheProvider.notifier);
  final salesmanData = salesmanDbCache.getItemByDbRef(transactionData['salesmanDbRef']);
  final type = translateDbTextToScreenText(context, transactionData['transactionType']);
  final number = transactionData['number'].toString();
  final customerName = transactionData['name'];
  final customerPhone = customerData['phone'] ?? '';
  final customerRegion = customerData['region'] ?? '';
  final salesmanName = salesmanData['name'] ?? '';
  final salesmanPhone = salesmanData['phone'] ?? '';
  final paymentType = translateDbTextToScreenText(context, S.of(context).transaction_payment_cash);
  final date = formatDate(transactionData['date']);
  final subtotalAmount = doubleToStringWithComma(transactionData['subTotalAmount']);
  final discount = doubleToStringWithComma(transactionData['discount']);
  final currency = translateDbTextToScreenText(context, transactionData['currency']);
  final now = DateTime.now();
  final printingDate = DateFormat.yMd('ar').format(now);
  final printingTime = DateFormat.jm('ar').format(now);
  final notes = transactionData['notes'];
  final customerScreenController = ref.read(customerScreenControllerProvider);
  final customerScreenData = customerScreenController.getItemScreenData(context, customerData);
  final debtAfter = doubleToStringWithComma(customerScreenData['totalDebt']);
  final debtBefore =
      doubleToStringWithComma(customerScreenData['totalDebt'] + transactionData['totalAmount']);
  final arabicFont =
      pw.Font.ttf(await rootBundle.load("assets/fonts/NotoSansArabic-VariableFont_wdth,wght.ttf"));

  pdf.addPage(pw.Page(
    margin: pw.EdgeInsets.zero,
    orientation: PageOrientation.landscape,
    build: (pw.Context ctx) {
      return _receiptPage(
        context,
        arabicFont,
        image,
        customerName,
        customerPhone,
        customerRegion,
        paymentType,
        salesmanName,
        salesmanPhone,
        type,
        number,
        date,
        subtotalAmount,
        discount,
        debtBefore,
        debtAfter,
        currency,
        notes,
        printingTime,
        printingDate,
        includeImage: true,
      );
    },
  ));

  return pdf;
}

pw.Widget _receiptPage(
  BuildContext context,
  Font arabicFont,
  dynamic image,
  String customerName,
  String customerPhone,
  String customerRegion,
  String paymentType,
  String salesmanName,
  String salesmanPhone,
  String type,
  String number,
  String date,
  String subtotalAmount,
  String discount,
  String debtBefore,
  String debtAfter,
  String currency,
  String notes,
  String printingDate,
  String printingTime, {
  bool includeImage = true,
}) {
  return pw.Row(children: [
    for (var i = 0; i < 2; i++) ...[
      pw.SizedBox(width: 90),
      pw.Container(
        width: 300,
        height: 600,
        child: pw.Column(
          mainAxisAlignment: pw.MainAxisAlignment.start,
          children: [
            pw.Image(image),
            pw.SizedBox(height: 12),
            pw.Center(child: arabicText(arabicFont, type, fontSize: 20)),
            pw.SizedBox(height: 4),
            labedContainer(customerName, 'اسم الزبون', arabicFont, width: 165),
            pw.SizedBox(height: 4),
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.center,
              children: [
                labedContainer(date, 'تاريخ القائمة', arabicFont, width: 80),
                pw.SizedBox(width: 4),
                labedContainer(number, 'رقم القائمة', arabicFont, width: 80)
              ],
            ),
            pw.SizedBox(height: 4),
            labedContainer(notes, 'الملاحظات', arabicFont, width: 165),
            pw.SizedBox(height: 10),
            _invoiceAmountColumn(
                arabicFont, subtotalAmount, discount, debtBefore, debtAfter, currency),
            pw.Spacer(),
            footerBar(arabicFont, '', 'وقت الطباعة     $printingDate   $printingTime '),
            pw.SizedBox(height: 8),
          ],
        ),
      ),
    ]
  ])

      // ]

      ; // Center
}

pw.Widget _invoiceAmountColumn(Font arabicFont, String totalAmount, String discount,
    String debtBefore, String debtAfter, String currency) {
  return pw.Column(
    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
    children: [
      _totalsItem(arabicFont, 'المبلغ المسدد', totalAmount, lightBgColor),
      pw.SizedBox(height: 2),
      _totalsItem(arabicFont, 'الخصم', discount, lightBgColor),
      pw.SizedBox(height: 2),
      _totalsItem(arabicFont, 'الطلب السابق', debtBefore, lightBgColor),
      pw.SizedBox(height: 2),
      _totalsItem(arabicFont, 'المجموع الكلي', debtAfter, darkBgColor, textColor: PdfColors.white),
      pw.SizedBox(height: 2),
      arabicText(arabicFont, currency),
    ],
  );
}

pw.Widget _totalsItem(Font arabicFont, String text1, String text2, PdfColor bgColor,
    {double width = 540, PdfColor textColor = PdfColors.black}) {
  return pw.Container(
    decoration: pw.BoxDecoration(
      borderRadius: const pw.BorderRadius.all(Radius.circular(4)), // Rounded corners
      border: pw.Border.all(color: PdfColors.grey), // Border color
      color: bgColor,
    ),
    width: width,
    padding: const pw.EdgeInsets.symmetric(horizontal: 10),
    child: pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.center,
      children: [
        arabicText(arabicFont, text2, width: 60, textColor: textColor),
        pw.Spacer(),
        arabicText(arabicFont, text1, width: 88, textColor: textColor),
      ],
    ),
  );
}
