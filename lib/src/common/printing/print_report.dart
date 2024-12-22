import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:tablets/src/common/functions/debug_print.dart';
import 'package:tablets/src/common/functions/utils.dart';
import 'package:tablets/src/common/printing/print_document.dart';
import 'package:flutter/services.dart';

double pageWidth = 580;
List<bool> isWideField = [];

Future<Document> getReportPdf(
  BuildContext context,
  WidgetRef ref,
  List<List<dynamic>> reportData,
  pw.ImageProvider image,
  String reportTitle,
  List<String> listTitles,
  String? startDate,
  String? endDate,
  String summaryValue,
  String summaryTitle,
) async {
  final pdf = pw.Document();
  final now = DateTime.now();
  final printingDate = DateFormat.yMd('ar').format(now);
  final printingTime = DateFormat.jm('ar').format(now);
  final arabicFont =
      pw.Font.ttf(await rootBundle.load("assets/fonts/NotoSansArabic-VariableFont_wdth,wght.ttf"));
  _setFieldsSizes(reportData);

  if (reportData.length <= 20) {
    pdf.addPage(pw.Page(
      margin: pw.EdgeInsets.zero,
      build: (pw.Context ctx) {
        return _reportPage(
          context,
          arabicFont,
          image,
          reportTitle,
          listTitles,
          reportData,
          startDate,
          endDate,
          printingDate,
          printingTime,
          summaryValue,
          summaryTitle,
          startItem: 0,
          includeImage: true,
        );
      },
    ));
  }
  return pdf;
}

void _setFieldsSizes(reportData) {
  // first we need to clear previous values from other reports
  isWideField = [];
  // first we assume all cells are normal size
  for (var _ in reportData[0]) {
    isWideField.add(false);
  }
  for (List item in reportData) {
    item = item.reversed.toList();
    for (var i = 0; i < item.length; i++) {
      if (item[i] is String && item[i].length > 15) {
        isWideField[i] = true;
      }
    }
  }
}

pw.Widget _reportPage(
  BuildContext context,
  Font arabicFont,
  dynamic image,
  String reportTitle,
  List<String> listTitles,
  List<List<dynamic>> dataList,
  String? startDate,
  String? endDate,
  String printingDate,
  String printingTime,
  String summaryValue,
  String summaryTitle, {
  int startItem = 0,
  bool includeImage = false,
}) {
  return pw.Column(
    mainAxisAlignment: pw.MainAxisAlignment.start,
    children: [
      if (includeImage) pw.Image(image),
      _buildReportHeader(arabicFont, reportTitle, startDate, endDate),
      pw.SizedBox(height: 10),
      _buildListTitles(arabicFont, listTitles),
      pw.SizedBox(height: 10),
      _buildDataList(arabicFont, dataList),
      pw.SizedBox(height: 10),
      _buildSummary(arabicFont, summaryValue, summaryTitle),
      pw.Spacer(),
      footerBar(arabicFont, 'وقت الطباعة ', '$printingDate   $printingTime '),
      pw.SizedBox(height: 10),
    ],
  ); // Center
}

pw.Widget _buildSummary(Font arabicFont, String summaryValue, String summaryTitle) {
  return coloredContainer(
    pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.spaceAround,
      children: [
        arabicText(arabicFont, summaryValue),
        arabicText(arabicFont, summaryTitle),
      ],
    ),
    bgColor: lightBgColor,
    pageWidth,
    height: 20,
  );
}

pw.Widget _buildReportHeader(
    Font arabicFont, String reportTitle, String? startDate, String? endDate) {
  return pw.Container(
    height: 50,
    child: pw.Column(
      children: [
        pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.center,
          children: [
            if (startDate != null || endDate != null)
              pw.Container(
                padding: const pw.EdgeInsets.all(8),
                child: pw.Column(
                  children: [
                    if (startDate != null)
                      pw.Row(
                        children: [
                          arabicText(arabicFont, 'من تاريخ'),
                          pw.SizedBox(width: 5),
                          arabicText(arabicFont, startDate)
                        ],
                      ),
                    if (endDate != null)
                      pw.Row(
                        children: [
                          arabicText(arabicFont, 'الى تاريخ'),
                          pw.SizedBox(width: 5),
                          arabicText(arabicFont, endDate)
                        ],
                      ),
                  ],
                ),
              ),
            if (startDate != null || endDate != null) pw.Spacer(),
            pw.Container(
              padding: const pw.EdgeInsets.all(8),
              child: arabicText(arabicFont, reportTitle),
            ),
          ],
        ),
      ],
    ),
  );
}

pw.Widget _buildListTitles(Font arabicFont, List<dynamic> titlesList) {
  titlesList = titlesList.reversed.toList();
  List<pw.Widget> itemsList = [];
  for (int i = 0; i < titlesList.length; i++) {
    itemsList.add(_buildHeaderCell(arabicFont, titlesList[i], i));
  }
  pw.Widget titlesContainer = pw.Container(
    child: pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.spaceAround,
      children: itemsList,
    ),
  );
  return coloredContainer(
    titlesContainer,
    bgColor: darkBgColor,
    pageWidth,
    height: 20,
  );
}

pw.Widget _buildDataList(Font arabicFont, List<List<dynamic>> dataList) {
  List<pw.Widget> itemsList = [];
  for (int i = 0; i < dataList.length; i++) {
    itemsList.add(_buildItem(arabicFont, dataList[i]));
  }

  return pw.Container(child: pw.Column(children: itemsList));
}

pw.Widget _buildItem(Font arabicFont, List<dynamic> dataRow) {
  List<pw.Widget> item = [];
  dataRow = dataRow.reversed.toList();
  for (int i = 0; i < dataRow.length; i++) {
    item.add(_buildDataCell(arabicFont, dataRow[i], i));
  }
  return pw.Container(
    padding: const pw.EdgeInsets.symmetric(horizontal: 8),
    child: pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.spaceAround,
      children: item,
    ),
  );
}

pw.Widget _buildDataCell(Font arabicFont, dynamic value, int i) {
  String cellText = '';
  if (value is DateTime) {
    cellText = formatDate(value);
  } else if (value is num || value is double || value is int) {
    cellText = doubleToStringWithComma(value);
  } else if (value is String && value.trim().isEmpty) {
    cellText = '-';
  } else {
    cellText = value;
  }
  if (isWideField[i]) {
    return pw.Container(
        width: 140,
        padding: const pw.EdgeInsets.all(1),
        child: arabicText(arabicFont, cellText, isBordered: true));
  }
  return pw.Expanded(
      child: pw.Container(
          padding: const pw.EdgeInsets.all(1),
          child: arabicText(arabicFont, cellText, isBordered: true)));
}

pw.Widget _buildHeaderCell(Font arabicFont, String text, int i) {
  if (isWideField[i]) {
    return pw.Container(
      width: 140,
      padding: const pw.EdgeInsets.all(1),
      child: arabicText(arabicFont, text, isTitle: true, textColor: PdfColors.white),
    );
  }
  return pw.Expanded(
    child: pw.Container(
      padding: const pw.EdgeInsets.all(1),
      child: arabicText(arabicFont, text, isTitle: true, textColor: PdfColors.white),
    ),
  );
}
