// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import 'package:cyc_test/widget/show_text.dart';

class ShowForm extends StatelessWidget {
  final String label;
  final Function(String) changeFunc;
  final TextInputType? textInputType;
  const ShowForm({
    Key? key,
    required this.label,
    required this.changeFunc,
    this.textInputType,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 16),
      width: 250,
      child: TextFormField(
        keyboardType: textInputType ?? TextInputType.text,
        onChanged: changeFunc,
        decoration: InputDecoration(
          label: ShowText(label: label),
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }
}
