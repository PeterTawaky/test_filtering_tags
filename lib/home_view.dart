import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_filtering_tags/cubit/tia_cubit.dart';
import 'package:test_filtering_tags/widgets/tag_widget.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SizedBox(
          width: 600,
          child: ListView.builder(
            itemCount: context.read<TiaCubit>().cubitData.length,
            itemBuilder: (context, index) => Padding(
              padding: const EdgeInsets.all(8.0),
              child: TagWidget(tag: context.read<TiaCubit>().cubitData[index]),
            ),
          ),
        ),
      ),
    );
  }
}
