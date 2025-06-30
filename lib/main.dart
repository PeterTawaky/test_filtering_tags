import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_filtering_tags/cubit/tia_cubit.dart';
import 'package:test_filtering_tags/home_view.dart';
import 'package:test_filtering_tags/models/excel_data_model.dart';
import 'package:test_filtering_tags/service/excel_service.dart';
import 'package:test_filtering_tags/service/plc_service.dart';

void main() async {
  // PLCService.disconnect();
  WidgetsFlutterBinding.ensureInitialized();
  List<TagDataModel> excelTags = await ExcelService.readExcelData(
    localExcelPath: 'assets/tags.xlsx',
  );
  log(excelTags.length.toString());
  List<TagDataModel> filteredTags = getFilteredTags(excelTags);
  log(filteredTags.length.toString());

  runApp(MyApp(filteredTags: filteredTags));
}

List<TagDataModel> getFilteredTags(List<TagDataModel> excelTags) {
  List<TagDataModel> filteredTags = [];
  for (var tag in excelTags) {
    if (tag.tagName == 'StartButton' ||
        tag.tagName == 'StopButton' ||
        tag.tagName == 'Button' ||
        tag.tagName == 'end') {
      filteredTags.add(tag);
    }
  }
  return filteredTags;
}

class MyApp extends StatelessWidget {
  final List<TagDataModel> filteredTags;
  MyApp({super.key, required this.filteredTags});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<TiaCubit>(
      create: (context) => TiaCubit(filteredTags)..connectToPLC(),
      child: MaterialApp(home: HomeView()),
    );
  }
}
