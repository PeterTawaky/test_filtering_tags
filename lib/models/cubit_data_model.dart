import 'package:flutter/widgets.dart';
import 'package:test_filtering_tags/helpers/app_enums.dart';

class CubitDataModel {
  //from excel
  final String tagName;
  final TagType type;
  final String address;
  final String access;
  final int acquistion;
  final String description;
  final TextEditingController controller;
  final FocusNode focusNode;
  dynamic valueFromPlc;

  CubitDataModel({
    this.valueFromPlc,
    required this.controller,
    required this.focusNode,
    required this.tagName,
    required this.type,
    required this.address,
    required this.access,
    required this.acquistion,
    required this.description,
  });
}

switchToTagType(String type) {
  if (type == 'bool') return TagType.bool;
  if (type == 'int') return TagType.int;
  if (type == 'dint') return TagType.dint;
  if (type == 'real') return TagType.real;
}
