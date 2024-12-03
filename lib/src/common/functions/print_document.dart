import 'dart:io';
import 'package:flutter/material.dart';
import 'package:pdf/widgets.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:tablets/src/common/functions/debug_print.dart';
import 'package:tablets/src/common/functions/file_system_path.dart';
import 'package:tablets/src/common/functions/utils.dart';
import 'package:tablets/src/features/transactions/controllers/transaction_screen_controller.dart';
import 'package:flutter/services.dart';
// import 'package:flutter/material.dart';
// import 'package:printing/printing.dart';
// import 'package:pdf/pdf.dart';
// import 'package:path_provider/path_provider.dart';

Future<void> printDocument(Document pdf) async {
  try {
    final filePath = gePdfpath('test_file');
    if (filePath == null) return;

    final file = File(filePath);
    await file.writeAsBytes(await pdf.save());

    tempPrint('PDF saved at: $filePath');
  } catch (e) {
    errorLog('Pdf creation failed - ($e)');
  }
}

Future<Document> getCustomerInvoicePdf(
    BuildContext context, Map<String, dynamic> transactionData) async {
  final type = translateDbTextToScreenText(context, transactionData[transactionTypeKey]);
  final pdf = pw.Document();

  // Load the custom font

  final arabicFont =
      pw.Font.ttf(await rootBundle.load("assets/fonts/NotoSansArabic-VariableFont_wdth,wght.ttf"));

  pdf.addPage(
    pw.Page(
      build: (pw.Context context) {
        return pw.Center(
          child: pw.Text(
            type,
            textDirection: pw.TextDirection.rtl,
            style: pw.TextStyle(font: arabicFont, fontSize: 24), // Use the Arabic font
          ),
        ); // Center
      },
    ),
  );
  return pdf;
}

Document getTestPdf() {
  final pdf = pw.Document();

  pdf.addPage(
    pw.Page(
      build: (pw.Context context) {
        return pw.Center(
          child: pw.Text('Hello, Flutter Printing!'),
        ); // Center
      },
    ),
  );

  return pdf;
}
