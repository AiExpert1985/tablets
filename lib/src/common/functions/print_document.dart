import 'dart:io';
import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:tablets/generated/l10n.dart';
import 'package:tablets/src/common/functions/debug_print.dart';
import 'package:tablets/src/common/functions/file_system_path.dart';
import 'package:tablets/src/common/functions/utils.dart';
import 'package:tablets/src/features/transactions/controllers/transaction_screen_controller.dart';
import 'package:printing/printing.dart';
import 'package:flutter/services.dart';

// (25,25,112)

const highlightColor = PdfColor(0.2, 0.2, 0.5);

Future<void> printDocument(BuildContext context, Map<String, dynamic> transactionData) async {
  try {
    final filePath = gePdfpath('test_file');
    if (context.mounted) {
      final pdf = await getCustomerInvoicePdf(context, transactionData);
      // _printPDf(pdf);
      if (filePath == null) return;

      final file = File(filePath);
      await file.writeAsBytes(await pdf.save());
    }

    tempPrint('PDF saved at: $filePath');
  } catch (e) {
    errorLog('Pdf creation failed - ($e)');
  }
}

Future<pw.ImageProvider> loadImage(String path) async {
  final ByteData bytes = await rootBundle.load(path);
  final Uint8List list = bytes.buffer.asUint8List();
  return pw.MemoryImage(list);
}

Future<Document> getCustomerInvoicePdf(
    BuildContext context, Map<String, dynamic> transactionData) async {
  final pdf = pw.Document();
  final type = translateDbTextToScreenText(context, transactionData[transactionTypeKey]);
  final number = transactionData[transactionNumberKey].toString();
  final arabicFont =
      pw.Font.ttf(await rootBundle.load("assets/fonts/NotoSansArabic-VariableFont_wdth,wght.ttf"));
  final image = await loadImage('assets/images/invoice_logo.PNG');
  pdf.addPage(
    pw.Page(
      margin: pw.EdgeInsets.zero,
      build: (pw.Context ctx) {
        return pw.Column(
          mainAxisAlignment: pw.MainAxisAlignment.start,
          children: [
            pw.Image(image),
            _buildFirstRow(context, arabicFont, type, number),
            pw.SizedBox(height: 15),
            _buildSecondRow(context, arabicFont, type, number),
            pw.SizedBox(height: 10),
            _buildThirdRow(context, arabicFont, type, number),
            pw.SizedBox(height: 10),
            _buildForthRow(context, arabicFont, type, number),
            pw.SizedBox(height: 20),
            _pdfItemsTitles(arabicFont),
            pw.SizedBox(height: 10),
            _itemsRow(arabicFont),
            _itemsRow2(arabicFont),
            _itemsRow3(arabicFont),
            pw.SizedBox(height: 30),
            _totals(arabicFont),
            pw.Spacer(),
            _signituresRow(arabicFont),
            pw.SizedBox(height: 30),
            footerBar(arabicFont, 'الشركة غير مسؤولة عن انتهاء الصلاحية بعد استلام البضاعة',
                'تاريخ طباعة القائمة    2/10/2024'),
            pw.SizedBox(height: 15),
          ],
        ); // Center
      },
    ),
  );
  return pdf;
}

pw.Widget _buildFirstRow(BuildContext context, Font arabicFont, String type, String number) {
  return pw.Row(
    mainAxisAlignment: pw.MainAxisAlignment.center,
    children: [
      _arabicText(arabicFont, number, fontSize: 18),
      pw.SizedBox(width: 5),
      _arabicText(arabicFont, S.of(context).number, fontSize: 18),
      pw.SizedBox(width: 10),
      _arabicText(arabicFont, type, fontSize: 18),
    ],
  );
}

pw.Widget _signituresRow(Font arabicFont) {
  return pw.Row(
    mainAxisAlignment: pw.MainAxisAlignment.spaceAround,
    children: [
      _arabicText(arabicFont, 'المستلم'),
      _arabicText(arabicFont, 'السائق'),
      _arabicText(arabicFont, 'المجهز'),
    ],
  );
}

pw.Widget _buildSecondRow(BuildContext context, Font arabicFont, String type, String number) {
  return pw.Row(
    mainAxisAlignment: pw.MainAxisAlignment.spaceAround,
    children: [
      pw.SizedBox(width: 5), // margin
      _labedTextField('حي المحاربين', 'العنوان', arabicFont),
      _labedTextField('077019990001', 'موبايل', arabicFont),
      _labedTextField('محمد نوفل كريم', 'اسم الزبون', arabicFont),
      pw.SizedBox(width: 5), // margin
    ],
  );
}

