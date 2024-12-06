import 'dart:io';
import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:tablets/src/common/functions/debug_print.dart';
import 'package:tablets/src/common/functions/file_system_path.dart';
import 'package:tablets/src/common/functions/utils.dart';
import 'package:tablets/src/features/transactions/controllers/transaction_screen_controller.dart';
import 'package:printing/printing.dart';
import 'package:flutter/services.dart';

const darkBgColor = PdfColor(0.2, 0.2, 0.5);
const lightBgColor = PdfColor(0.85, 0.85, 0.99);
const bordersColor = PdfColors.grey;
const labelsColor = PdfColors.red;

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

Future<void> printDocument(BuildContext context, Map<String, dynamic> transactionData) async {
  try {
    final filePath = gePdfpath('test_file');
    if (context.mounted) {
      final pdf = await getCustomerInvoicePdf(context, transactionData);
      _printPDf(pdf);
      if (filePath == null) return;

      final file = File(filePath);
      await file.writeAsBytes(await pdf.save());
    }
    successLog('PDF saved at: $filePath');
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
            pw.SizedBox(height: 8),
            _buildSecondRow(context, arabicFont, type, number),
            pw.SizedBox(height: 12),
            _itemTitles(arabicFont),
            pw.SizedBox(height: 4),
            _itemsRow(arabicFont),
            _itemsRow2(arabicFont),
            _itemsRow3(arabicFont),
            pw.SizedBox(height: 10),
            _totals(arabicFont),
            pw.Spacer(),
            _signituresRow(arabicFont),
            pw.SizedBox(height: 25),
            footerBar(arabicFont, 'الشركة غير مسؤولة عن انتهاء الصلاحية بعد استلام البضاعة',
                'وقت طباعة القائمة    2/10/2024 11:30 ص '),
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
    mainAxisAlignment: pw.MainAxisAlignment.spaceAround,
    children: [
      pw.SizedBox(width: 5), // margin
      _labedContainer('اجل', 'الدفع', arabicFont, width: 80),
      _labedContainer('حي المحاربين', 'العنوان', arabicFont, width: 158),
      _labedContainer('077019990001', 'رقم الزبون', arabicFont, width: 90),
      _labedContainer('محمد نوفل كريم', 'اسم الزبون', arabicFont),
      pw.SizedBox(width: 5), // margin
    ],
  );
}

pw.Widget _buildSecondRow(BuildContext context, Font arabicFont, String type, String number) {
  return pw.Row(
    mainAxisAlignment: pw.MainAxisAlignment.spaceAround,
    children: [
      pw.SizedBox(width: 5), // margin
      _labedContainer('1/10/2024', 'تاريخ القائمة', arabicFont, width: 80),
      _labedContainer('13', 'رقم القائمة', arabicFont, width: 60),
      _labedContainer('قائمة بيع', 'نوع القائمة', arabicFont, width: 80),
      _labedContainer('07702255331', 'رقم المندوب', arabicFont, width: 90),
      _labedContainer('علي جاسم الشاهين', 'المندوب', arabicFont),
      pw.SizedBox(width: 5), // margin
    ],
  );
}

pw.Widget _itemTitles(Font arabicFont) {
  final childWidget = pw.Row(
    mainAxisAlignment: pw.MainAxisAlignment.spaceAround,
    children: [
      _arabicText(arabicFont, 'المجموع', width: 70, isTitle: true, textColor: PdfColors.white),
      _arabicText(arabicFont, 'السعر', width: 70, isTitle: true, textColor: PdfColors.white),
      _arabicText(arabicFont, 'الهدية', width: 70, isTitle: true, textColor: PdfColors.red),
      _arabicText(arabicFont, 'العدد', width: 70, isTitle: true, textColor: PdfColors.white),
      _arabicText(arabicFont, 'اسم المادة', width: 200, isTitle: true, textColor: PdfColors.white),
      _arabicText(arabicFont, 'ت', width: 40, isTitle: true, textColor: PdfColors.white),
    ],
  );
  // return pw.Stack(children: [
  return _coloredContainer(childWidget, bgColor: darkBgColor, 554, height: 20);
}

pw.Widget _itemsRow(Font arabicFont) {
  return pw.Container(
    width: 554,
    padding: const pw.EdgeInsets.all(2),
    child: pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.spaceAround,
      children: [
        _arabicText(arabicFont, '10,000', width: 70, isBordered: true),
        _arabicText(arabicFont, '2,000', width: 70, isBordered: true),
        _arabicText(arabicFont, '1',
            width: 70, isBordered: true, borderColor: PdfColors.red, textColor: PdfColors.red),
        _arabicText(arabicFont, '5', width: 70, isBordered: true),
        _arabicText(arabicFont, 'جاي جيهان', width: 200, isBordered: true),
        _arabicText(arabicFont, '1', width: 40, isBordered: true),
      ],
    ),
  );
}

