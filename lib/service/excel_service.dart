import 'dart:developer';

import 'package:excel/excel.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:test_filtering_tags/models/excel_data_model.dart';

class ExcelService {
  static Future<List<TagDataModel>> readExcelData({
    required String localExcelPath,
  }) async {
    try {
      List<TagDataModel> tags = [];
      // Load the Excel file from assets
      final bytes = await rootBundle.load(localExcelPath);
      final excel = Excel.decodeBytes(bytes.buffer.asUint8List());

      // Assuming we're reading from the first sheet
      var sheet = excel.tables[excel.tables.keys.first];

      // Convert sheet data to list of lists
      // List<List<dynamic>> data = [];
      for (var row in sheet!.rows.skip(1)) {
        TagDataModel tag = TagDataModel.fromList(row);
        tags.add(tag);
      }

      return tags;
    } catch (e) {
      log('Error reading Excel file: $e');
      return [];
    }
  }
}
