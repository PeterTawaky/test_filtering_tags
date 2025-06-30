import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:flutter/widgets.dart';
import 'package:meta/meta.dart';
import 'package:test_filtering_tags/helpers/app_enums.dart';
import 'package:test_filtering_tags/models/cubit_data_model.dart';
import 'package:test_filtering_tags/models/excel_data_model.dart';
import 'package:test_filtering_tags/service/plc_service.dart';

part 'tia_state.dart';

class TiaCubit extends Cubit<TiaState> {
  bool isConnected = false;
  Timer? _readTimer;
  bool _shouldKeepReading = false;
  List<CubitDataModel> cubitData = [];

  /// NEW: accept your tags here
  TiaCubit(List<TagDataModel> tagsData) : super(TiaInitial()) {
    // Build all your controllers & focusNodes immediately:
    cubitData = tagsData
        .map(
          (t) => CubitDataModel(
            tagName: t.tagName,
            controller: TextEditingController(),
            focusNode: FocusNode(),
            type: switchToTagType(t.type),
            address: t.address,
            access: t.access,
            acquistion: t.acquistion,
            description: t.description,
          ),
        )
        .toList();

    // then kick off the PLC connection & start reading
    connectToPLC();
  }

  Future<void> connectToPLC() async {
    PLCService.disconnect(); //should be called before connect
    final success = await PLCService.connect("192.168.0.1", 0, 1);
    isConnected = success;
    if (success) {
      _startContinuousReading();
      log('connected to PLC successfully');
    } else {
      log('Connection failed with PLC');
    }
  }

  void _startContinuousReading() {
    _shouldKeepReading = true;

    _readTimer = Timer.periodic(const Duration(milliseconds: 500), (timer) {
      if (!_shouldKeepReading || !isConnected) {
        timer.cancel();
        return;
      }
      // log('again reading');
      readAllValues();
    });
  }

  Future<void> readAllValues() async {
    if (!isConnected) return;

    try {
      //initialize controllers with value on server
      for (var tag in cubitData) {
        tag.valueFromPlc = await PLCService.read(tag.type, tag.address);
        if (!tag.focusNode.hasFocus) {
          tag.controller.text = tag.valueFromPlc.toString();
        }
      }

      log('read from plc successfully');
    } catch (e) {
      log('Read error: $e');
    }
  }

  void writeData({required CubitDataModel tag, required dynamic value}) {
    try {
      switch (tag.type) {
        case TagType.int:
          value = int.parse(tag.controller.text);
          PLCService.write(TagType.int, tag.address, value);
          break;
        case TagType.dint:
          //?which parse type int or double
          value = int.parse(tag.controller.text);
          PLCService.write(TagType.dint, tag.address, value);
          break;
        case TagType.real:
          value = double.parse(tag.controller.text);
          PLCService.write(TagType.real, tag.address, value);
          break;
        default:
          break;
      }
      log('data added successfully');
    } on Exception catch (e) {
      log('Write error: $e');
    }
  }
}