pw.Widget _itemsRow2(Font arabicFont) {
  return pw.Container(
    width: 554,
    padding: const pw.EdgeInsets.all(2),
    child: pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.spaceAround,
      children: [
        _arabicText(arabicFont, '25,000', width: 70, isBordered: true),
        _arabicText(arabicFont, '5,000', width: 70, isBordered: true),
        _arabicText(arabicFont, '1',
            width: 70, isBordered: true, borderColor: PdfColors.red, textColor: PdfColors.red),
        _arabicText(arabicFont, '5', width: 70, isBordered: true),
        _arabicText(arabicFont, 'رز جيهان', width: 200, isBordered: true),
        _arabicText(arabicFont, '2', width: 40, isBordered: true),
      ],
    ),
  );
}

pw.Widget _itemsRow3(Font arabicFont) {
  return pw.Container(
    width: 554,
    padding: const pw.EdgeInsets.all(2),
    child: pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.spaceAround,
      children: [
        _arabicText(arabicFont, '12,000', width: 70, isBordered: true),
        _arabicText(arabicFont, '4,000', width: 70, isBordered: true),
        _arabicText(arabicFont, '1',
            width: 70, isBordered: true, borderColor: PdfColors.red, textColor: PdfColors.red),
        _arabicText(arabicFont, '3', width: 70, isBordered: true),
        _arabicText(arabicFont, 'حليب الطازج', width: 200, isBordered: true),
        _arabicText(arabicFont, '3', width: 40, isBordered: true),
      ],
    ),
  );
}

pw.Widget _totals(Font arabicFont) {
  return pw.Container(
    width: 558, // Set a fixed width for the container
    height: 130,
    child: pw.Row(mainAxisAlignment: pw.MainAxisAlignment.spaceBetween, children: [
      invoiceAmountColumn(arabicFont),
      weightColumn(arabicFont),
    ]),
  );
}

pw.Widget invoiceAmountColumn(Font arabicFont) {
  return pw.Column(
    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
    children: [
      pw.SizedBox(height: 10),
      totalsItem(arabicFont, 'مبلغ القائمة', '47,000', lightBgColor),
      totalsItem(arabicFont, 'الخصم', '2,000', lightBgColor),
      totalsItem(arabicFont, 'الطلب السابق', '100,000', lightBgColor),
      totalsItem(arabicFont, 'المجموع الكلي', '145,000', darkBgColor, textColor: PdfColors.white),
      _arabicText(arabicFont, 'دينار'),
    ],
  );
}

pw.Widget weightColumn(Font arabicFont) {
  return pw.Column(
    mainAxisAlignment: pw.MainAxisAlignment.start,
    children: [
      _labedContainer('', 'الملاحظات', arabicFont, width: 250, height: 50),
      pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          _labedContainer('16', 'عدد الكراتين', arabicFont, width: 120),
          pw.SizedBox(width: 10),
          _labedContainer('70 كيلو', 'الوزن', arabicFont, width: 120),
        ],
      ),
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
  return _coloredContainer(childWidget, 555, height: 22, bgColor: darkBgColor);
}

pw.Widget _coloredContainer(pw.Widget childWidget, double width,
    {bool isDecorated = true,
    PdfColor bgColor = PdfColors.white,
    PdfColor borderColor = PdfColors.grey300,
    double height = 22}) {
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
    padding: const pw.EdgeInsets.only(bottom: 0, left: 0), // Set padding to 0 to avoid extra space
    child: childWidget,
  );
}

pw.Widget _labedContainer(String text, String label, Font arabicFont,
    {PdfColor bgColor = PdfColors.white,
    PdfColor borderColor = PdfColors.grey,
    double width = 170,
    double height = 22}) {
  final childWidget = _arabicText(arabicFont, text);
  // return pw.Stack(children: [
  return pw.Stack(children: [
    pw.Container(
      padding: const pw.EdgeInsets.only(top: 17),
      child: _coloredContainer(childWidget, width,
          height: height, bgColor: bgColor, borderColor: borderColor),
    ),
    pw.Positioned(
      top: 3, // Adjusted position to move the label down
      right: 5, // Position at the right
      child: _arabicText(arabicFont, label,
          textColor: PdfColors.red, fontSize: 7, bgColor: PdfColors.white),
    ),
  ]);
}

pw.Widget totalsItem(Font arabicFont, String text1, String text2, PdfColor bgColor,
    {double width = 180, PdfColor textColor = PdfColors.black}) {
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
        _arabicText(arabicFont, text2, width: 60, textColor: textColor),
        pw.Spacer(),
        _arabicText(arabicFont, text1, width: 88, textColor: textColor),
      ],
    ),
  );
}

pw.Widget _arabicText(
  Font arabicFont,
  String text, {
  PdfColor? textColor,
  double? width,
  bool isTitle = false,
  double fontSize = 10,
  PdfColor? bgColor,
  PdfColor? borderColor,
  bool isBordered = false,
}) {
  return pw.Container(
    width: width,
    decoration: isBordered
        ? pw.BoxDecoration(
            borderRadius: const pw.BorderRadius.all(Radius.circular(1)), // Rounded corners
            border: pw.Border.all(color: borderColor ?? PdfColors.grey600), // Border color
          )
        : null,
    color: bgColor,
    padding: const pw.EdgeInsets.symmetric(horizontal: 3, vertical: 0),
    child: pw.Text(
      text,
      textAlign: pw.TextAlign.center,
      textDirection: pw.TextDirection.rtl,
      style: pw.TextStyle(
        font: arabicFont,
        fontSize: fontSize,
        color: textColor,
      ),
    ),
  );
}
