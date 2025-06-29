import 'package:flutter/material.dart';
import 'package:test_filtering_tags/models/cubit_data_model.dart';
import 'package:test_filtering_tags/widgets/custom_text_field.dart';

class TagWidget extends StatelessWidget {
  final CubitDataModel tag;
  const TagWidget({super.key, required this.tag});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(width: 100),

        Text(
          tag.tagName,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        const Spacer(),
        SizedBox(width: 100, child: CustomTextField(cubitDataModel: tag)),
        SizedBox(width: 100),
      ],
    );
  }
}