pw.Widget _buildThirdRow(BuildContext context, Font arabicFont, String type, String number) {
  return pw.Row(
    mainAxisAlignment: pw.MainAxisAlignment.spaceAround,
    children: [
      pw.SizedBox(width: 5), // margin
      _labedTextField('دينار', 'العملة', arabicFont, width: 85),
      _labedTextField('اجل', 'الدفع', arabicFont, width: 85),
      _labedTextField('1/10/2024', 'التاريخ', arabicFont),
      _labedTextField('خالد جاسم علي', 'المندوب', arabicFont),
      pw.SizedBox(width: 5), // margin
    ],
  );
}

pw.Widget _buildForthRow(BuildContext context, Font arabicFont, String type, String number) {
  return pw.Row(
    mainAxisAlignment: pw.MainAxisAlignment.spaceAround,
    children: [
      _labedTextField('', 'الملاحظات', arabicFont, width: 558),
    ],
  );
}

pw.Widget _labedTextField(String text, String label, Font arabicFont, {double width = 180}) {
  // return pw.Stack(children: [
  return pw.Stack(children: [
    pw.Container(
        width: width,
        height: 30, // Increased height to provide more space for the label
        decoration: pw.BoxDecoration(
          borderRadius: const pw.BorderRadius.all(Radius.circular(4)), // Rounded corners
          border: pw.Border.all(color: PdfColors.grey), // Border color
          color: PdfColors.grey50,
        ),
        padding:
            const pw.EdgeInsets.symmetric(horizontal: 0), // Set padding to 0 to avoid extra space
        child: _arabicText(arabicFont, text)),
    pw.Positioned(
      top: -5, // Adjusted position to move the label down
      right: 10, // Position at the right
      child: pw.Container(
        color: PdfColors.grey50, // White background for the label
        padding: const pw.EdgeInsets.symmetric(horizontal: 4), // Horizontal padding for the label
        child: _arabicText(arabicFont, label, textColor: PdfColors.grey, fontSize: 7),
      ),
    ),
  ]);
}

pw.Widget _pdfItemsTitles(Font arabicFont) {
  // return pw.Stack(children: [
  return pw.Row(mainAxisAlignment: pw.MainAxisAlignment.spaceAround, children: [
    pw.Container(
      width: 558,
      height: 35, // Increased height to provide more space for the label
      decoration: pw.BoxDecoration(
        borderRadius: const pw.BorderRadius.all(Radius.circular(4)), // Rounded corners
        border: pw.Border.all(color: PdfColors.grey), // Border color
        color: highlightColor,
      ),
      padding: const pw.EdgeInsets.all(0), // Set padding to 0 to avoid extra space
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceAround,
        children: [
          _itemListCell(arabicFont, 'المجموع', 70, isTitle: true),
          _itemListCell(arabicFont, 'السعر', 70, isTitle: true),
          _itemListCell(arabicFont, 'الهدية', 70, isTitle: true),
          _itemListCell(arabicFont, 'العدد', 70, isTitle: true),
          _itemListCell(arabicFont, 'اسم المادة', 200, isTitle: true),
          _itemListCell(arabicFont, 'ت', 40, isTitle: true),
        ],
      ),
    )
  ]);
}

Future<void> _printPDf(Document pdf) async {
  try {
    // Use the Printing package to print the document
    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => await pdf.save(),
    );
  } catch (e) {
    errorLog('Printing failed - ($e)');
  }
}

pw.Widget _itemListCell(Font arabicFont, String text, double width,
    {double height = 35, bool isTitle = false}) {
  final textColor = isTitle ? PdfColors.white : PdfColors.black;
  return pw.Container(
    height: height,
    width: width,
    child: _arabicText(arabicFont, text, textColor: textColor),
  );
}

pw.Widget _itemsRow(Font arabicFont) {
  return pw.Container(
    width: 558,
    height: 30, // Height for the label
    decoration: const pw.BoxDecoration(
      border: pw.Border(
        bottom: pw.BorderSide(color: PdfColors.grey, width: 0.5), // Bottom border only
      ),
    ),
    padding: const pw.EdgeInsets.symmetric(vertical: 0), // Set padding to 0 to avoid extra space
    child: pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.spaceAround,
      children: [
        _itemListCell(arabicFont, '10,000', 70),
        _itemListCell(arabicFont, '2,000', 70),
        _itemListCell(arabicFont, '1', 70),
        _itemListCell(arabicFont, '5', 70),
        _itemListCell(arabicFont, 'جاي جيهان', 200),
        _itemListCell(arabicFont, '1', 40),
      ],
    ),
  );
}

pw.Widget _itemsRow2(Font arabicFont) {
  return pw.Container(
    width: 558,
    height: 30, // Height for the label
    decoration: const pw.BoxDecoration(
      border: pw.Border(
        bottom: pw.BorderSide(color: PdfColors.grey, width: 0.5), // Bottom border only
      ),
    ),
    padding: const pw.EdgeInsets.symmetric(vertical: 0), // Set padding to 0 to avoid extra space
    child: pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.spaceAround,
      children: [
        _itemListCell(arabicFont, '25,000', 70),
        _itemListCell(arabicFont, '5,000', 70),
        _itemListCell(arabicFont, '1', 70),
        _itemListCell(arabicFont, '5', 70),
        _itemListCell(arabicFont, 'رز جيهان', 200),
        _itemListCell(arabicFont, '2', 40),
      ],
    ),
  );
}

