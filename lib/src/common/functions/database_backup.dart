import 'dart:convert';
// ignore: avoid_web_libraries_in_flutter
import 'dart:html';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tablets/generated/l10n.dart';
import 'package:tablets/src/common/functions/db_cache_inialization.dart';
import 'package:tablets/src/common/functions/utils.dart';
// ignore: depend_on_referenced_packages
import 'package:archive/archive.dart';

void backupDataBase(BuildContext context, WidgetRef ref) async {
  final currentDate = formatDate(DateTime.now());
  final zipFileName = '${S.of(context).downloaded_backup_file_name} $currentDate.zip';
  final dataBaseNames = _getDataBaseNames(context);
  final dataBaseMaps = await _getDataBaseMaps(context, ref);
  _downLoadDbFiles(dataBaseMaps, zipFileName, dataBaseNames);
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

void _downLoadDbFiles(
    List<List<Map<String, dynamic>>> allData, String zipFileName, List<String> fileNames) {
  final archive = Archive();
  for (int i = 0; i < allData.length; i++) {
    List<Map<String, dynamic>> data = allData[i];
    String jsonString = jsonEncode(data);
    List<int> bytes = utf8.encode(jsonString);
    archive.addFile(ArchiveFile('${fileNames[i]}.json', bytes.length, bytes));
  }
  final zipData = ZipEncoder().encode(archive);
  final blob = Blob([zipData], 'application/zip');
  final url = Url.createObjectUrlFromBlob(blob);
  AnchorElement(href: url)
    ..setAttribute('download', zipFileName)
    ..click();
  Url.revokeObjectUrl(url);
}
