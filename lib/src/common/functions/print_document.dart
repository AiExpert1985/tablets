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

Future<Document> getCustomerInvoicePdf(BuildContext context, Map<String, dynamic> transactionData) async {
  final pdf = pw.Document();
  final type = translateDbTextToScreenText(context, transactionData[transactionTypeKey]);
  final number = transactionData[transactionNumberKey].toString();
  final arabicFont = pw.Font.ttf(await rootBundle.load("assets/fonts/NotoSansArabic-VariableFont_wdth,wght.ttf"));

  pdf.addPage(
    pw.Page(
      build: (pw.Context ctx) {
        return pw.Column(
          children: [
            _buildFirstRow(context, arabicFont, type, number),
            pw.SizedBox(height: 25),
            _buildSecondRow(context, arabicFont, type, number),
            pw.SizedBox(height: 15),
            _buildThirdRow(context, arabicFont, type, number),
            pw.SizedBox(height: 15),
            _buildForthRow(context, arabicFont, type, number),
            pw.SizedBox(height: 15),
            _pdfItemList(arabicFont),
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
        style: pw.TextStyle(font: arabicFont, fontSize: 22), // Use the Arabic font
      ),
      pw.SizedBox(width: 5),
      pw.Text(
        S.of(context).number,
        textDirection: pw.TextDirection.rtl,
        style: pw.TextStyle(font: arabicFont, fontSize: 22), // Use the Arabic font
      ),
      pw.SizedBox(width: 5),
      pw.Text(
        type,
        textDirection: pw.TextDirection.rtl,
        style: pw.TextStyle(font: arabicFont, fontSize: 22), // Use the Arabic font
      ),
    ],
  );
}

pw.Widget _buildSecondRow(BuildContext context, Font arabicFont, String type, String number) {
  return pw.Row(
    mainAxisAlignment: pw.MainAxisAlignment.spaceAround,
    children: [
      _pdfRectangularTextField('حي المحاربين', 'العنوان', arabicFont, width: 150),
      pw.SizedBox(width: 5),
      _pdfRectangularTextField('077019990001', 'هاتف الزبون', arabicFont, width: 135),
      pw.SizedBox(width: 5),
      _pdfRectangularTextField('محمد نوفل كريم', 'اسم الزبون', arabicFont, width: 200),
    ],
  );
}

pw.Widget _buildThirdRow(BuildContext context, Font arabicFont, String type, String number) {
  return pw.Row(
    mainAxisAlignment: pw.MainAxisAlignment.spaceAround,
    children: [
      _pdfRectangularTextField('دينار', 'العملة', arabicFont, width: 150),
      pw.SizedBox(width: 5),
      _pdfRectangularTextField('اجل', 'طريقة الدفع', arabicFont, width: 135),
      pw.SizedBox(width: 5),
      _pdfRectangularTextField('خالد جاسم علي', 'المندوب', arabicFont, width: 200),
    ],
  );
}

pw.Widget _buildForthRow(BuildContext context, Font arabicFont, String type, String number) {
  return pw.Row(
    mainAxisAlignment: pw.MainAxisAlignment.spaceAround,
    children: [
      _pdfRectangularTextField('لا يوجد ملاحظات', 'الملاحظات', arabicFont, width: 495),
    ],
  );
}

pw.Widget _pdfRectangularTextField(String text, String label, Font arabicFont, {double width = 200}) {
  // return pw.Stack(children: [
  return pw.Stack(children: [
    pw.Container(
      width: width,
      height: 35, // Increased height to provide more space for the label
      decoration: pw.BoxDecoration(
        borderRadius: const pw.BorderRadius.all(Radius.circular(4)), // Rounded corners
        border: pw.Border.all(color: PdfColors.grey), // Border color
      ),
      padding: const pw.EdgeInsets.all(0), // Set padding to 0 to avoid extra space
      child: pw.Center(
        child: pw.Text(
          text,
          textAlign: pw.TextAlign.center,
          textDirection: pw.TextDirection.rtl,
          style: pw.TextStyle(
            font: arabicFont,
            fontSize: 16,
          ),
        ),
      ),
    ),
    pw.Positioned(
      top: -5, // Adjusted position to move the label down
      right: 10, // Position at the right
      child: pw.Container(
        color: PdfColors.white, // White background for the label
        padding: const pw.EdgeInsets.symmetric(horizontal: 4), // Horizontal padding for the label
        child: pw.Text(
          label,
          textDirection: pw.TextDirection.rtl,
          style: pw.TextStyle(fontSize: 6, font: arabicFont, color: PdfColors.grey),
        ),
      ),
    ),
  ]);
}

pw.Widget _pdfItemList(Font arabicFont) {
  // return pw.Stack(children: [
  return pw.Row(children: [
    pw.Container(
      width: 495,
      height: 35, // Increased height to provide more space for the label
      decoration: pw.BoxDecoration(
        borderRadius: const pw.BorderRadius.all(Radius.circular(4)), // Rounded corners
        border: pw.Border.all(color: PdfColors.grey), // Border color
        color: PdfColors.blueGrey,
      ),
      padding: const pw.EdgeInsets.all(0), // Set padding to 0 to avoid extra space
      child: pw.Center(
        child: pw.Text(
          'ت',
          textAlign: pw.TextAlign.center,
          textDirection: pw.TextDirection.rtl,
          style: pw.TextStyle(
            font: arabicFont,
            fontSize: 16,
            // color: PdfColors.white,
          ),
        ),
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
