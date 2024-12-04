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
            pw.SizedBox(height: 15),
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
      pw.Text(
        number,
        textDirection: pw.TextDirection.rtl,
        style: pw.TextStyle(font: arabicFont, fontSize: 18), // Use the Arabic font
      ),
      pw.SizedBox(width: 5),
      pw.Text(
        S.of(context).number,
        textDirection: pw.TextDirection.rtl,
        style: pw.TextStyle(font: arabicFont, fontSize: 18), // Use the Arabic font
      ),
      pw.SizedBox(width: 10),
      pw.Text(
        type,
        textDirection: pw.TextDirection.rtl,
        style: pw.TextStyle(font: arabicFont, fontSize: 18), // Use the Arabic font
      ),
    ],
  );
}

pw.Widget _buildSecondRow(BuildContext context, Font arabicFont, String type, String number) {
  return pw.Row(
    mainAxisAlignment: pw.MainAxisAlignment.spaceAround,
    children: [
      pw.SizedBox(width: 5), // margin
      _pdfRectangularTextField('حي المحاربين', 'العنوان', arabicFont),
      _pdfRectangularTextField('077019990001', 'موبايل', arabicFont),
      _pdfRectangularTextField('محمد نوفل كريم', 'اسم الزبون', arabicFont),
      pw.SizedBox(width: 5), // margin
    ],
  );
}

pw.Widget _buildThirdRow(BuildContext context, Font arabicFont, String type, String number) {
  return pw.Row(
    mainAxisAlignment: pw.MainAxisAlignment.spaceAround,
    children: [
      pw.SizedBox(width: 5), // margin
      _pdfRectangularTextField('دينار', 'العملة', arabicFont),
      _pdfRectangularTextField('اجل', 'طريقة الدفع', arabicFont),
      _pdfRectangularTextField('خالد جاسم علي', 'المندوب', arabicFont),
      pw.SizedBox(width: 5), // margin
    ],
  );
}

pw.Widget _buildForthRow(BuildContext context, Font arabicFont, String type, String number) {
  return pw.Row(
    mainAxisAlignment: pw.MainAxisAlignment.spaceAround,
    children: [
      _pdfRectangularTextField('', 'الملاحظات', arabicFont, width: 558),
    ],
  );
}

pw.Widget _pdfRectangularTextField(String text, String label, Font arabicFont,
    {double width = 180}) {
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
      child: pw.Center(
        child: pw.Text(
          text,
          textAlign: pw.TextAlign.center,
          textDirection: pw.TextDirection.rtl,
          style: pw.TextStyle(
            font: arabicFont,
            fontSize: 13,
          ),
        ),
      ),
    ),
    pw.Positioned(
      top: -5, // Adjusted position to move the label down
      right: 10, // Position at the right
      child: pw.Container(
        color: PdfColors.grey50, // White background for the label
        padding: const pw.EdgeInsets.symmetric(horizontal: 4), // Horizontal padding for the label
        child: pw.Text(
          label,
          textDirection: pw.TextDirection.rtl,
          style: pw.TextStyle(fontSize: 7, font: arabicFont, color: PdfColors.grey),
        ),
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
        color: PdfColors.blueGrey,
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
  return pw.Container(
    height: height,
    width: width,
    child: pw.Text(
      text,
      textAlign: pw.TextAlign.center,
      textDirection: pw.TextDirection.rtl,
      style: pw.TextStyle(
        font: arabicFont,
        fontSize: 12,
        color: isTitle ? PdfColors.white : PdfColors.black,
      ),
    ),
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
        _itemListCell(arabicFont, '10000', 70),
        _itemListCell(arabicFont, '2000', 70),
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
        _itemListCell(arabicFont, '25000', 70),
        _itemListCell(arabicFont, '5000', 70),
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
        _itemListCell(arabicFont, '12000', 70),
        _itemListCell(arabicFont, '4000', 70),
        _itemListCell(arabicFont, '1', 70),
        _itemListCell(arabicFont, '3', 70),
        _itemListCell(arabicFont, 'حليب الطازج', 200),
        _itemListCell(arabicFont, '3', 40),
      ],
    ),
  );
}