pw.Widget _itemsRow3(Font arabicFont) {
  return pw.Container(
    width: 558,
    height: 30, // Height for the label
    decoration: const pw.BoxDecoration(
      border: pw.Border(
        bottom: pw.BorderSide(color: PdfColors.grey, width: 0.5), // Bottom border only
      ),
    ),
    padding: const pw.EdgeInsets.symmetric(vertical: 0), // Set padding to 0 to avoid extra space
    child: pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.spaceAround,
      children: [
        _itemListCell(arabicFont, '12,000', 70),
        _itemListCell(arabicFont, '4,000', 70),
        _itemListCell(arabicFont, '1', 70),
        _itemListCell(arabicFont, '3', 70),
        _itemListCell(arabicFont, 'حليب الطازج', 200),
        _itemListCell(arabicFont, '3', 40),
      ],
    ),
  );
}

pw.Widget _totals(Font arabicFont) {
  return pw.Container(
    width: 558, // Set a fixed width for the container
    child: pw.Row(mainAxisAlignment: pw.MainAxisAlignment.spaceBetween, children: [
      invoiceAmountColumn(arabicFont),
      debtColumn(arabicFont),
    ]),
  );
}

pw.Widget invoiceAmountColumn(Font arabicFont) {
  return pw.Column(
    children: [
      totalsItem(arabicFont, 'مبلغ القائمة', '47,000'),
      totalsItem(arabicFont, 'الخصم', '2,000'),
      totalsItem(arabicFont, 'المبلغ النهائي', '45,000', isColored: true),
    ],
  );
}

pw.Widget debtColumn(Font arabicFont) {
  return pw.Container(
      padding: const pw.EdgeInsets.all(5),
      decoration: pw.BoxDecoration(
        borderRadius: const pw.BorderRadius.all(Radius.circular(4)), // Rounded corners
        border: pw.Border.all(color: PdfColors.grey300, width: 0.1), // Border color
        color: PdfColors.grey50,
      ),
      child: pw.Column(
        children: [
          totalsItem(arabicFont, 'الدين السابق', '100,000'),
          totalsItem(arabicFont, 'الدين الحالي', '145,000'),
          totalsItem(arabicFont, ' اخر تسديد', '1/10/2024'),
        ],
      ));
}

pw.Widget totalsItem(Font arabicFont, String text1, String text2,
    {bool isColored = false, double width = 175}) {
  return pw.Container(
    decoration: isColored
        ? pw.BoxDecoration(
            borderRadius: const pw.BorderRadius.all(Radius.circular(4)), // Rounded corners
            border: pw.Border.all(color: PdfColors.grey), // Border color
            color: highlightColor,
          )
        : null,
    width: width,
    padding: const pw.EdgeInsets.symmetric(horizontal: 10),
    child: pw.Row(
      children: [
        _itemListCell(arabicFont, text2, 70, isTitle: isColored),
        pw.Spacer(),
        _itemListCell(arabicFont, text1, 100, isTitle: isColored),
      ],
    ),
  );
}

pw.Widget footerBar(
  Font arabicFont,
  String text1,
  String text2,
) {
  final childWidget = pw.Row(
    children: [
      pw.SizedBox(width: 14),
      _arabicText(arabicFont, text2, fontSize: 8, textColor: PdfColors.white),
      pw.Spacer(),
      _arabicText(arabicFont, text1, fontSize: 8, textColor: PdfColors.white),
      pw.SizedBox(width: 14),
    ],
  );
  return _decoratedContainer(childWidget, 555, height: 22, bgColor: highlightColor);
}

pw.Widget _arabicText(Font arabicFont, String text,
    {PdfColor textColor = PdfColors.black, double fontSize = 12}) {
  return pw.Text(
    text,
    textAlign: pw.TextAlign.center,
    textDirection: pw.TextDirection.rtl,
    style: pw.TextStyle(
      font: arabicFont,
      fontSize: fontSize,
      color: textColor,
    ),
  );
}

pw.Widget _decoratedContainer(pw.Widget widgetChild, double width,
    {bool isDecorated = true,
    PdfColor bgColor = PdfColors.grey50,
    PdfColor borderColor = PdfColors.grey300,
    double height = 30}) {
  return pw.Container(
    width: width,
    height: height, // Increased height to provide more space for the label
    decoration: isDecorated
        ? pw.BoxDecoration(
            borderRadius: const pw.BorderRadius.all(Radius.circular(4)), // Rounded corners
            border: pw.Border.all(color: borderColor), // Border color
            color: bgColor,
          )
        : null,
    padding: const pw.EdgeInsets.symmetric(horizontal: 0), // Set padding to 0 to avoid extra space
    child: widgetChild,
  );
}
