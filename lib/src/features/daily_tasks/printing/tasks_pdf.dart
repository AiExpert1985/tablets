import 'dart:typed_data';
import 'package:flutter/services.dart'; // Required for rootBundle
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:tablets/src/features/daily_tasks/model/point.dart'; // Import printing package

class SalesPointPdfGenerator {
  static Future<Uint8List> generatePdf(List<SalesPoint> salesPoints) async {
    if (salesPoints.isEmpty) {
      // Handle empty list case - maybe return an empty PDF or throw error
      final emptyDoc = pw.Document();
      emptyDoc.addPage(pw.Page(
        build: (context) => pw.Center(child: pw.Text('No sales data available.')),
      ));
      return emptyDoc.save();
    }

    final pdf = pw.Document();

    // --- Font Loading (Optional but recommended for broader character support) ---
    // If you need specific fonts (e.g., for different languages or styles)
    // 1. Add .ttf font file(s) to an 'assets/fonts/' folder in your project
    // 2. Declare the folder in pubspec.yaml:
    // flutter:
    //   uses-material-design: true
    //   assets:
    //     - assets/fonts/
    //
    // Uncomment and modify the lines below:
    // final fontData = await rootBundle.load("assets/fonts/YourFont-Regular.ttf");
    // final ttf = pw.Font.ttf(fontData);
    // final boldFontData = await rootBundle.load("assets/fonts/YourFont-Bold.ttf");
    // final boldTtf = pw.Font.ttf(boldFontData);
    // final pw.ThemeData theme = pw.ThemeData.withFont(base: ttf, bold: boldTtf);
    // --- End Font Loading ---

    // Assuming all points in the list belong to the same salesman and date context for this report
    final String salesmanName = salesPoints.first.salesmanName;
    // Use intl for robust date formatting
    final String reportDate = DateFormat.yMMMd().format(salesPoints.first.date); // Example format

    // Calculate Summary Stats
    final int totalCount = salesPoints.length;
    final int visitedNoTransactionCount =
        salesPoints.where((p) => p.isVisited && !p.hasTransaction).length;
    final int visitedWithTransactionCount = salesPoints
        .where((p) => p.isVisited && p.hasTransaction) // As per request
        .length;
    // Note: The prompt asked for visited+transaction, which is the same condition for green.
    // If green *only* means transaction (visited is implied), then the count is simply:
    // final int transactionCount = salesPoints.where((p) => p.hasTransaction).length;

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        // If using custom fonts, add theme: theme here
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              // 1. Header
              pw.Text(
                salesmanName,
                style: pw.TextStyle(
                  fontSize: 24, // Large font
                  fontWeight: pw.FontWeight.bold, // Bold font
                  // font: boldTtf, // Use custom bold font if loaded
                ),
              ),
              pw.SizedBox(height: 5),
              pw.Text(
                'Report Date: $reportDate',
                style: const pw.TextStyle(fontSize: 12),
                // style: pw.TextStyle(fontSize: 12, font: ttf), // Use custom font if loaded
              ),
              pw.SizedBox(height: 20), // Spacing before the grid

              // 2. Body - Grid of Boxes using Wrap
              pw.Wrap(
                spacing: 10, // Horizontal space between boxes
                runSpacing: 10, // Vertical space between lines of boxes
                children: salesPoints.map((point) {
                  // Determine box color based on conditions
                  PdfColor boxColor;
                  if (point.hasTransaction) {
                    // Green if has transaction (implies visited)
                    boxColor = PdfColors.green100; // Use lighter shades for better text contrast
                  } else if (point.isVisited) {
                    // Yellow if visited but no transaction
                    boxColor = PdfColors.yellow100;
                  } else {
                    // Red if not visited
                    boxColor = PdfColors.red100;
                  }

                  return pw.Container(
                    width: 80, // Adjust width as needed
                    height: 60, // Adjust height as needed
                    padding: const pw.EdgeInsets.all(4),
                    decoration: pw.BoxDecoration(
                      color: boxColor,
                      border: pw.Border.all(color: PdfColors.grey, width: 0.5),
                      borderRadius: pw.BorderRadius.circular(4),
                    ),
                    child: pw.Center(
                      child: pw.Text(
                        point.customerName,
                        textAlign: pw.TextAlign.center,
                        style: const pw.TextStyle(fontSize: 9), // Adjust font size if needed
                        // style: pw.TextStyle(fontSize: 9, font: ttf), // Use custom font
                      ),
                    ),
                  );
                }).toList(),
              ),

              pw.Spacer(), // Pushes the summary to the bottom

              // 3. Footer - Summary
              pw.Divider(),
              pw.SizedBox(height: 10),
              pw.Text(
                'Summary:',
                style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold),
                // style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold, font: boldTtf),
              ),
              pw.SizedBox(height: 5),
              pw.Text('Total Customer Points: $totalCount'),
              pw.Text('Visited (No Transaction): $visitedNoTransactionCount'),
              pw.Text('Visited (With Transaction): $visitedWithTransactionCount'),
              // pw.Text('Has Transaction: $transactionCount'), // Alternative if needed
            ],
          );
        },
      ),
    );

    // Save the PDF document
    return pdf.save();
  }
}
