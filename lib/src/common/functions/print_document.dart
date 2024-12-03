import 'dart:io';
import 'package:flutter/material.dart';
import 'package:printing/printing.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'package:tablets/src/common/functions/debug_print.dart';
import 'package:tablets/src/common/functions/file_system_path.dart';

Future<void> printDocument() async {
  tempPrint('hi');
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

  final filePath = gePdfpath('test_file');
  if (filePath == null) return;

  final file = File(filePath);
  await file.writeAsBytes(await pdf.save());

  tempPrint('PDF saved at: $filePath');
}
