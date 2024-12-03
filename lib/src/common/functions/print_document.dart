import 'dart:io';
import 'package:flutter/material.dart';
import 'package:pdf/widgets.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:tablets/generated/l10n.dart';
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
  final pdf = pw.Document();
  final type = translateDbTextToScreenText(context, transactionData[transactionTypeKey]);
  final number = transactionData[transactionNumberKey].toString();
  final arabicFont =
      pw.Font.ttf(await rootBundle.load("assets/fonts/NotoSansArabic-VariableFont_wdth,wght.ttf"));

  pdf.addPage(
    pw.Page(
      build: (pw.Context ctx) {
        return pw.Center(
          child: _buildFirstRow(context, arabicFont, type, number),
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
