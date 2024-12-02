import 'dart:convert';
import 'dart:io'; // Import dart:io for file handling
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart'; // Import path_provider
import 'package:tablets/generated/l10n.dart';
import 'package:tablets/src/common/functions/db_cache_inialization.dart';
import 'package:tablets/src/common/functions/debug_print.dart';
import 'package:tablets/src/common/functions/user_messages.dart';
import 'package:tablets/src/common/functions/utils.dart';
import 'package:archive/archive.dart';

void backupDataBase(BuildContext context, WidgetRef ref) async {
  final currentDate = formatDate(DateTime.now());
  final zipFileName = '${S.of(context).downloaded_backup_file_name} $currentDate.zip';
  final dataBaseNames = _getDataBaseNames(context);
  final dataBaseMaps = await _getDataBaseMaps(context, ref);
  if (context.mounted) {
    await _saveDbFiles(context, dataBaseMaps, zipFileName, dataBaseNames); // Change function name
  }
}

Future<List<List<Map<String, dynamic>>>> _getDataBaseMaps(
    BuildContext context, WidgetRef ref) async {
  await initializeAllDbCaches(context, ref);
  final salesmanData = getSalesmenDbCacheData(ref);
  final regionsData = getRegionsDbCacheData(ref);
  final categoriesData = getCategoriesDbCacheData(ref);
  final settingsData = getSettingsDbCacheData(ref);
  // because json can't deal with Date classes, we need to convert to String
  final transactionData = formatDateForJson(getTransactionDbCacheData(ref), 'date');
  final productsData = formatDateForJson(getProductsDbCacheData(ref), 'initialDate');
  final customersData = formatDateForJson(getCustomersDbCacheData(ref), 'initialDate');
  final vendorsData = formatDateForJson(getVendorsDbCacheData(ref), 'initialDate');
  if (context.mounted) {
    Navigator.of(context).pop();
  }
  final dataBaseMaps = [
    transactionData,
    salesmanData,
    productsData,
    customersData,
    vendorsData,
    regionsData,
    categoriesData,
    settingsData,
  ];
  return dataBaseMaps;
}

List<String> _getDataBaseNames(BuildContext context) {
  return [
    S.of(context).transactions,
    S.of(context).salesmen,
    S.of(context).products,
    S.of(context).customers,
    S.of(context).vendors,
    S.of(context).regions,
    S.of(context).categories,
    S.of(context).settings
  ];
}

// Change the name of the function to _saveDbFiles
Future<void> _saveDbFiles(BuildContext context, List<List<Map<String, dynamic>>> allData,
    String zipFileName, List<String> fileNames) async {
  final archive = Archive();
  for (int i = 0; i < allData.length; i++) {
    List<Map<String, dynamic>> data = allData[i];
    String jsonString = jsonEncode(data);
    List<int> bytes = utf8.encode(jsonString);
    archive.addFile(ArchiveFile('${fileNames[i]}.json', bytes.length, bytes));
  }

  // Encode the archive as a ZIP file
  final zipData = ZipEncoder().encode(archive);

  // Get the directory to save the ZIP file

  final directory = await getApplicationDocumentsDirectory();

  // Define the backup directory

  final backupDirectory = Directory('database_backup');

  // Create the backup directory if it doesn't exist

  if (!await backupDirectory.exists()) {
    await backupDirectory.create(recursive: true);
  }

  final zipFilePath = '${backupDirectory.path}/$zipFileName';

  try {
    final zipFile = File(zipFilePath);
    if (zipData != null) {
      await zipFile.writeAsBytes(zipData);
      if (context.mounted) {
        success(context, S.of(context).db_backup_success);
      }
    }
  } catch (e) {
    if (context.mounted) {
      failure(context, S.of(context).db_backup_failure);
    }
    errorPrint('backup database failed, $e');
  }
}
